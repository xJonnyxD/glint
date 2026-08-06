import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:glint/features/finance/domain/finance_analytics.dart';
import 'package:glint/features/finance/domain/transaction_entity.dart';
import 'package:glint/shared/services/export_service.dart';
import 'finance_cubit.dart';

final _fmt = NumberFormat.currency(locale: 'en_US', symbol: '\$');
const _mesesCortos = ['', 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];

/// Pantalla de Análisis financiero: ingresos vs gastos por mes, tendencia del
/// balance y top de categorías, con exportación a PDF.
class FinanceAnalyticsScreen extends StatelessWidget {
  const FinanceAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FinanceCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Análisis'),
      ),
      body: StreamBuilder<List<TransactionEntity>>(
        stream: cubit.repo.watchTransacciones(cubit.usuarioId),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final txs = snap.data!;
          if (txs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('Aún no hay transacciones para analizar.',
                    textAlign: TextAlign.center),
              ),
            );
          }
          return _Contenido(txs: txs);
        },
      ),
    );
  }
}

class _Contenido extends StatelessWidget {
  final List<TransactionEntity> txs;
  const _Contenido({required this.txs});

  @override
  Widget build(BuildContext context) {
    final resumen = FinanceAnalytics.resumenPorMes(txs, 6);
    final categorias = FinanceAnalytics.topCategorias(txs);
    final ingresos = FinanceAnalytics.totalIngresos(txs);
    final gastos = FinanceAnalytics.totalGastos(txs);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        // Métricas globales
        Row(
          children: [
            Expanded(child: _Metric(label: 'Ingresos', valor: ingresos, color: const Color(0xFF2A9D5C))),
            const SizedBox(width: 10),
            Expanded(child: _Metric(label: 'Gastos', valor: gastos, color: Theme.of(context).colorScheme.error)),
            const SizedBox(width: 10),
            Expanded(child: _Metric(label: 'Balance', valor: ingresos - gastos, color: Theme.of(context).colorScheme.primary)),
          ],
        ),
        const SizedBox(height: 20),

        _Card(
          titulo: 'Ingresos vs Gastos (6 meses)',
          child: _BarrasMensuales(resumen: resumen),
        ),
        const SizedBox(height: 14),
        _Card(
          titulo: 'Balance mensual',
          child: _LineaBalance(resumen: resumen),
        ),
        const SizedBox(height: 14),
        _Card(
          titulo: 'Top categorías de gasto',
          child: _TopCategorias(categorias: categorias, totalGastos: gastos),
        ),
        const SizedBox(height: 20),

        FilledButton.icon(
          onPressed: () => _exportarPDF(context),
          icon: const Icon(Icons.picture_as_pdf_outlined),
          label: const Text('Exportar reporte PDF'),
        ),
      ],
    );
  }

  Future<void> _exportarPDF(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(content: Text('Generando PDF…'), duration: Duration(seconds: 1)),
    );
    final res = await ExportService.exportarReportePDF(transacciones: txs);
    if (!res.exitoso && res.mensajeError != null) {
      messenger.showSnackBar(
        SnackBar(content: Text('No se pudo generar el PDF: ${res.mensajeError}')),
      );
    }
  }
}

// ── Gráfico de barras: ingresos vs gastos por mes ──────────────────────────────

class _BarrasMensuales extends StatelessWidget {
  final List<ResumenMensual> resumen;
  const _BarrasMensuales({required this.resumen});

  @override
  Widget build(BuildContext context) {
    final maxY = resumen.fold<double>(0, (m, r) {
      final mx = r.ingresos > r.gastos ? r.ingresos : r.gastos;
      return mx > m ? mx : m;
    });
    final tope = (maxY < 1 ? 1.0 : maxY) * 1.2;

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          maxY: tope,
          barTouchData: BarTouchData(enabled: true),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(
                color: Theme.of(context).colorScheme.outlineVariant,
                strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= resumen.length) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(_mesesCortos[resumen[i].mes.month],
                        style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < resumen.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: resumen[i].ingresos,
                    color: const Color(0xFF2A9D5C),
                    width: 9,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                  ),
                  BarChartRodData(
                    toY: resumen[i].gastos,
                    color: Theme.of(context).colorScheme.error,
                    width: 9,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// ── Gráfico de línea: balance neto por mes ─────────────────────────────────────

class _LineaBalance extends StatelessWidget {
  final List<ResumenMensual> resumen;
  const _LineaBalance({required this.resumen});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final spots = [
      for (var i = 0; i < resumen.length; i++)
        FlSpot(i.toDouble(), resumen[i].balance),
    ];
    final valores = resumen.map((r) => r.balance).toList();
    final maxV = valores.fold<double>(0, (m, v) => v > m ? v : m);
    final minV = valores.fold<double>(0, (m, v) => v < m ? v : m);

    return SizedBox(
      height: 170,
      child: LineChart(
        LineChartData(
          minY: minV == 0 && maxV == 0 ? -1 : minV * 1.2,
          maxY: minV == 0 && maxV == 0 ? 1 : maxV * 1.2,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: cs.outlineVariant, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= resumen.length) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(_mesesCortos[resumen[i].mes.month],
                        style: TextStyle(
                            fontSize: 10, color: cs.onSurfaceVariant)),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.25,
              color: cs.primary,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: true, color: cs.primary.withAlpha(30)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Top categorías de gasto ────────────────────────────────────────────────────

class _TopCategorias extends StatelessWidget {
  final List<GastoCategoria> categorias;
  final double totalGastos;
  const _TopCategorias({required this.categorias, required this.totalGastos});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final visibles = categorias.take(6).toList();
    if (visibles.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text('Sin gastos registrados.'),
      );
    }
    return Column(
      children: [
        for (final c in visibles)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(c.emoji, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(c.categoria)),
                    Text(_fmt.format(c.total),
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: totalGastos <= 0 ? 0 : (c.total / totalGastos).clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: cs.surfaceContainerHighest,
                    color: cs.primary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ── Piezas de UI ───────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final String titulo;
  final Widget child;
  const _Card({required this.titulo, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final double valor;
  final Color color;
  const _Metric({required this.label, required this.valor, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(_fmt.format(valor),
                  style: TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w800, color: color)),
            ),
          ],
        ),
      ),
    );
  }
}
