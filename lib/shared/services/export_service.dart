import 'dart:io';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:glint/features/finance/domain/transaction_entity.dart';

/// Servicio para exportar transacciones financieras a CSV y compartirlas.
/// Usa los paquetes `csv` y `share_plus`.
class ExportService {
  /// Exporta una lista de transacciones a un archivo CSV y abre el menú
  /// de compartir (WhatsApp, email, Drive, etc.)
  static Future<ExportResult> exportarTransaccionesCSV({
    required List<TransactionEntity> transacciones,
    String? nombreArchivo,
  }) async {
    try {
      if (transacciones.isEmpty) {
        return ExportResult.vacio();
      }

      // 1. Construir el contenido CSV
      final csv = _construirCSV(transacciones);

      // 2. Guardar el archivo temporalmente
      final archivo = await _guardarArchivo(csv, nombreArchivo);

      // 3. Compartir con share_plus
      await _compartir(archivo, transacciones.length);

      return ExportResult.exitoso(
        totalRegistros: transacciones.length,
        rutaArchivo: archivo.path,
      );
    } catch (e) {
      return ExportResult.error(e.toString());
    }
  }

  // ── Construcción del CSV ───────────────────────────────────────────────────

  static String _construirCSV(List<TransactionEntity> transacciones) {
    // Ordenar por fecha más reciente primero
    final ordenadas = List<TransactionEntity>.from(transacciones)
      ..sort((a, b) => b.fecha.compareTo(a.fecha));

    // Encabezados del CSV
    final filas = <List<dynamic>>[
      [
        'Fecha',
        'Tipo',
        'Descripción',
        'Categoría',
        'Monto (USD)',
        'Notas',
      ],
    ];

    // Datos de cada transacción
    for (final t in ordenadas) {
      filas.add([
        _formatearFecha(t.fecha),
        t.esIngreso ? 'Ingreso' : 'Gasto',
        t.descripcion,
        '${t.categoriaEmoji} ${t.categoria}',
        t.esIngreso
            ? t.monto.toStringAsFixed(2)
            : '-${t.monto.toStringAsFixed(2)}',
        t.notas ?? '',
      ]);
    }

    // Resumen al final
    final totalIngresos = transacciones
        .where((t) => t.esIngreso)
        .fold(0.0, (sum, t) => sum + t.monto);
    final totalGastos = transacciones
        .where((t) => t.esGasto)
        .fold(0.0, (sum, t) => sum + t.monto);
    final balance = totalIngresos - totalGastos;

    filas.add([]); // fila vacía
    filas.add(['RESUMEN', '', '', '', '', '']);
    filas.add([
      'Total Ingresos',
      '',
      '',
      '',
      totalIngresos.toStringAsFixed(2),
      '',
    ]);
    filas.add([
      'Total Gastos',
      '',
      '',
      '',
      '-${totalGastos.toStringAsFixed(2)}',
      '',
    ]);
    filas.add([
      'Balance',
      '',
      '',
      '',
      balance.toStringAsFixed(2),
      '',
    ]);

    return const ListToCsvConverter().convert(filas);
  }

  // ── Guardar archivo ────────────────────────────────────────────────────────

  static Future<File> _guardarArchivo(
    String contenido,
    String? nombreArchivo,
  ) async {
    final directorio = await getTemporaryDirectory();
    final nombre = nombreArchivo ??
        'glint_finanzas_${_fechaParaNombre()}.csv';
    final archivo = File('${directorio.path}/$nombre');
    await archivo.writeAsString(contenido, encoding: utf8);
    return archivo;
  }

  // ── Compartir ──────────────────────────────────────────────────────────────

  static Future<void> _compartir(File archivo, int totalRegistros) async {
    await Share.shareXFiles(
      [XFile(archivo.path, mimeType: 'text/csv')],
      subject: 'Mis finanzas Glint',
      text: 'Reporte de $totalRegistros transacciones exportado desde Glint 💰\n'
          'Generado el ${_formatearFecha(DateTime.now())}',
    );
  }

  // ── Utilidades ─────────────────────────────────────────────────────────────

  static String _formatearFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/'
        '${fecha.month.toString().padLeft(2, '0')}/'
        '${fecha.year}';
  }

  static String _fechaParaNombre() {
    final ahora = DateTime.now();
    return '${ahora.year}${ahora.month.toString().padLeft(2, '0')}'
        '${ahora.day.toString().padLeft(2, '0')}';
  }
}

/// Resultado de la exportación
class ExportResult {
  final bool exitoso;
  final bool estaVacio;
  final int totalRegistros;
  final String? rutaArchivo;
  final String? mensajeError;

  const ExportResult._({
    required this.exitoso,
    required this.estaVacio,
    required this.totalRegistros,
    this.rutaArchivo,
    this.mensajeError,
  });

  factory ExportResult.exitoso({
    required int totalRegistros,
    required String rutaArchivo,
  }) =>
      ExportResult._(
        exitoso: true,
        estaVacio: false,
        totalRegistros: totalRegistros,
        rutaArchivo: rutaArchivo,
      );

  factory ExportResult.vacio() => const ExportResult._(
        exitoso: false,
        estaVacio: true,
        totalRegistros: 0,
      );

  factory ExportResult.error(String mensaje) => ExportResult._(
        exitoso: false,
        estaVacio: false,
        totalRegistros: 0,
        mensajeError: mensaje,
      );
}
