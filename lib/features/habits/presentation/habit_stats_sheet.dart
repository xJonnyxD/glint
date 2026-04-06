import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:glint/features/habits/domain/habit_entity.dart';
import 'package:glint/features/habits/presentation/heat_map_widget.dart';
import 'package:glint/features/habits/data/habit_repository.dart';
import 'package:glint/shared/services/achievement_service.dart';

/// Pantalla de estadísticas y logros de hábitos.
/// Se muestra como un bottom sheet de pantalla completa.
class HabitStatsSheet extends StatefulWidget {
  final List<HabitEntity> habitos;
  final HabitRepository repo;
  final String usuarioId;

  const HabitStatsSheet({
    super.key,
    required this.habitos,
    required this.repo,
    required this.usuarioId,
  });

  @override
  State<HabitStatsSheet> createState() => _HabitStatsSheetState();
}

class _HabitStatsSheetState extends State<HabitStatsSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  Map<DateTime, int>? _mapaCalor;
  Set<String> _logrosDesbloqueados = {};
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    _cargar();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    final mapa = await widget.repo.obtenerMapaCalor(
      usuarioId: widget.usuarioId,
    );
    final logros = await AchievementService.obtenerDesbloqueados();
    if (mounted) {
      setState(() {
        _mapaCalor = mapa;
        _logrosDesbloqueados = logros;
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 1.0,
      expand: false,
      builder: (_, scrollCtrl) => Column(
        children: [
          // Handle + título
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.onSurfaceVariant.withAlpha(60),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Estadísticas y Logros',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                TabBar(
                  controller: _tabs,
                  tabs: const [
                    Tab(text: 'Mapa de Calor'),
                    Tab(text: 'Estadísticas'),
                    Tab(text: 'Logros'),
                  ],
                ),
              ],
            ),
          ),

          // Contenido
          Expanded(
            child: _cargando
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabs,
                    children: [
                      _PestanaMapaCalor(
                        scrollCtrl: scrollCtrl,
                        mapaCalor: _mapaCalor!,
                        totalHabitos: widget.habitos.length,
                      ),
                      _PestanaEstadisticas(
                        scrollCtrl: scrollCtrl,
                        habitos: widget.habitos,
                        mapaCalor: _mapaCalor!,
                      ),
                      _PestanaLogros(
                        scrollCtrl: scrollCtrl,
                        desbloqueados: _logrosDesbloqueados,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Pestaña: Mapa de Calor ────────────────────────────────────────────────────

class _PestanaMapaCalor extends StatelessWidget {
  final ScrollController scrollCtrl;
  final Map<DateTime, int> mapaCalor;
  final int totalHabitos;

  const _PestanaMapaCalor({
    required this.scrollCtrl,
    required this.mapaCalor,
    required this.totalHabitos,
  });

  @override
  Widget build(BuildContext context) {
    final totalDias = mapaCalor.values.where((v) => v > 0).length;
    final mejorDia = mapaCalor.isEmpty
        ? 0
        : mapaCalor.values.reduce((a, b) => a > b ? a : b);

    return ListView(
      controller: scrollCtrl,
      padding: const EdgeInsets.all(20),
      children: [
        // Resumen rápido
        Row(
          children: [
            _StatCard(
              label: 'Días activos',
              valor: '$totalDias',
              emoji: '📅',
            ),
            const SizedBox(width: 12),
            _StatCard(
              label: 'Mejor día',
              valor: '$mejorDia hábitos',
              emoji: '🏅',
            ),
          ],
        ),
        const SizedBox(height: 24),

        Text(
          'Últimas 16 semanas',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: HabitHeatMap(
              datos: mapaCalor,
              maxHabitos: totalHabitos,
            ),
          ),
        ),

        const SizedBox(height: 16),
        Text(
          'Cada celda representa un día. El color más oscuro indica que completaste más hábitos ese día.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ── Pestaña: Estadísticas ─────────────────────────────────────────────────────

class _PestanaEstadisticas extends StatelessWidget {
  final ScrollController scrollCtrl;
  final List<HabitEntity> habitos;
  final Map<DateTime, int> mapaCalor;

  const _PestanaEstadisticas({
    required this.scrollCtrl,
    required this.habitos,
    required this.mapaCalor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final totalCompletados =
        habitos.fold(0, (s, h) => s + h.totalCompletados);
    final mejorRacha =
        habitos.isEmpty ? 0 : habitos.map((h) => h.rachaMaxima).reduce((a, b) => a > b ? a : b);
    final rachaActual =
        habitos.isEmpty ? 0 : habitos.map((h) => h.rachaActual).reduce((a, b) => a > b ? a : b);

    // Datos de la última semana para la gráfica
    final hoy = DateTime.now();
    final barGroups = List.generate(7, (i) {
      final dia = hoy.subtract(Duration(days: 6 - i));
      final key = DateTime(dia.year, dia.month, dia.day);
      final count = (mapaCalor[key] ?? 0).toDouble();
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: count,
            color: colorScheme.primary,
            width: 18,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });

    final diasSemana = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
    // Ajustar etiquetas según día actual
    final hoyWeekday = hoy.weekday; // 1=lunes ... 7=domingo
    final etiquetas = List.generate(7, (i) {
      final offset = (hoyWeekday - 7 + i) % 7;
      // offset puede ser negativo, normalizar
      final idx = ((offset % 7) + 7) % 7;
      return diasSemana[idx];
    });

    return ListView(
      controller: scrollCtrl,
      padding: const EdgeInsets.all(20),
      children: [
        // Métricas generales
        Row(
          children: [
            _StatCard(label: 'Total completados', valor: '$totalCompletados', emoji: '✅'),
            const SizedBox(width: 12),
            _StatCard(label: 'Mejor racha', valor: '$mejorRacha días', emoji: '🔥'),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _StatCard(label: 'Racha actual', valor: '$rachaActual días', emoji: '⚡'),
            const SizedBox(width: 12),
            _StatCard(label: 'Hábitos activos', valor: '${habitos.length}', emoji: '🎯'),
          ],
        ),

        const SizedBox(height: 24),

        // Gráfica de barras — última semana
        Text(
          'Completados por día — esta semana',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: SizedBox(
              height: 160,
              child: BarChart(
                BarChartData(
                  barGroups: barGroups,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Text(
                          etiquetas[value.toInt()],
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value == value.roundToDouble()) {
                            return Text(
                              value.toInt().toString(),
                              style: TextStyle(
                                  fontSize: 10,
                                  color: colorScheme.onSurfaceVariant),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: colorScheme.outlineVariant.withAlpha(80),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Top hábitos por racha
        if (habitos.isNotEmpty) ...[
          Text(
            'Top hábitos por racha',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          ...(_topHabitosPorRacha())
              .map((h) => _HabitoRankRow(habito: h)),
        ],
      ],
    );
  }

  List<HabitEntity> _topHabitosPorRacha() {
    final sorted = [...habitos]
      ..sort((a, b) => b.rachaMaxima.compareTo(a.rachaMaxima));
    return sorted.take(5).toList();
  }
}

// ── Pestaña: Logros ───────────────────────────────────────────────────────────

class _PestanaLogros extends StatelessWidget {
  final ScrollController scrollCtrl;
  final Set<String> desbloqueados;

  const _PestanaLogros({
    required this.scrollCtrl,
    required this.desbloqueados,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final totalDesbloqueados = desbloqueados.length;

    return ListView(
      controller: scrollCtrl,
      padding: const EdgeInsets.all(20),
      children: [
        // Progreso de logros
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  '$totalDesbloqueados / ${todosLosLogros.length}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'logros desbloqueados',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: todosLosLogros.isEmpty
                        ? 0
                        : totalDesbloqueados / todosLosLogros.length,
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Lista de todos los logros
        ...todosLosLogros.map((logro) {
          final desbloqueado = desbloqueados.contains(logro.id);
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: desbloqueado
                    ? logro.color.withAlpha(40)
                    : colorScheme.surfaceContainerHighest,
                child: Text(
                  desbloqueado ? logro.emoji : '🔒',
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              title: Text(
                logro.titulo,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: desbloqueado ? null : colorScheme.onSurfaceVariant,
                ),
              ),
              subtitle: Text(logro.descripcion),
              trailing: desbloqueado
                  ? Icon(Icons.check_circle_rounded,
                      color: logro.color, size: 20)
                  : Icon(Icons.lock_outline_rounded,
                      color: colorScheme.onSurfaceVariant, size: 20),
            ),
          );
        }),
      ],
    );
  }
}

// ── Widgets de apoyo ─────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String valor;
  final String emoji;

  const _StatCard({
    required this.label,
    required this.valor,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 6),
              Text(
                valor,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HabitoRankRow extends StatelessWidget {
  final HabitEntity habito;
  const _HabitoRankRow({required this.habito});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: ListTile(
        dense: true,
        leading: Text(habito.icono, style: const TextStyle(fontSize: 22)),
        title: Text(habito.nombre,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🏆', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 4),
            Text(
              '${habito.rachaMaxima} días',
              style: TextStyle(
                  fontWeight: FontWeight.w700, color: colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
