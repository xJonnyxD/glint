import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glint/features/habits/domain/habit_entity.dart';
import 'package:glint/features/habits/presentation/habit_stats_sheet.dart';
import 'package:glint/shared/services/achievement_service.dart';
import 'package:glint/shared/widgets/racha_fuego_badge.dart';
import 'habit_cubit.dart';
import 'habit_state.dart';

/// Pantalla principal de Hábitos
class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HabitCubit, HabitState>(
      listener: (context, state) async {
        // Verificar logros cada vez que cambia el estado
        if (state is HabitLoaded) {
          final nuevos = await AchievementService.verificarYDesbloquear(state);
          if (context.mounted) {
            for (final logro in nuevos) {
              AchievementService.mostrarLogro(context, logro);
            }
          }
        }
      },
      builder: (context, state) {
        if (state is HabitLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is HabitError) {
          return Scaffold(
            body: Center(child: Text(state.mensaje)),
          );
        }
        final loaded = state as HabitLoaded;
        return _HabitsView(loaded: loaded);
      },
    );
  }
}

class _HabitsView extends StatelessWidget {
  final HabitLoaded loaded;
  const _HabitsView({required this.loaded});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cubit = context.read<HabitCubit>();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // ── Header con progreso ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: _HeaderHabitos(loaded: loaded),
            ),
            title: const Text(
              'Hábitos',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
            actions: [
              // Botón para abrir estadísticas y logros
              IconButton(
                icon: const Icon(Icons.bar_chart_rounded, color: Colors.white),
                tooltip: 'Estadísticas y logros',
                onPressed: () => _mostrarEstadisticas(context, cubit),
              ),
            ],
          ),

          // ── Lista vacía ──────────────────────────────────────────────────
          if (loaded.habitos.isEmpty)
            SliverFillRemaining(child: _EmptyState())
          else ...[
            // ── Resumen estadísticas ─────────────────────────────────────
            SliverToBoxAdapter(child: _EstadisticasBar(loaded: loaded)),

            // ── Hábitos agrupados por categoría ─────────────────────────
            ..._buildSecciones(context, loaded),
          ],

          // Espacio para el FAB
          const SliverToBoxAdapter(child: SizedBox(height: 88)),
        ],
      ),

      // ── Botón agregar hábito ─────────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarAgregarHabito(context),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo hábito'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );
  }

  List<Widget> _buildSecciones(BuildContext context, HabitLoaded loaded) {
    final secciones = <Widget>[];
    final porCategoria = loaded.porCategoria;

    // Ordenar categorías por las que tienen hábitos
    for (final categoria in CategoriaHabito.values) {
      final habitos = porCategoria[categoria];
      if (habitos == null || habitos.isEmpty) continue;

      secciones.add(
        SliverToBoxAdapter(
          child: _SeccionCategoria(
            categoria: categoria,
            habitos: habitos,
          ),
        ),
      );
    }
    return secciones;
  }

  void _mostrarAgregarHabito(BuildContext context, {HabitEntity? habitoEditar}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<HabitCubit>(),
        child: _AgregarHabitoSheet(habitoEditar: habitoEditar),
      ),
    );
  }

  void _mostrarEstadisticas(BuildContext context, HabitCubit cubit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => HabitStatsSheet(
        habitos: loaded.habitos,
        repo: cubit.repo,
        usuarioId: cubit.usuarioId,
      ),
    );
  }
}

// ── Header con progreso circular ─────────────────────────────────────────────

class _HeaderHabitos extends StatelessWidget {
  final HabitLoaded loaded;
  const _HeaderHabitos({required this.loaded});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progreso = loaded.progresoDia;
    final completados = loaded.completadosHoy;
    final total = loaded.total;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primary.withAlpha(200),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
          child: Row(
            children: [
              // Progreso circular
              SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progreso,
                      strokeWidth: 8,
                      backgroundColor: Colors.white24,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$completados/$total',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                          ),
                        ),
                        const Text(
                          'hoy',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 24),

              // Texto motivacional
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _mensajeMotivacional(progreso),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      total == 0
                          ? 'Agrega tu primer hábito'
                          : '$completados de $total completados hoy',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Barra de progreso lineal
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progreso,
                        minHeight: 6,
                        backgroundColor: Colors.white24,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _mensajeMotivacional(double progreso) {
    if (progreso == 0) return '¡Empieza hoy! 🌱';
    if (progreso < 0.33) return '¡Buen inicio! 💪';
    if (progreso < 0.66) return '¡A mitad! ⚡';
    if (progreso < 1.0) return '¡Casi listo! 🔥';
    return '¡Perfecto! 🎉';
  }
}

// ── Barra de estadísticas ─────────────────────────────────────────────────────

class _EstadisticasBar extends StatelessWidget {
  final HabitLoaded loaded;
  const _EstadisticasBar({required this.loaded});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(80),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            valor: '${loaded.total}',
            etiqueta: 'Hábitos',
            emoji: '📋',
          ),
          _Divider(),
          _StatItem(
            valor: '${loaded.mejorRacha}',
            etiqueta: 'Mejor racha',
            emoji: '🔥',
          ),
          _Divider(),
          _StatItem(
            valor: '${loaded.totalHistorico}',
            etiqueta: 'Completados',
            emoji: '✅',
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
      height: 32,
      width: 1,
      color: Theme.of(context).colorScheme.outline.withAlpha(60),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String valor;
  final String etiqueta;
  final String emoji;
  const _StatItem({
    required this.valor,
    required this.etiqueta,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 2),
        Text(
          valor,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        Text(
          etiqueta,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withAlpha(150),
              ),
        ),
      ],
    );
  }
}

// ── Sección por categoría ─────────────────────────────────────────────────────

class _SeccionCategoria extends StatelessWidget {
  final CategoriaHabito categoria;
  final List<HabitEntity> habitos;
  const _SeccionCategoria({
    required this.categoria,
    required this.habitos,
  });

  void _mostrarEditar(BuildContext context, HabitEntity habito) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<HabitCubit>(),
        child: _AgregarHabitoSheet(habitoEditar: habito),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final completados = habitos.where((h) => h.completadoHoy).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de categoría
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              Text(
                categoria.emoji,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 8),
              Text(
                categoria.nombre,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const Spacer(),
              Text(
                '$completados/${habitos.length}',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(120),
                    ),
              ),
            ],
          ),
        ),

        // Lista de hábitos de esta categoría
        ...habitos.map(
          (habito) => _HabitCard(
            habito: habito,
            onEditar: (ctx) => _mostrarEditar(ctx, habito),
          ),
        ),
      ],
    );
  }
}

// ── Tarjeta de hábito ─────────────────────────────────────────────────────────

class _HabitCard extends StatelessWidget {
  final HabitEntity habito;
  final void Function(BuildContext ctx) onEditar;
  const _HabitCard({required this.habito, required this.onEditar});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final completado = habito.completadoHoy;

    // Convertir color hex a Color de Flutter
    final color = _hexToColor(habito.color);

    return Dismissible(
      key: Key(habito.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: colorScheme.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Eliminar hábito'),
            content: Text('¿Eliminar "${habito.nombre}"? No se puede deshacer.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.error),
                child: const Text('Eliminar'),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        context.read<HabitCubit>().eliminarHabito(habito.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('"${habito.nombre}" eliminado'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: GestureDetector(
        onTap: () => _mostrarDetalle(context, habito),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: completado
                ? color.withAlpha(30)
                : colorScheme.surfaceContainerHighest.withAlpha(60),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: completado ? color.withAlpha(120) : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              // Icono del hábito con fondo de color
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: completado ? color : color.withAlpha(30),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    habito.icono,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              // Nombre y racha
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habito.nombre,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            decoration: completado
                                ? TextDecoration.lineThrough
                                : null,
                            color: completado
                                ? colorScheme.onSurface.withAlpha(120)
                                : null,
                          ),
                    ),
                    const SizedBox(height: 4),
                    if (habito.rachaActual >= 3)
                      RachaFuegoBadge(racha: habito.rachaActual)
                    else
                      Row(
                        children: [
                          const Text('🔥', style: TextStyle(fontSize: 12)),
                          const SizedBox(width: 2),
                          Text(
                            '${habito.rachaActual} días',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: colorScheme.onSurface.withAlpha(130),
                                ),
                          ),
                          if (habito.rachaMaxima > 0) ...[
                            const SizedBox(width: 8),
                            Text(
                              '• Mejor: ${habito.rachaMaxima}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: colorScheme.onSurface.withAlpha(100),
                                  ),
                            ),
                          ],
                        ],
                      ),
                  ],
                ),
              ),

              // Botón editar
              IconButton(
                icon: Icon(Icons.edit_outlined,
                    size: 18, color: colorScheme.onSurface.withAlpha(160)),
                tooltip: 'Editar hábito',
                onPressed: () => onEditar(context),
                visualDensity: VisualDensity.compact,
              ),

              // Checkbox / toggle de completado
              GestureDetector(
                onTap: () =>
                    context.read<HabitCubit>().toggleCompletar(habito),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: completado ? color : Colors.transparent,
                    border: Border.all(
                      color: completado ? color : colorScheme.outline,
                      width: 2,
                    ),
                  ),
                  child: completado
                      ? const Icon(Icons.check,
                          color: Colors.white, size: 18)
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarDetalle(BuildContext context, HabitEntity habito) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<HabitCubit>(),
        child: _DetalleHabitoSheet(habito: habito),
      ),
    );
  }

  Color _hexToColor(String hex) {
    try {
      final h = hex.replaceAll('#', '');
      return Color(int.parse('FF$h', radix: 16));
    } catch (_) {
      return const Color(0xFF1E88E5);
    }
  }
}

// ── Detalle del hábito ────────────────────────────────────────────────────────

class _DetalleHabitoSheet extends StatelessWidget {
  final HabitEntity habito;
  const _DetalleHabitoSheet({required this.habito});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = _hexToColor(habito.color);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outline.withAlpha(80),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Icono grande
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: color.withAlpha(100), width: 2),
            ),
            child: Center(
              child: Text(habito.icono,
                  style: const TextStyle(fontSize: 38)),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            habito.nombre,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            '${habito.categoria.emoji} ${habito.categoria.nombre} • ${habito.frecuencia.nombre}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withAlpha(140),
                ),
          ),
          const SizedBox(height: 24),

          // Stats del hábito
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatDetalle('🔥', '${habito.rachaActual}', 'Racha actual'),
              _StatDetalle('🏆', '${habito.rachaMaxima}', 'Mejor racha'),
              _StatDetalle(
                  '✅', '${habito.totalCompletados}', 'Total veces'),
            ],
          ),
          const SizedBox(height: 24),

          // Botón marcar como completado
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                context.read<HabitCubit>().toggleCompletar(habito);
                Navigator.pop(context);
              },
              icon: Icon(
                  habito.completadoHoy ? Icons.close : Icons.check),
              label: Text(habito.completadoHoy
                  ? 'Marcar como pendiente'
                  : '¡Completado hoy!'),
              style: FilledButton.styleFrom(
                backgroundColor:
                    habito.completadoHoy ? colorScheme.error : color,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _hexToColor(String hex) {
    try {
      final h = hex.replaceAll('#', '');
      return Color(int.parse('FF$h', radix: 16));
    } catch (_) {
      return const Color(0xFF1E88E5);
    }
  }
}

class _StatDetalle extends StatelessWidget {
  final String emoji;
  final String valor;
  final String etiqueta;
  const _StatDetalle(this.emoji, this.valor, this.etiqueta);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 4),
        Text(
          valor,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        Text(
          etiqueta,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withAlpha(140),
              ),
        ),
      ],
    );
  }
}

// ── Sheet para agregar o editar hábito ───────────────────────────────────────

class _AgregarHabitoSheet extends StatefulWidget {
  final HabitEntity? habitoEditar;
  const _AgregarHabitoSheet({this.habitoEditar});

  @override
  State<_AgregarHabitoSheet> createState() => _AgregarHabitoSheetState();
}

class _AgregarHabitoSheetState extends State<_AgregarHabitoSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();

  late String _iconoSeleccionado;
  late CategoriaHabito _categoriaSeleccionada;
  late FrecuenciaHabito _frecuenciaSeleccionada;
  bool _guardando = false;

  bool get _esEdicion => widget.habitoEditar != null;

  @override
  void initState() {
    super.initState();
    final h = widget.habitoEditar;
    _iconoSeleccionado      = h?.icono ?? '⭐';
    _categoriaSeleccionada  = h?.categoria ?? CategoriaHabito.salud;
    _frecuenciaSeleccionada = h?.frecuencia ?? FrecuenciaHabito.diario;
    _nombreCtrl.text        = h?.nombre ?? '';
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.outline.withAlpha(80),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                _esEdicion ? 'Editar hábito' : 'Nuevo hábito',
                style:
                    Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
              ),
              const SizedBox(height: 20),

              // ── Hábitos sugeridos (solo al crear) ─────────────────────
              if (!_esEdicion) ...[
                Text(
                  'Sugerencias rápidas',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurface.withAlpha(150),
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: habitosSugeridos.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final sug = habitosSugeridos[i];
                      return ActionChip(
                        label: Text('${sug['icono']} ${sug['nombre']}'),
                        onPressed: () {
                          setState(() {
                            _nombreCtrl.text = sug['nombre'] as String;
                            _iconoSeleccionado = sug['icono'] as String;
                            _categoriaSeleccionada =
                                sug['categoria'] as CategoriaHabito;
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // ── Selector de icono ──────────────────────────────────────
              Text(
                'Icono',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurface.withAlpha(150),
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 52,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: iconosHabitos.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 6),
                  itemBuilder: (context, i) {
                    final icono = iconosHabitos[i];
                    final seleccionado = icono == _iconoSeleccionado;
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _iconoSeleccionado = icono),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: seleccionado
                              ? colorScheme.primary
                              : colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            icono,
                            style: const TextStyle(fontSize: 22),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // ── Nombre del hábito ──────────────────────────────────────
              TextFormField(
                controller: _nombreCtrl,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Nombre del hábito',
                  hintText: 'Ej: Ejercicio, Meditación...',
                  prefixText: '$_iconoSeleccionado  ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  filled: true,
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Escribe un nombre' : null,
              ),
              const SizedBox(height: 16),

              // ── Categoría ─────────────────────────────────────────────
              Text(
                'Categoría',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurface.withAlpha(150),
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: CategoriaHabito.values.map((cat) {
                  final sel = cat == _categoriaSeleccionada;
                  return ChoiceChip(
                    label: Text('${cat.emoji} ${cat.nombre}'),
                    selected: sel,
                    onSelected: (_) =>
                        setState(() => _categoriaSeleccionada = cat),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // ── Frecuencia ────────────────────────────────────────────
              Text(
                'Frecuencia',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurface.withAlpha(150),
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              SegmentedButton<FrecuenciaHabito>(
                segments: const [
                  ButtonSegment(
                    value: FrecuenciaHabito.diario,
                    label: Text('Diario'),
                    icon: Icon(Icons.today),
                  ),
                  ButtonSegment(
                    value: FrecuenciaHabito.semanal,
                    label: Text('Semanal'),
                    icon: Icon(Icons.date_range),
                  ),
                ],
                selected: {_frecuenciaSeleccionada},
                onSelectionChanged: (sel) =>
                    setState(() => _frecuenciaSeleccionada = sel.first),
              ),
              const SizedBox(height: 24),

              // ── Botón guardar ─────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _guardando ? null : _guardar,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _guardando
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          _esEdicion ? 'Actualizar hábito' : 'Guardar hábito',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);

    try {
      if (_esEdicion) {
        await context.read<HabitCubit>().editarHabito(
              id:          widget.habitoEditar!.id,
              nombre:      _nombreCtrl.text.trim(),
              icono:       _iconoSeleccionado,
              categoria:   _categoriaSeleccionada,
              frecuencia:  _frecuenciaSeleccionada,
              metaSemanal: widget.habitoEditar!.metaSemanal,
            );
      } else {
        await context.read<HabitCubit>().crearHabito(
              nombre:    _nombreCtrl.text.trim(),
              icono:     _iconoSeleccionado,
              categoria: _categoriaSeleccionada,
              frecuencia: _frecuenciaSeleccionada,
            );
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _guardando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: ${e.toString().length > 120 ? e.toString().substring(0, 120) : e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 6),
          ),
        );
      }
    }
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '🌱',
                  style: const TextStyle(fontSize: 48),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Crea tu primer hábito',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Los pequeños hábitos diarios\nconstruyen grandes cambios.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withAlpha(140),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
