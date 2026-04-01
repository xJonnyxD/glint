import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glint/features/routines/domain/routine_entity.dart';
import 'routine_cubit.dart';
import 'routine_state.dart';

/// Pantalla principal de Rutinas
class RoutinesScreen extends StatelessWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Rutinas'),
        actions: [
          // Botón para agregar rutina nueva
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _mostrarAgregarRutina(context),
            tooltip: 'Agregar rutina',
          ),
        ],
      ),
      body: BlocBuilder<RoutineCubit, RoutineState>(
        builder: (context, state) {
          if (state is RoutineLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is RoutineError) {
            return Center(child: Text(state.mensaje));
          }
          if (state is RoutineLoaded) {
            if (state.rutinas.isEmpty) {
              return _buildEstadoVacio(context);
            }
            return _buildContenido(context, state);
          }
          return const SizedBox();
        },
      ),
    );
  }

  /// Vista cuando no hay rutinas creadas aún
  Widget _buildEstadoVacio(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wb_sunny_outlined, size: 80,
                color: colorScheme.primary.withAlpha(128)),
            const SizedBox(height: 24),
            Text('Aún no tienes rutinas',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Crea tu primera rutina para empezar\ntu día con intención',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withAlpha(153),
                  ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => _mostrarAgregarRutina(context),
              icon: const Icon(Icons.add),
              label: const Text('Crear primera rutina'),
            ),
          ],
        ),
      ),
    );
  }

  /// Vista con las rutinas agrupadas por período del día
  Widget _buildContenido(BuildContext context, RoutineLoaded state) {
    return CustomScrollView(
      slivers: [
        // Barra de progreso del día
        SliverToBoxAdapter(
          child: _ProgresoDelDia(state: state),
        ),

        // Sección Mañana
        if (state.manana.isNotEmpty) ...[
          _buildEncabezadoSeccion(context, PeriodoDelDia.manana),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => _RutinaCard(rutina: state.manana[i]),
              childCount: state.manana.length,
            ),
          ),
        ],

        // Sección Mediodía
        if (state.mediodia.isNotEmpty) ...[
          _buildEncabezadoSeccion(context, PeriodoDelDia.mediodia),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => _RutinaCard(rutina: state.mediodia[i]),
              childCount: state.mediodia.length,
            ),
          ),
        ],

        // Sección Noche
        if (state.noche.isNotEmpty) ...[
          _buildEncabezadoSeccion(context, PeriodoDelDia.noche),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => _RutinaCard(rutina: state.noche[i]),
              childCount: state.noche.length,
            ),
          ),
        ],

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  SliverToBoxAdapter _buildEncabezadoSeccion(
      BuildContext context, PeriodoDelDia periodo) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
        child: Row(
          children: [
            Text(periodo.emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              periodo.nombre,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// Bottom sheet para agregar una rutina nueva
  void _mostrarAgregarRutina(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<RoutineCubit>(),
        child: const _AgregarRutinaSheet(),
      ),
    );
  }
}

// ── Widget: Barra de progreso del día ────────────────────────────────────────

class _ProgresoDelDia extends StatelessWidget {
  final RoutineLoaded state;
  const _ProgresoDelDia({required this.state});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final porcentaje  = (state.progresoDia * 100).round();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progreso de hoy',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
              ),
              Text(
                '${state.completadasHoy}/${state.rutinas.length}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: state.progresoDia,
              minHeight: 10,
              backgroundColor: colorScheme.surface,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            porcentaje == 100
                ? '¡Todas las rutinas completadas! 🎉'
                : '$porcentaje% completado — ¡sigue así!',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onPrimaryContainer.withAlpha(180),
                ),
          ),
        ],
      ),
    );
  }
}

// ── Widget: Tarjeta de rutina ─────────────────────────────────────────────────

class _RutinaCard extends StatelessWidget {
  final RoutineEntity rutina;
  const _RutinaCard({required this.rutina});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final emoji = iconosRutinas[rutina.icono] ?? '⭐';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: rutina.completadaHoy
                  ? colorScheme.primary.withAlpha(26)
                  : colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: rutina.completadaHoy
                    ? colorScheme.primary
                    : colorScheme.outline,
              ),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 22)),
            ),
          ),
          title: Text(
            rutina.nombre,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  decoration: rutina.completadaHoy
                      ? TextDecoration.lineThrough
                      : null,
                  color: rutina.completadaHoy
                      ? colorScheme.onSurface.withAlpha(128)
                      : null,
                ),
          ),
          subtitle: Row(
            children: [
              Icon(Icons.access_time, size: 12,
                  color: colorScheme.onSurface.withAlpha(128)),
              const SizedBox(width: 4),
              Text(
                rutina.hora,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withAlpha(128),
                    ),
              ),
              if (rutina.rachaActual > 0) ...[
                const SizedBox(width: 12),
                Text('🔥 ${rutina.rachaActual}',
                    style: const TextStyle(fontSize: 12)),
              ],
            ],
          ),
          trailing: GestureDetector(
            onTap: () => context.read<RoutineCubit>().toggleCompletar(rutina),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: rutina.completadaHoy
                    ? colorScheme.primary
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: rutina.completadaHoy
                      ? colorScheme.primary
                      : colorScheme.outline,
                  width: 2,
                ),
              ),
              child: rutina.completadaHoy
                  ? Icon(Icons.check, size: 18, color: colorScheme.onPrimary)
                  : null,
            ),
          ),
          onLongPress: () => _confirmarEliminar(context),
        ),
      ),
    );
  }

  void _confirmarEliminar(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar rutina'),
        content: Text('¿Eliminar "${rutina.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<RoutineCubit>().eliminarRutina(rutina.id);
            },
            child: Text('Eliminar',
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }
}

// ── Widget: Bottom sheet para agregar rutina ──────────────────────────────────

class _AgregarRutinaSheet extends StatefulWidget {
  const _AgregarRutinaSheet();

  @override
  State<_AgregarRutinaSheet> createState() => _AgregarRutinaSheetState();
}

class _AgregarRutinaSheetState extends State<_AgregarRutinaSheet> {
  final _nombreCtrl = TextEditingController();
  final _formKey    = GlobalKey<FormState>();

  PeriodoDelDia _periodo = PeriodoDelDia.manana;
  String        _iconoSeleccionado = 'default';
  String        _hora = '07:00';

  @override
  void dispose() {
    _nombreCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
          24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Indicador de arrastre
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text('Nueva Rutina',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),

            // Nombre
            TextFormField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(
                labelText: 'Nombre de la rutina',
                hintText: 'ej: Ejercicio, Meditación...',
                prefixIcon: Icon(Icons.edit_outlined),
              ),
              textCapitalization: TextCapitalization.sentences,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Ingresa un nombre' : null,
            ),
            const SizedBox(height: 16),

            // Período del día
            Text('Período del día',
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Row(
              children: PeriodoDelDia.values.map((p) {
                final seleccionado = _periodo == p;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _periodo = p;
                        _hora    = p.horaDefault;
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: seleccionado
                              ? colorScheme.primaryContainer
                              : colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: seleccionado
                                ? colorScheme.primary
                                : colorScheme.outline,
                            width: seleccionado ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(p.emoji,
                                style: const TextStyle(fontSize: 20)),
                            const SizedBox(height: 4),
                            Text(p.nombre,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: seleccionado
                                          ? colorScheme.primary
                                          : null,
                                    )),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Ícono
            Text('Ícono', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: iconosRutinas.entries.map((entry) {
                  final seleccionado = _iconoSeleccionado == entry.key;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _iconoSeleccionado = entry.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.only(right: 8),
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: seleccionado
                            ? colorScheme.primaryContainer
                            : colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: seleccionado
                              ? colorScheme.primary
                              : colorScheme.outline,
                          width: seleccionado ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(entry.value,
                            style: const TextStyle(fontSize: 22)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Botón guardar
            FilledButton(
              onPressed: _guardar,
              child: const Text('Guardar rutina'),
            ),
          ],
        ),
      ),
    );
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;
    context.read<RoutineCubit>().crearRutina(
          nombre:  _nombreCtrl.text.trim(),
          icono:   _iconoSeleccionado,
          periodo: _periodo,
          hora:    _hora,
        );
    Navigator.pop(context);
  }
}
