import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:glint/shared/database/app_database.dart';

/// Copia de seguridad completa de los datos locales.
///
/// Vuelca todas las tablas a un único archivo JSON que el usuario puede
/// guardar donde quiera (Drive, correo, WhatsApp…) y volver a importar.
///
/// A diferencia de la exportación CSV (que es solo un reporte), esta copia
/// es restaurable: al importarla, las filas vuelven a la base local y se
/// marcan como pendientes para volver a subir al servidor.
class BackupService {
  /// Todas las tablas de datos del usuario. El orden importa al restaurar:
  /// primero los hábitos y luego sus completaciones (que dependen de ellos).
  static const _tablas = [
    'habits',
    'habit_completions',
    'transactions',
    'budgets',
    'savings_goals',
    'debts',
    'recurring_expenses',
    'notes',
    'events',
    'routines',
  ];

  /// Columnas que no se exportan (marcas internas de sincronización).
  static const _columnasInternas = {'pendiente_sync'};

  // ── Exportar ───────────────────────────────────────────────────────────────

  /// Genera el JSON de la copia (parte testeable, sin archivos ni compartir).
  static Future<String> generarJson(AppDatabase db, String usuarioId) async {
    final datos = <String, List<Map<String, dynamic>>>{};
    var total = 0;

    for (final tabla in _tablas) {
      final filas = await db.customSelect(
        'SELECT * FROM $tabla WHERE usuario_id = ?',
        variables: [Variable<String>(usuarioId)],
      ).get();
      datos[tabla] = [
        for (final f in filas)
          {
            for (final e in f.data.entries)
              if (!_columnasInternas.contains(e.key)) e.key: e.value,
          }
      ];
      total += filas.length;
    }

    return const JsonEncoder.withIndent('  ').convert({
      'app': 'glint',
      'version_esquema': db.schemaVersion,
      'creado_en': DateTime.now().toIso8601String(),
      'usuario_id': usuarioId,
      'total_filas': total,
      'datos': datos,
    });
  }

  /// Crea el archivo de copia y abre el menú de compartir.
  /// Devuelve cuántas filas se respaldaron en total.
  static Future<int> exportar(AppDatabase db, String usuarioId) async {
    final json = await generarJson(db, usuarioId);
    final total =
        (jsonDecode(json) as Map<String, dynamic>)['total_filas'] as int;

    final dir = await getTemporaryDirectory();
    final archivo = File('${dir.path}/glint-copia-${_fechaParaNombre()}.json');
    await archivo.writeAsString(json, encoding: utf8);

    await Share.shareXFiles(
      [XFile(archivo.path, mimeType: 'application/json')],
      subject: 'Copia de seguridad de Glint',
      text: 'Copia de seguridad de Glint con $total registros. '
          'Guárdala en un lugar seguro; para restaurarla, ábrela desde '
          'Ajustes → Restaurar copia.',
    );
    return total;
  }

  // ── Restaurar ────────────────────────────────────────────────────────────────

  /// Restaura una copia previamente exportada. Las filas se insertan (o
  /// reemplazan por id) y se marcan como pendientes para volver a subir al
  /// servidor. Devuelve cuántas filas se restauraron.
  ///
  /// Lanza [FormatException] si el archivo no es una copia de Glint válida.
  static Future<int> restaurar(AppDatabase db, File archivo) async =>
      restaurarDesdeJson(db, await archivo.readAsString());

  /// Núcleo de la restauración (parte testeable, sin archivos).
  static Future<int> restaurarDesdeJson(AppDatabase db, String raw) async {
    final Map<String, dynamic> mapa;
    try {
      mapa = jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      throw const FormatException('El archivo no es una copia válida de Glint.');
    }
    if (mapa['app'] != 'glint' || mapa['datos'] is! Map) {
      throw const FormatException('El archivo no es una copia válida de Glint.');
    }

    final datos = mapa['datos'] as Map<String, dynamic>;
    var total = 0;

    // Suprimir los triggers de sync mientras restauramos, y marcar todo como
    // pendiente al final para que vuelva a subir al servidor.
    await db.marcarSyncActivo(true);
    try {
      for (final tabla in _tablas) {
        final filas = (datos[tabla] as List?) ?? const [];
        for (final fila in filas) {
          final m = (fila as Map).cast<String, dynamic>();
          // `pendiente_sync` no viaja en la copia (es una marca interna), así
          // que se pone aquí, fila a fila: lo restaurado tiene que volver a
          // subir al servidor. Se filtra de las claves del archivo por si una
          // copia antigua o retocada a mano la trae, o iría dos veces.
          //
          // Antes esto era un `UPDATE $tabla SET pendiente_sync = 1` al
          // terminar cada tabla, SIN filtro: en un dispositivo donde hubiera
          // iniciado sesión más de una cuenta, restaurar la copia de una
          // marcaba también las filas de las demás y el sync intentaba
          // subirlas con la sesión equivocada.
          final cols = [
            for (final k in m.keys)
              if (!_columnasInternas.contains(k)) k,
            'pendiente_sync',
          ];
          final placeholders = List.filled(cols.length, '?').join(',');
          await db.customStatement(
            'INSERT OR REPLACE INTO $tabla (${cols.join(',')}) '
            'VALUES ($placeholders)',
            [for (final c in cols.take(cols.length - 1)) m[c], 1],
          );
          total++;
        }
        if (filas.isNotEmpty) {
          // Avisar a las pantallas de que la tabla cambió.
          db.notifyUpdates({TableUpdate(tabla, kind: UpdateKind.insert)});
        }
      }
    } finally {
      await db.marcarSyncActivo(false);
    }
    return total;
  }

  static String _fechaParaNombre() {
    final a = DateTime.now();
    return '${a.year}-${a.month.toString().padLeft(2, '0')}-'
        '${a.day.toString().padLeft(2, '0')}';
  }
}
