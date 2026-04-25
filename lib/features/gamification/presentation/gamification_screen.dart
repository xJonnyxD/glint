import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:glint/features/gamification/presentation/gamification_cubit.dart';
import 'package:glint/shared/services/achievement_service.dart';

class GamificationScreen extends StatelessWidget {
  const GamificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GamificationCubit, GamificationState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Mis Logros'),
            leading: BackButton(onPressed: () => Navigator.of(context).pop()),
          ),
          body: RefreshIndicator(
            onRefresh: () => context.read<GamificationCubit>().recargar(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _HeaderCard(state: state),
                const SizedBox(height: 24),
                _LogrosSection(state: state),
                const SizedBox(height: 24),
                _HistorialSection(state: state),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Header con progreso ────────────────────────────────────────────────────────

class _HeaderCard extends StatelessWidget {
  final GamificationState state;

  const _HeaderCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final xpFormateado = NumberFormat('#,##0').format(state.xpTotal);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primary.withAlpha(180),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withAlpha(80),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            state.emojiNivel,
            style: const TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 8),
          Text(
            state.nivel,
            style: textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$xpFormateado XP',
            style: textTheme.titleMedium?.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: state.progreso,
              minHeight: 10,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            state.xpParaSiguiente > 0
                ? '${NumberFormat('#,##0').format(state.xpParaSiguiente)} XP para el siguiente nivel'
                : '¡Nivel máximo alcanzado!',
            style: textTheme.bodySmall?.copyWith(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sección de logros ──────────────────────────────────────────────────────────

class _LogrosSection extends StatelessWidget {
  final GamificationState state;

  const _LogrosSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Logros',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemCount: todosLosLogros.length,
          itemBuilder: (context, index) {
            final logro = todosLosLogros[index];
            final desbloqueado = state.logrosDesbloqueados.contains(logro.id);
            return _LogroCard(logro: logro, desbloqueado: desbloqueado);
          },
        ),
      ],
    );
  }
}

class _LogroCard extends StatelessWidget {
  final Logro logro;
  final bool desbloqueado;

  const _LogroCard({required this.logro, required this.desbloqueado});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: desbloqueado ? logro.color : colorScheme.outlineVariant,
          width: desbloqueado ? 2 : 1,
        ),
        color: desbloqueado
            ? logro.color.withAlpha(15)
            : colorScheme.surfaceContainerHighest.withAlpha(80),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: desbloqueado ? 1.0 : 0.3,
                child: Text(
                  logro.emoji,
                  style: const TextStyle(fontSize: 36),
                ),
              ),
              if (!desbloqueado)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Icon(
                    Icons.lock_outline,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            logro.titulo,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: desbloqueado
                  ? colorScheme.onSurface
                  : colorScheme.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ── Sección de historial ───────────────────────────────────────────────────────

class _HistorialSection extends StatelessWidget {
  final GamificationState state;

  const _HistorialSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final items = state.historial.take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Historial de XP',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Sin actividad reciente',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = items[index];
              final xp = item['xp'] as int? ?? 0;
              final motivo = item['motivo'] as String? ?? '';
              final fechaRaw = item['fecha'];
              String fechaFormateada = '';
              if (fechaRaw != null) {
                try {
                  final fecha = DateTime.parse(fechaRaw.toString());
                  fechaFormateada =
                      DateFormat('dd MMM yyyy, HH:mm', 'es').format(fecha);
                } catch (_) {
                  fechaFormateada = fechaRaw.toString();
                }
              }

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 4,
                ),
                leading: const Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                  size: 28,
                ),
                title: Text(
                  '+$xp XP — $motivo',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: fechaFormateada.isNotEmpty
                    ? Text(
                        fechaFormateada,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      )
                    : null,
              );
            },
          ),
      ],
    );
  }
}
