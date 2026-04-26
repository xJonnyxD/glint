import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glint/features/habits/domain/habit_entity.dart';
import 'package:glint/features/habits/presentation/habit_cubit.dart';
import 'package:glint/features/habits/presentation/habit_state.dart';

class HabitStatsScreen extends StatelessWidget {
  const HabitStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis estadísticas')),
      body: BlocBuilder<HabitCubit, HabitState>(
        builder: (context, state) {
          if (state is! HabitLoaded) {
            return const Center(child: CircularProgressIndicator());
          }
          return _ContenidoStats(state: state);
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Contenido principal de estadísticas
// ─────────────────────────────────────────────────────────────

class _ContenidoStats extends StatelessWidget {
  final HabitLoaded state;
  const _ContenidoStats({required this.state});

  @override
  Widget build(BuildContext context) {
    final insights = _generarInsights(state);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        // ── Sección 1: Resumen global ────────────────────────────────────────
        _SectionTitle(title: 'Resumen global', icon: Icons.bar_chart_rounded),
        const SizedBox(height: 12),
        _ResumenGlobal(state: state),
        const SizedBox(height: 24),

        // ── Sección 2: Por categoría ─────────────────────────────────────────
        if (state.habitos.isNotEmpty) ...[
          _SectionTitle(
              title: 'Por categoría', icon: Icons.category_outlined),
          const SizedBox(height: 12),
          _PorCategoria(state: state),
          const SizedBox(height: 24),
        ],

        // ── Sección 3: Rachas por hábito ─────────────────────────────────────
        if (state.habitos.isNotEmpty) ...[
          _SectionTitle(
              title: 'Rachas por hábito', icon: Icons.local_fire_department_outlined),
          const SizedBox(height: 12),
          _RachasPorHabito(state: state),
          const SizedBox(height: 24),
        ],

        // ── Sección 4: Insights automáticos ─────────────────────────────────
        _SectionTitle(title: 'Insights', icon: Icons.lightbulb_outline),
        const SizedBox(height: 12),
        _InsightsCards(insights: insights),
      ],
    );
  }

  List<String> _generarInsights(HabitLoaded state) {
    final insights = <String>[];

    if (state.completadosHoy == state.total && state.total > 0) {
      insights.add('🌟 ¡Día perfecto! Completaste todos tus hábitos hoy.');
    }
    if (state.mejorRacha >= 7) {
      insights.add(
          '🔥 Tu mejor racha es de ${state.mejorRacha} días. ¡Increíble constancia!');
    }
    if (state.totalHistorico >= 100) {
      insights.add(
          '🏆 Superaste las 100 completaciones. ¡Eres imparable!');
    }
    if (state.habitos.any((h) => h.rachaActual >= 30)) {
      final habito =
          state.habitos.firstWhere((h) => h.rachaActual >= 30);
      insights.add(
          '💎 "${habito.nombre}" lleva ${habito.rachaActual} días seguidos.');
    }
    if (state.habitos.isEmpty) {
      insights.add('💡 Agrega tu primer hábito para empezar a crecer.');
    } else if (state.completadosHoy == 0) {
      insights.add('💪 ¡Aún puedes completar tus hábitos de hoy!');
    }

    if (insights.isEmpty) {
      insights.add('📈 Sigue así, cada día cuenta para tus metas.');
    }
    return insights;
  }
}

// ─────────────────────────────────────────────────────────────
//  Título de sección
// ─────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Resumen global (3 métricas)
// ─────────────────────────────────────────────────────────────

class _ResumenGlobal extends StatelessWidget {
  final HabitLoaded state;
  const _ResumenGlobal({required this.state});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            _MetricaItem(
              valor: '${state.totalHistorico}',
              label: 'Total\ncompletados',
              icon: Icons.check_circle_outline,
            ),
            _Divider(),
            _MetricaItem(
              valor: '${state.mejorRacha}d',
              label: 'Mejor\nracha',
              icon: Icons.local_fire_department_outlined,
            ),
            _Divider(),
            _MetricaItem(
              valor: '${state.completadosHoy}/${state.total}',
              label: 'Hoy',
              icon: Icons.today_outlined,
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricaItem extends StatelessWidget {
  final String valor;
  final String label;
  final IconData icon;
  const _MetricaItem(
      {required this.valor, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 24, color: colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 56,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Por categoría
// ─────────────────────────────────────────────────────────────

class _PorCategoria extends StatelessWidget {
  final HabitLoaded state;
  const _PorCategoria({required this.state});

  @override
  Widget build(BuildContext context) {
    final categorias = state.porCategoria;
    if (categorias.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: categorias.entries.map((entry) {
        final cat = entry.key;
        final habitos = entry.value;
        final completados = habitos.where((h) => h.completadoHoy).length;
        final progreso = habitos.isEmpty ? 0.0 : completados / habitos.length;

        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(cat.emoji,
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        cat.nombre,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                    ),
                    Text(
                      '$completados / ${habitos.length} hoy',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progreso,
                    minHeight: 6,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${habitos.length} hábito${habitos.length != 1 ? 's' : ''} en esta categoría',
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Rachas por hábito (ordenadas por rachaActual desc)
// ─────────────────────────────────────────────────────────────

class _RachasPorHabito extends StatelessWidget {
  final HabitLoaded state;
  const _RachasPorHabito({required this.state});

  @override
  Widget build(BuildContext context) {
    final habitos = [...state.habitos]
      ..sort((a, b) => b.rachaActual.compareTo(a.rachaActual));

    return Column(
      children: habitos.map((h) {
        final maxRacha = h.rachaMaxima > 0 ? h.rachaMaxima : 1;
        final progreso = (h.rachaActual / maxRacha).clamp(0.0, 1.0);

        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            leading: Text(h.icono,
                style: const TextStyle(fontSize: 28)),
            title: Text(
              h.nombre,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 14),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progreso,
                    minHeight: 5,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Racha: ${h.rachaActual} días  |  Máxima: ${h.rachaMaxima} días',
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Insights automáticos
// ─────────────────────────────────────────────────────────────

class _InsightsCards extends StatelessWidget {
  final List<String> insights;
  const _InsightsCards({required this.insights});

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFFFFF9C4),
      const Color(0xFFC8E6C9),
      const Color(0xFFBBDEFB),
      const Color(0xFFF8BBD9),
      const Color(0xFFFFE0B2),
    ];

    return Column(
      children: insights.asMap().entries.map((entry) {
        final idx = entry.key;
        final text = entry.value;
        final bgColor = colors[idx % colors.length];

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
