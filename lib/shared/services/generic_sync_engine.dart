import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:glint/shared/database/app_database.dart';
import 'package:glint/shared/services/sync_resolver.dart';

/// Sincroniza cualquier tabla de Drift con su gemela en Supabase, sin código
/// específico por tabla: se apoya en los metadatos de columnas (`$columns`)
/// para serializar y en que ambas tablas comparten los nombres de columna.
///
/// Reglas:
///  - Sube las filas con `pendiente_sync = 1` (cola offline).
///  - Aplica las tumbas: borra en el servidor lo que se borró en local.
///  - Baja las filas remotas y resuelve conflictos por última escritura.
///  - Borra en local lo que otro dispositivo borró (filas ya sincronizadas
///    que ya no están en el servidor).
///
/// Los triggers de SQLite que marcan filas como pendientes se suprimen durante
/// las escrituras locales de la sincronización (ver [AppDatabase.marcarSyncActivo]),
/// para que los datos que llegan del servidor no se vuelvan a marcar y reboten.
class GenericSyncEngine {
  final AppDatabase _db;
  final SupabaseClient _supabase;

  GenericSyncEngine(this._db, this._supabase);

  /// Mapa nombre-de-tabla → info de Drift, para las tablas sincronizables.
  Map<String, TableInfo> get _tablas => {
        'transactions': _db.transactions,
        'budgets': _db.budgets,
        'savings_goals': _db.savingsGoals,
        'debts': _db.debts,
        'recurring_expenses': _db.recurringExpenses,
        'notes': _db.notes,
        'events': _db.events,
        'routines': _db.routines,
      };

  /// [incremental] = true baja solo las filas cambiadas desde la última marca
  /// de agua (rápido, para los avisos de Realtime); false hace una pasada
  /// completa que además reconcilia borrados hechos en otro dispositivo.
  Future<void> sincronizarTodo(String usuarioId, {bool incremental = false}) async {
    // Cada tabla en su propio try/catch: si una falla (un problema puntual de
    // red o de esquema), las demás igual se sincronizan.
    for (final entry in _tablas.entries) {
      try {
        await _sincronizarTabla(entry.key, entry.value, usuarioId, incremental);
      } catch (e) {
        debugPrint('Glint sync: tabla ${entry.key} falló — $e');
      }
    }
  }

  /// Sincroniza solo las tablas indicadas (para el Realtime quirúrgico: cuando
  /// llega un aviso, resincroniza únicamente la tabla que cambió).
  Future<void> sincronizarTablas(
    String usuarioId,
    Iterable<String> nombres, {
    bool incremental = false,
  }) async {
    for (final nombre in nombres) {
      final tabla = _tablas[nombre];
      if (tabla == null) continue;
      try {
        await _sincronizarTabla(nombre, tabla, usuarioId, incremental);
      } catch (e) {
        debugPrint('Glint sync: tabla $nombre falló — $e');
      }
    }
  }

  Future<void> _sincronizarTabla(
    String nombre,
    TableInfo tabla,
    String usuarioId,
    bool incremental,
  ) async {
    await _subirPendientes(nombre, tabla, usuarioId);
    await _aplicarTumbas(nombre, usuarioId);
    await _bajarYFusionar(nombre, tabla, usuarioId, incremental);
  }

  // ── Subida ──────────────────────────────────────────────────────────────

  Future<void> _subirPendientes(
    String nombre,
    TableInfo tabla,
    String usuarioId,
  ) async {
    final pendientes = await _db.customSelect(
      'SELECT * FROM $nombre WHERE usuario_id = ? AND pendiente_sync = 1',
      variables: [Variable<String>(usuarioId)],
    ).get();
    if (pendientes.isEmpty) return;

    final filas = [for (final r in pendientes) _aJson(tabla, r.data)];
    await _supabase.from(nombre).upsert(filas);

    // Limpiar la marca sin que el trigger la vuelva a poner.
    final ids = [for (final r in pendientes) r.data['id'] as String];
    await _enModoSync(() async {
      final ph = List.filled(ids.length, '?').join(',');
      await _db.customStatement(
        'UPDATE $nombre SET pendiente_sync = 0 WHERE id IN ($ph)',
        ids,
      );
    });
  }

  // ── Tumbas (borrados locales que hay que propagar) ──────────────────────

  Future<void> _aplicarTumbas(String nombre, String usuarioId) async {
    final tumbas = await (_db.select(_db.syncTombstones)
          ..where((t) =>
              t.usuarioId.equals(usuarioId) & t.tabla.equals(nombre)))
        .get();

    for (final t in tumbas) {
      await _supabase.from(nombre).delete().eq('id', t.filaId).eq('usuario_id', usuarioId);
      await (_db.delete(_db.syncTombstones)
            ..where((x) => x.filaId.equals(t.filaId) & x.tabla.equals(nombre)))
          .go();
    }
  }

  // ── Bajada y fusión ─────────────────────────────────────────────────────

  Future<void> _bajarYFusionar(
    String nombre,
    TableInfo tabla,
    String usuarioId,
    bool incremental,
  ) async {
    await _asegurarTablaWatermarks();
    final wmSeg = await _leerWatermark(nombre, usuarioId);
    // Solo se usa el modo incremental si ya hay una marca previa; el primer
    // sync (marca = 0) siempre es completo.
    final usarIncremental = incremental && wmSeg > 0;

    // Descarga. Incremental: solo lo cambiado desde la marca (con 60 s de
    // solape para tolerar desfases de reloj entre dispositivos; los upsert son
    // idempotentes, así que re-aplicar unas filas no hace daño). Completa: todo
    // (y así puede detectar borrados por ausencia).
    final consulta =
        _supabase.from(nombre).select().eq('usuario_id', usuarioId);
    final remotas = (usarIncremental
        ? await consulta.gte('actualizado_en', segundosAIso(wmSeg - 60))
        : await consulta) as List<dynamic>;

    // Estado local: id → (actualizado_en, pendiente_sync)
    final locales = <String, Map<String, dynamic>>{};
    for (final r in await _db.customSelect(
      'SELECT id, actualizado_en, pendiente_sync FROM $nombre WHERE usuario_id = ?',
      variables: [Variable<String>(usuarioId)],
    ).get()) {
      locales[r.data['id'] as String] = r.data;
    }

    var huboCambios = false;
    var maxSeg = wmSeg;
    final idsRemotas = <String>{};
    for (final row in remotas) {
      final remote = row as Map<String, dynamic>;
      final id = remote['id'] as String;
      idsRemotas.add(id);

      final segRemoto = isoASegundos(remote['actualizado_en'] as String?);
      if (segRemoto != null && segRemoto > maxSeg) maxSeg = segRemoto;

      final local = locales[id];
      final accion = resolver(
        localActualizado: local == null
            ? null
            : _segundosADate(local['actualizado_en'] as int),
        remotoActualizado:
            segRemoto == null ? null : _segundosADate(segRemoto),
      );
      if (accion == AccionSync.bajar) {
        await _enModoSync(() => _aplicarLocal(nombre, tabla, remote));
        huboCambios = true;
      }
    }

    // Borrados de otro dispositivo: filas ya sincronizadas (no pendientes) que
    // ya no existen en el servidor. Solo se puede inferir en pasada COMPLETA
    // (en incremental no tenemos el listado total de ids remotos). El sondeo
    // periódico completo y el DELETE de Realtime cubren estos casos.
    //
    // SEGURIDAD: nunca inferimos borrados si el servidor devolvió CERO filas.
    // Un `[]` es indistinguible de una descarga fallida; sin este guardado, un
    // fallo así borraría TODOS los datos locales del módulo.
    if (!usarIncremental) {
      final aBorrar = remotas.isEmpty
          ? const <String>[]
          : [
              for (final e in locales.entries)
                if ((e.value['pendiente_sync'] as int) == 0 &&
                    !idsRemotas.contains(e.key))
                  e.key
            ];
      if (aBorrar.isNotEmpty) {
        await _enModoSync(() async {
          final ph = List.filled(aBorrar.length, '?').join(',');
          await _db.customStatement(
            'DELETE FROM $nombre WHERE id IN ($ph)',
            aBorrar,
          );
        });
        huboCambios = true;
      }
    }

    // CLAVE: las escrituras con SQL crudo (customStatement) NO avisan a los
    // streams `.watch()`. Avisamos a mano qué tabla cambió.
    if (huboCambios) {
      _db.notifyUpdates({TableUpdate(nombre, kind: UpdateKind.update)});
    }

    // Avanzar la marca de agua a la fila más reciente vista.
    if (maxSeg > wmSeg) await _guardarWatermark(nombre, usuarioId, maxSeg);
  }

  // ── Marca de agua (para el sync incremental) ──────────────────────────────

  bool _wmTablaLista = false;

  Future<void> _asegurarTablaWatermarks() async {
    if (_wmTablaLista) return;
    await _db.customStatement(
      'CREATE TABLE IF NOT EXISTS sync_watermarks ('
      'tabla TEXT NOT NULL, usuario_id TEXT NOT NULL, '
      'ultima INTEGER NOT NULL DEFAULT 0, PRIMARY KEY (tabla, usuario_id))',
    );
    _wmTablaLista = true;
  }

  Future<int> _leerWatermark(String tabla, String usuarioId) async {
    final r = await _db.customSelect(
      'SELECT ultima FROM sync_watermarks WHERE tabla = ? AND usuario_id = ?',
      variables: [Variable<String>(tabla), Variable<String>(usuarioId)],
    ).get();
    return r.isEmpty ? 0 : (r.first.data['ultima'] as int);
  }

  Future<void> _guardarWatermark(String tabla, String usuarioId, int seg) async {
    await _db.customStatement(
      'INSERT INTO sync_watermarks (tabla, usuario_id, ultima) VALUES (?, ?, ?) '
      'ON CONFLICT (tabla, usuario_id) DO UPDATE SET ultima = excluded.ultima',
      [tabla, usuarioId, seg],
    );
  }

  Future<void> _aplicarLocal(
    String nombre,
    TableInfo tabla,
    Map<String, dynamic> remote,
  ) async {
    final cols = <String>[];
    final args = <Object?>[];
    for (final col in tabla.$columns) {
      if (col.name == 'pendiente_sync') continue;
      cols.add(col.name);
      args.add(_valorParaLocal(col.type, remote[col.name]));
    }
    cols.add('pendiente_sync');
    args.add(0);

    final placeholders = List.filled(args.length, '?').join(',');
    final updates = cols.map((c) => '$c = excluded.$c').join(', ');
    await _db.customStatement(
      'INSERT INTO $nombre (${cols.join(',')}) VALUES ($placeholders) '
      'ON CONFLICT(id) DO UPDATE SET $updates',
      args,
    );
  }

  // ── Serialización ───────────────────────────────────────────────────────

  /// Fila local (valores crudos de SQLite) → JSON para Supabase.
  Map<String, dynamic> _aJson(TableInfo tabla, Map<String, dynamic> data) {
    final m = <String, dynamic>{};
    for (final col in tabla.$columns) {
      if (col.name == 'pendiente_sync') continue; // marca local, no viaja
      final v = data[col.name];
      if (v == null) {
        m[col.name] = null;
      } else if (col.type == DriftSqlType.dateTime) {
        m[col.name] = segundosAIso(v as int);
      } else if (col.type == DriftSqlType.bool) {
        m[col.name] = (v as int) != 0;
      } else {
        m[col.name] = v;
      }
    }
    return m;
  }

  /// Valor remoto (JSON) → valor crudo para guardar en SQLite.
  Object? _valorParaLocal(Object tipo, Object? v) {
    if (v == null) return null;
    if (tipo == DriftSqlType.dateTime) {
      return isoASegundos(v as String);
    }
    if (tipo == DriftSqlType.bool) {
      return (v == true || v == 1) ? 1 : 0;
    }
    return v;
  }

  DateTime _segundosADate(int s) =>
      DateTime.fromMillisecondsSinceEpoch(s * 1000, isUtc: true);

  /// Ejecuta [fn] con los triggers de marcado suprimidos.
  Future<void> _enModoSync(Future<void> Function() fn) async {
    await _db.marcarSyncActivo(true);
    try {
      await fn();
    } finally {
      await _db.marcarSyncActivo(false);
    }
  }
}
