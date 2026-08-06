import 'dart:io';
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:glint/features/finance/domain/finance_analytics.dart';
import 'package:glint/features/finance/domain/transaction_entity.dart';
import 'package:glint/features/habits/domain/habit_entity.dart';

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
      text: 'Reporte de $totalRegistros transacciones exportado desde Glint\n'
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

  // ── Exportar hábitos ───────────────────────────────────────────────────────

  /// Exporta la lista de hábitos a CSV y abre el menú de compartir
  static Future<ExportResult> exportarHabitosCSV({
    required List<HabitEntity> habitos,
  }) async {
    try {
      if (habitos.isEmpty) return ExportResult.vacio();

      final filas = <List<dynamic>>[
        [
          'Nombre',
          'Icono',
          'Categoría',
          'Frecuencia',
          'Racha actual',
          'Racha máxima',
          'Total completados',
          'Creado',
        ],
      ];

      for (final h in habitos) {
        filas.add([
          h.nombre,
          h.icono,
          h.categoria.nombre,
          h.frecuencia.nombre,
          h.rachaActual,
          h.rachaMaxima,
          h.totalCompletados,
          _formatearFecha(h.creadoEn),
        ]);
      }

      final csv = const ListToCsvConverter().convert(filas);
      final archivo = await _guardarArchivo(
        csv,
        'glint_habitos_${_fechaParaNombre()}.csv',
      );
      await Share.shareXFiles(
        [XFile(archivo.path, mimeType: 'text/csv')],
        subject: 'Mis hábitos Glint',
        text: 'Reporte de ${habitos.length} hábitos exportado desde Glint\n'
            'Generado el ${_formatearFecha(DateTime.now())}',
      );
      return ExportResult.exitoso(
        totalRegistros: habitos.length,
        rutaArchivo: archivo.path,
      );
    } catch (e) {
      return ExportResult.error(e.toString());
    }
  }

  // ── Reporte PDF de finanzas ─────────────────────────────────────────────────

  /// Genera un reporte financiero en PDF (resumen + desglose por categoría +
  /// tabla de transacciones) y abre el menú de compartir. Usa `XFile.fromData`
  /// para funcionar igual en móvil y en web (sin directorio temporal).
  static Future<ExportResult> exportarReportePDF({
    required List<TransactionEntity> transacciones,
    String titulo = 'Reporte financiero',
  }) async {
    try {
      if (transacciones.isEmpty) return ExportResult.vacio();

      final ingresos = FinanceAnalytics.totalIngresos(transacciones);
      final gastos = FinanceAnalytics.totalGastos(transacciones);
      final balance = ingresos - gastos;
      final categorias = FinanceAnalytics.topCategorias(transacciones);
      final ordenadas = List<TransactionEntity>.from(transacciones)
        ..sort((a, b) => b.fecha.compareTo(a.fecha));

      final doc = pw.Document();
      doc.addPage(
        pw.MultiPage(
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Text('$titulo — Glint',
                  style: pw.TextStyle(
                      fontSize: 22, fontWeight: pw.FontWeight.bold)),
            ),
            pw.Text('Generado el ${_formatearFecha(DateTime.now())}',
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
            pw.SizedBox(height: 16),

            // Resumen
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _resumenPdf('Ingresos', ingresos, PdfColors.green700),
                _resumenPdf('Gastos', gastos, PdfColors.red700),
                _resumenPdf('Balance', balance,
                    balance >= 0 ? PdfColors.green700 : PdfColors.red700),
              ],
            ),
            pw.SizedBox(height: 20),

            // Desglose por categoría
            pw.Text('Gastos por categoría',
                style: pw.TextStyle(
                    fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.TableHelper.fromTextArray(
              headers: ['Categoría', 'Total'],
              cellAlignments: {1: pw.Alignment.centerRight},
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey200),
              data: [
                for (final c in categorias)
                  [c.categoria, '\$${c.total.toStringAsFixed(2)}'],
              ],
            ),
            pw.SizedBox(height: 20),

            // Transacciones
            pw.Text('Transacciones (${ordenadas.length})',
                style: pw.TextStyle(
                    fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.TableHelper.fromTextArray(
              headers: ['Fecha', 'Descripción', 'Categoría', 'Tipo', 'Monto'],
              cellAlignments: {4: pw.Alignment.centerRight},
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey200),
              cellStyle: const pw.TextStyle(fontSize: 9),
              data: [
                for (final t in ordenadas)
                  [
                    _formatearFecha(t.fecha),
                    t.descripcion,
                    t.categoria,
                    t.esIngreso ? 'Ingreso' : 'Gasto',
                    '${t.esIngreso ? '+' : '-'}\$${t.monto.toStringAsFixed(2)}',
                  ],
              ],
            ),
          ],
        ),
      );

      final bytes = await doc.save();
      final nombre = 'glint_reporte_${_fechaParaNombre()}.pdf';
      await Share.shareXFiles(
        [XFile.fromData(bytes, mimeType: 'application/pdf', name: nombre)],
        subject: 'Reporte financiero Glint',
        text: 'Reporte de ${transacciones.length} transacciones — Glint',
      );

      return ExportResult.exitoso(
        totalRegistros: transacciones.length,
        rutaArchivo: nombre,
      );
    } catch (e) {
      return ExportResult.error(e.toString());
    }
  }

  static pw.Widget _resumenPdf(String label, double valor, PdfColor color) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label,
            style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700)),
        pw.SizedBox(height: 2),
        pw.Text('\$${valor.toStringAsFixed(2)}',
            style: pw.TextStyle(
                fontSize: 18, fontWeight: pw.FontWeight.bold, color: color)),
      ],
    );
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
