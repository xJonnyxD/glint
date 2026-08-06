import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:glint/features/habits/domain/habit_entity.dart';

/// Gráficos avanzados de hábitos (fl_chart): actividad semanal, tendencia de
/// 30 días y reparto por categoría. Se alimentan del historial de
/// completaciones (mapa fecha → nº de hábitos completados ese día).

const List<String> _diasCortos = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

DateTime _soloFecha(DateTime d) => DateTime(d.year, d.month, d.day);

/// Barras: cuántos hábitos completaste cada uno de los últimos 7 días.
class ActividadSemanalChart extends StatelessWidget {
  final Map<DateTime, int> datos;
  const ActividadSemanalChart({super.key, required this.datos});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hoy = _soloFecha(DateTime.now());
    // Últimos 7 días, del más antiguo al de hoy.
    final dias = [for (var i = 6; i >= 0; i--) hoy.subtract(Duration(days: i))];
    final valores = [for (final d in dias) (datos[_soloFecha(d)] ?? 0).toDouble()];
    final maxY = valores.isEmpty ? 0.0 : valores.reduce((a, b) => a > b ? a : b);
    final tope = (maxY < 1 ? 1.0 : maxY) + 1;

    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: tope,
          barTouchData: BarTouchData(enabled: true),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
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
                  if (i < 0 || i >= dias.length) return const SizedBox();
                  final d = dias[i];
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(_diasCortos[(d.weekday - 1) % 7],
                        style: TextStyle(
                            fontSize: 11, color: cs.onSurfaceVariant)),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (var i = 0; i < valores.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: valores[i],
                    width: 18,
                    color: cs.primary,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: tope,
                      color: cs.surfaceContainerHighest,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Línea/área: tendencia de completaciones a lo largo de los últimos 30 días.
class TendenciaChart extends StatelessWidget {
  final Map<DateTime, int> datos;
  final int dias;
  const TendenciaChart({super.key, required this.datos, this.dias = 30});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hoy = _soloFecha(DateTime.now());
    final serie = [
      for (var i = dias - 1; i >= 0; i--) hoy.subtract(Duration(days: i))
    ];
    final spots = [
      for (var i = 0; i < serie.length; i++)
        FlSpot(i.toDouble(), (datos[_soloFecha(serie[i])] ?? 0).toDouble()),
    ];
    final maxY = spots.fold<double>(0, (m, s) => s.y > m ? s.y : m);
    final tope = (maxY < 1 ? 1.0 : maxY) + 1;

    return SizedBox(
      height: 160,
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: tope,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
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
                interval: (dias / 4).floorToDouble().clamp(1, dias.toDouble()),
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= serie.length) return const SizedBox();
                  final d = serie[i];
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text('${d.day}/${d.month}',
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
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: cs.primary.withAlpha(38),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dona: reparto de hábitos por categoría.
class CategoriaDonutChart extends StatelessWidget {
  final Map<CategoriaHabito, List<HabitEntity>> porCategoria;
  const CategoriaDonutChart({super.key, required this.porCategoria});

  Color _color(String hex) {
    var h = hex.replaceAll('#', '');
    if (h.length == 6) h = 'FF$h';
    return Color(int.tryParse(h, radix: 16) ?? 0xFF757575);
  }

  @override
  Widget build(BuildContext context) {
    final entradas = porCategoria.entries.toList();
    final total = entradas.fold<int>(0, (s, e) => s + e.value.length);
    if (total == 0) return const SizedBox.shrink();

    return Row(
      children: [
        SizedBox(
          height: 140,
          width: 140,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 34,
              sections: [
                for (final e in entradas)
                  PieChartSectionData(
                    value: e.value.length.toDouble(),
                    color: _color(e.key.colorHex),
                    title: '${e.value.length}',
                    radius: 26,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final e in entradas)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _color(e.key.colorHex),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('${e.key.emoji} ${e.key.nombre}',
                          style: Theme.of(context).textTheme.bodySmall),
                      const Spacer(),
                      Text('${e.value.length}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
