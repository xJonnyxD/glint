import 'dart:async';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/foundation.dart' show debugPrint, ValueNotifier;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:glint/shared/database/app_database.dart';
import 'package:glint/shared/services/generic_sync_engine.dart';
import 'package:glint/shared/services/profile_sync_service.dart';
import 'package:glint/shared/services/sync_resolver.dart';
import 'package:glint/features/habits/data/habit_remote_data_source.dart';
import 'package:glint/features/habits/domain/habit_entity.dart';

/// Estado visible del sync, para el indicador de la UI.
enum SyncEstado { inactivo, sincronizando, alDia, error }

/// Orquesta la sincronización de hábitos con Supabase en ambos sentidos.
///
/// Modelo:
///  - Cada cambio local marca la fila con `pendienteSync = true` y actualiza
///    `actualizadoEn`. Eso es la cola offline: "sube lo pendiente cuando puedas".
///  - Los borrados dejan una tumba en `syncTombstones` para poder borrarlos
///    también en el servidor (una fila ya borrada no se puede "subir").
///  - Al bajar, los conflictos se resuelven por última escritura (ver
///    [SyncResolver]).
///
/// Todo lo remoto puede fallar sin romper la app: si no hay red, lo pendiente
/// se queda pendiente y se reintenta en la siguiente sincronización.
class SyncManager {
  static SyncManager? _instance;

  final AppDatabase _db;
  final SupabaseClient _supabase;
  final HabitRemoteDataSource _habitRemote;
  final GenericSyncEngine _generico;

  /// El perfil va aparte del motor genérico: su fila se identifica por `id` y
  /// solo puede escribir unas columnas concretas. Ver [ProfileSyncService].
  final ProfileSyncService _perfil;

  bool _sincronizando = false;
  Timer? _periodico;
  Timer? _debounceRt;
  RealtimeChannel? _canal;
  String? _usuarioActual;

  /// Tablas que Realtime avisó que cambiaron (se acumulan durante el debounce
  /// para sincronizar solo esas). `_rtFull` marca que hubo un DELETE, que exige
  /// pasada completa de esas tablas para reconciliar el borrado en local.
  final Set<String> _tablasRtPendientes = {};
  bool _rtFull = false;

  /// Estado del sync para el indicador de la UI (spinner "sincronizando",
  /// "al día", etc.).
  static final ValueNotifier<SyncEstado> estado =
      ValueNotifier(SyncEstado.inactivo);

  /// Si hay Realtime desplegado, los cambios llegan al instante por websocket.
  /// Se controla con `--dart-define=GLINT_REALTIME=true` (igual que el módulo
  /// de grupos). Sin él, la frescura la da el sondeo periódico.
  static final bool realtimeHabilitado =
      const bool.fromEnvironment('GLINT_REALTIME', defaultValue: false);

  /// Sondeo periódico de respaldo. Con Realtime activo, los cambios llegan al
  /// instante, así que el sondeo solo hace de red de seguridad y reconcilia
  /// borrados: por eso pasa de 20 s a 3 min (≈10× menos hits al servidor).
  /// Además es una pasada COMPLETA (no incremental) para poder detectar filas
  /// borradas en otro dispositivo por ausencia.
  static const Duration _intervalo = Duration(minutes: 3);

  /// Tablas personales a escuchar por Realtime y su columna de dueño (habits y
  /// sus completaciones usan `user_id`; el resto `usuario_id`).
  static const Map<String, String> _tablasRealtime = {
    'habits': 'user_id',
    'habit_completions': 'user_id',
    'transactions': 'usuario_id',
    'budgets': 'usuario_id',
    'savings_goals': 'usuario_id',
    'debts': 'usuario_id',
    'recurring_expenses': 'usuario_id',
    'notes': 'usuario_id',
    'events': 'usuario_id',
    'routines': 'usuario_id',
  };

  SyncManager({
    required SupabaseClient supabase,
    required AppDatabase db,
  })  : _db = db,
        _supabase = supabase,
        _habitRemote = HabitRemoteDataSource(supabase),
        _generico = GenericSyncEngine(db, supabase),
        _perfil = ProfileSyncService(db, supabase);

  static void initialize({
    required SupabaseClient supabase,
    required AppDatabase db,
  }) {
    _instance = SyncManager(supabase: supabase, db: db);
  }

  static SyncManager get instance {
    final i = _instance;
    if (i == null) {
      throw Exception('SyncManager no inicializado. Llama a initialize().');
    }
    return i;
  }

  /// La base de datos local (la usa, p. ej., la copia de seguridad).
  AppDatabase get baseDatos => _db;

  /// Se llama al iniciar sesión. Sincroniza ya y arranca el ciclo periódico
  /// que mantiene al día los módulos sin disparo propio. No espera.
  Future<void> sincronizarAlInicio(String usuarioId) {
    _usuarioActual = usuarioId;
    _periodico?.cancel();
    _periodico = Timer.periodic(
      _intervalo,
      (_) => empujarEnSegundoPlano(usuarioId),
    );
    if (realtimeHabilitado) _suscribirRealtime(usuarioId);
    return sincronizar(usuarioId);
  }

  /// Se suscribe por Realtime a las tablas personales del usuario; ante
  /// cualquier cambio (hecho en otro dispositivo) dispara una sincronización,
  /// con un pequeño debounce para agrupar ráfagas.
  void _suscribirRealtime(String usuarioId) {
    final canalPrevio = _canal;
    if (canalPrevio != null) {
      _supabase.removeChannel(canalPrevio);
    }
    final canal = _supabase.channel('glint-personal-$usuarioId');
    _tablasRealtime.forEach((tabla, columna) {
      canal.onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: tabla,
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: columna,
          value: usuarioId,
        ),
        callback: (payload) {
          // Solo resincronizamos la tabla que cambió (quirúrgico). INSERT/UPDATE
          // → incremental; DELETE → pasada completa de esa tabla.
          _tablasRtPendientes.add(tabla);
          if (payload.eventType == PostgresChangeEvent.delete) _rtFull = true;
          _debounceRt?.cancel();
          _debounceRt =
              Timer(const Duration(milliseconds: 400), _procesarRealtime);
        },
      );
    });
    canal.subscribe();
    _canal = canal;
  }

  /// Procesa el lote de tablas que Realtime avisó, sincronizando SOLO esas.
  Future<void> _procesarRealtime() async {
    final u = _usuarioActual;
    if (u == null || _tablasRtPendientes.isEmpty) return;
    // Si hay una sincronización en curso, reintenta pronto sin perder el lote.
    if (_sincronizando) {
      _debounceRt = Timer(const Duration(milliseconds: 500), _procesarRealtime);
      return;
    }
    final tablas = Set<String>.from(_tablasRtPendientes);
    final full = _rtFull;
    _tablasRtPendientes.clear();
    _rtFull = false;

    _sincronizando = true;
    estado.value = SyncEstado.sincronizando;
    var huboError = false;
    try {
      // Hábitos tienen lógica propia (rachas): si cambió su tabla, se corre su
      // ciclo (es una sola tabla, barato).
      if (tablas.contains('habits') || tablas.contains('habit_completions')) {
        await _subirPendientes(u);
        await _aplicarTumbas(u);
        await _bajarYFusionar(u);
      }
      final genericas =
          tablas.where((t) => t != 'habits' && t != 'habit_completions');
      if (genericas.isNotEmpty) {
        await _generico.sincronizarTablas(u, genericas, incremental: !full);
      }
    } catch (e) {
      huboError = true;
      debugPrint('Glint sync (realtime): $e');
    } finally {
      _sincronizando = false;
      estado.value = huboError ? SyncEstado.error : SyncEstado.alDia;
    }
  }

  /// Sincroniza ya con el usuario activo, si lo hay. Para llamar cuando la app
  /// vuelve a primer plano (así al cambiar de dispositivo se ve al instante).
  /// Por defecto hace pasada completa (reconcilia borrados); Realtime la llama
  /// en modo incremental para los INSERT/UPDATE.
  void sincronizarAhora({bool incremental = false}) {
    final u = _usuarioActual;
    if (u != null) empujarEnSegundoPlano(u, incremental: incremental);
  }

  /// Detiene el ciclo periódico y la escucha Realtime (al cerrar sesión).
  void detener() {
    _periodico?.cancel();
    _periodico = null;
    _debounceRt?.cancel();
    _tablasRtPendientes.clear();
    _rtFull = false;
    final c = _canal;
    if (c != null) {
      _supabase.removeChannel(c);
      _canal = null;
    }
    _usuarioActual = null;
    estado.value = SyncEstado.inactivo;
  }

  /// Ciclo completo: primero sube lo pendiente (para no perder cambios
  /// locales al bajar), luego baja y resuelve conflictos. Hábitos con su
  /// lógica propia; el resto de módulos con el motor genérico.
  Future<void> sincronizar(String usuarioId, {bool incremental = false}) async {
    if (_sincronizando) return; // evita solapamientos
    _sincronizando = true;
    estado.value = SyncEstado.sincronizando;
    var huboError = false;
    try {
      await _subirPendientes(usuarioId);
      await _aplicarTumbas(usuarioId);
      await _bajarYFusionar(usuarioId);
    } catch (e) {
      huboError = true;
      debugPrint('Glint sync (hábitos): ciclo interrumpido — $e');
    }
    try {
      await _generico.sincronizarTodo(usuarioId, incremental: incremental);
    } catch (e) {
      huboError = true;
      debugPrint('Glint sync (módulos): ciclo interrumpido — $e');
      // Lo pendiente sigue pendiente; se reintenta la próxima vez.
    }
    try {
      await _perfil.sincronizar(usuarioId);
    } catch (e) {
      huboError = true;
      // Un 42501 aquí significa que se está mandando una columna sin permiso
      // (ver ProfileSyncService.columnasQueViajan). Se refleja en el indicador
      // de sincronización, que si no se quedaría en "al día" mintiendo.
      debugPrint('Glint sync (perfil): $e');
    } finally {
      _sincronizando = false;
      estado.value = huboError ? SyncEstado.error : SyncEstado.alDia;
    }
  }

  /// Sube el perfil ya, sin esperar al ciclo de 3 minutos. Se llama justo
  /// después de que el usuario guarde un cambio, para que llegue cuanto antes
  /// a sus otros dispositivos y a lo que ven sus amigos.
  Future<void> sincronizarPerfilAhora(String usuarioId) async {
    if (_sincronizando) return; // el ciclo en curso ya lo llevará
    try {
      await _perfil.sincronizar(usuarioId);
    } catch (e) {
      debugPrint('Glint sync (perfil, inmediato): $e');
    }
  }

  /// Pide una sincronización en segundo plano tras un cambio local o un aviso
  /// de Realtime. No lanza.
  void empujarEnSegundoPlano(String usuarioId, {bool incremental = false}) {
    unawaited(sincronizar(usuarioId, incremental: incremental));
  }

  // ── Subida ────────────────────────────────────────────────────────────────

  Future<void> _subirPendientes(String usuarioId) async {
    // Hábitos con cambios locales
    final habitosPend = await (_db.select(_db.habits)
          ..where((h) =>
              h.usuarioId.equals(usuarioId) & h.pendienteSync.equals(true)))
        .get();

    for (final row in habitosPend) {
      await _habitRemote.subirHabito(
        _rowToEntity(row),
        usuarioId,
        row.actualizadoEn,
      );
      // Solo se limpia la marca si la subida no lanzó.
      await (_db.update(_db.habits)..where((h) => h.id.equals(row.id)))
          .write(const HabitsCompanion(pendienteSync: drift.Value(false)));
    }

    // Completaciones con cambios locales (subida en lote)
    final compPend = await (_db.select(_db.habitCompletions)
          ..where((c) =>
              c.usuarioId.equals(usuarioId) & c.pendienteSync.equals(true)))
        .get();

    if (compPend.isNotEmpty) {
      await _habitRemote.subirCompletaciones([
        for (final c in compPend)
          {
            'id': c.id,
            'habit_id': c.habitId,
            'user_id': usuarioId,
            'fecha': _soloFecha(c.fecha).toIso8601String().split('T').first,
          }
      ]);
      for (final c in compPend) {
        await (_db.update(_db.habitCompletions)
              ..where((t) => t.id.equals(c.id)))
            .write(const HabitCompletionsCompanion(
                pendienteSync: drift.Value(false)));
      }
    }
  }

  // ── Tumbas (borrados) ───────────────────────────────────────────────────

  Future<void> _aplicarTumbas(String usuarioId) async {
    final tumbas = await (_db.select(_db.syncTombstones)
          ..where((t) => t.usuarioId.equals(usuarioId)))
        .get();

    for (final t in tumbas) {
      if (t.tabla == 'habits') {
        await _habitRemote.eliminarHabito(t.filaId, usuarioId);
      } else if (t.tabla == 'habit_completions') {
        await _habitRemote.eliminarCompletacion(t.filaId, usuarioId);
      }
      // Confirmado el borrado remoto, se retira la tumba.
      await (_db.delete(_db.syncTombstones)
            ..where((x) =>
                x.filaId.equals(t.filaId) & x.tabla.equals(t.tabla)))
          .go();
    }
  }

  // ── Bajada y fusión ───────────────────────────────────────────────────────

  Future<void> _bajarYFusionar(String usuarioId) async {
    // Hábitos
    final remotos = await _habitRemote.descargarHabitos(usuarioId);
    final locales = {
      for (final h in await (_db.select(_db.habits)
                ..where((h) => h.usuarioId.equals(usuarioId)))
              .get())
        h.id: h
    };

    for (final r in remotos) {
      final local = locales[r.habito.id];
      final accion = resolver(
        localActualizado: local?.actualizadoEn,
        remotoActualizado: r.actualizadoEn,
      );
      if (accion == AccionSync.bajar) {
        // Llega de remoto: se guarda sin marcar pendiente (ya está sincronizado).
        // `completadoHoy` es estado local del día (no debe viajar en el sync):
        // si el hábito ya existe local, conservamos su valor para que un sync
        // no borre el check de "hecho hoy" hasta reiniciar la app.
        var companion =
            _entityToCompanion(r.habito, r.actualizadoEn, pendiente: false);
        if (local != null) {
          companion =
              companion.copyWith(completadoHoy: drift.Value(local.completadoHoy));
        }
        await _db.into(_db.habits).insertOnConflictUpdate(companion);
      }
      // subir/nada: ya se subió en _subirPendientes o coinciden.
    }

    // Completaciones: solo se insertan las que faltan localmente. Los borrados
    // viajan por tumbas, así que aquí no eliminamos nada.
    final compRemotas = await _habitRemote.descargarCompletaciones(usuarioId);
    for (final c in compRemotas) {
      final existe = await (_db.select(_db.habitCompletions)
            ..where((x) => x.id.equals(c.id)))
          .getSingleOrNull();
      if (existe == null) {
        await _db.into(_db.habitCompletions).insert(
              HabitCompletionsCompanion.insert(
                id: c.id,
                habitId: c.habitId,
                usuarioId: usuarioId,
                fecha: _soloFecha(c.fecha),
                pendienteSync: const drift.Value(false),
              ),
              mode: drift.InsertMode.insertOrIgnore,
            );
      }
    }
  }

  // ── Conversión ────────────────────────────────────────────────────────────

  HabitEntity _rowToEntity(Habit row) => HabitEntity(
        id: row.id,
        nombre: row.nombre,
        icono: row.icono,
        categoria: CategoriaHabito.values[row.categoria],
        frecuencia: FrecuenciaHabito.values[row.frecuencia],
        metaSemanal: row.metaSemanal,
        completadoHoy: row.completadoHoy,
        rachaActual: row.rachaActual,
        rachaMaxima: row.rachaMaxima,
        totalCompletados: row.totalCompletados,
        color: row.color,
        usuarioId: row.usuarioId,
        creadoEn: row.creadoEn,
      );

  HabitsCompanion _entityToCompanion(
    HabitEntity e,
    DateTime actualizadoEn, {
    required bool pendiente,
  }) =>
      HabitsCompanion(
        id: drift.Value(e.id),
        nombre: drift.Value(e.nombre),
        icono: drift.Value(e.icono),
        categoria: drift.Value(e.categoria.index),
        frecuencia: drift.Value(e.frecuencia.index),
        metaSemanal: drift.Value(e.metaSemanal),
        completadoHoy: drift.Value(e.completadoHoy),
        rachaActual: drift.Value(e.rachaActual),
        rachaMaxima: drift.Value(e.rachaMaxima),
        totalCompletados: drift.Value(e.totalCompletados),
        color: drift.Value(e.color),
        usuarioId: drift.Value(e.usuarioId),
        creadoEn: drift.Value(e.creadoEn),
        actualizadoEn: drift.Value(actualizadoEn),
        pendienteSync: drift.Value(pendiente),
      );

  DateTime _soloFecha(DateTime d) => DateTime(d.year, d.month, d.day);
}
