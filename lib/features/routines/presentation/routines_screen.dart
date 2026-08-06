import 'package:flutter/material.dart';
import 'package:glint/core/icons/app_icons.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glint/features/routines/domain/routine_entity.dart';
import 'package:glint/shared/widgets/aparecer.dart';
import 'package:glint/shared/widgets/estado_vacio.dart';
import 'package:glint/shared/widgets/racha_fuego_badge.dart';
import 'package:glint/shared/widgets/skeleton_lista.dart';
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
            return const SkeletonLista();
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
    return EstadoVacio(
      icono: AppIcons.routines,
      titulo: 'Aún no tienes rutinas',
      subtitulo: 'Crea tu primera rutina para empezar\ntu día con intención',
      accion: FilledButton.icon(
        onPressed: () => _mostrarAgregarRutina(context),
        icon: const Icon(Icons.add),
        label: const Text('Crear primera rutina'),
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

        // Estadísticas y rachas
        SliverToBoxAdapter(
          child: _EstadisticasRutinas(state: state),
        ),

        // Sección Mañana
        if (state.manana.isNotEmpty) ...[
          _buildEncabezadoSeccion(context, PeriodoDelDia.manana),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => Aparecer(
                indice: i,
                child: _RutinaCard(
                  rutina: state.manana[i],
                  onEditar: () => _mostrarAgregarRutina(ctx, rutinaEditar: state.manana[i]),
                ),
              ),
              childCount: state.manana.length,
            ),
          ),
        ],

        // Sección Mediodía
        if (state.mediodia.isNotEmpty) ...[
          _buildEncabezadoSeccion(context, PeriodoDelDia.mediodia),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => Aparecer(
                indice: i,
                child: _RutinaCard(
                  rutina: state.mediodia[i],
                  onEditar: () => _mostrarAgregarRutina(ctx, rutinaEditar: state.mediodia[i]),
                ),
              ),
              childCount: state.mediodia.length,
            ),
          ),
        ],

        // Sección Noche
        if (state.noche.isNotEmpty) ...[
          _buildEncabezadoSeccion(context, PeriodoDelDia.noche),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => Aparecer(
                indice: i,
                child: _RutinaCard(
                  rutina: state.noche[i],
                  onEditar: () => _mostrarAgregarRutina(ctx, rutinaEditar: state.noche[i]),
                ),
              ),
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
            Icon(periodo.icono, size: 22,
                color: Theme.of(context).colorScheme.primary),
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

  /// Bottom sheet para agregar o editar una rutina
  void _mostrarAgregarRutina(BuildContext context, {RoutineEntity? rutinaEditar}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<RoutineCubit>(),
        child: _AgregarRutinaSheet(rutinaEditar: rutinaEditar),
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
  final VoidCallback onEditar;
  const _RutinaCard({required this.rutina, required this.onEditar});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final icono = iconosRutinas[rutina.icono] ?? Symbols.star_rounded;

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
              child: Icon(icono,
                  size: 24,
                  color: rutina.completadaHoy
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant),
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
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                ],
              ),
              if (rutina.rachaActual >= 3) ...[
                const SizedBox(height: 4),
                RachaFuegoBadge(racha: rutina.rachaActual),
              ],
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Botón editar
              IconButton(
                icon: Icon(Icons.edit_outlined,
                    size: 18, color: colorScheme.onSurface.withAlpha(160)),
                tooltip: 'Editar rutina',
                onPressed: onEditar,
                visualDensity: VisualDensity.compact,
              ),
              // Checkbox completar
              GestureDetector(
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
            ],
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

// ── Widget: Bottom sheet para agregar o editar rutina ────────────────────────

class _AgregarRutinaSheet extends StatefulWidget {
  final RoutineEntity? rutinaEditar;
  const _AgregarRutinaSheet({this.rutinaEditar});

  @override
  State<_AgregarRutinaSheet> createState() => _AgregarRutinaSheetState();
}

class _AgregarRutinaSheetState extends State<_AgregarRutinaSheet> {
  final _nombreCtrl = TextEditingController();
  final _formKey    = GlobalKey<FormState>();

  late PeriodoDelDia _periodo;
  late String        _iconoSeleccionado;
  late String        _hora;

  bool get _esEdicion => widget.rutinaEditar != null;

  @override
  void initState() {
    super.initState();
    final r = widget.rutinaEditar;
    _periodo          = r?.periodo ?? PeriodoDelDia.manana;
    _iconoSeleccionado = r?.icono ?? 'default';
    _hora             = r?.hora ?? '07:00';
    _nombreCtrl.text  = r?.nombre ?? '';
  }

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

            Text(
              _esEdicion ? 'Editar Rutina' : 'Nueva Rutina',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
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
                        // Solo actualizar hora si no es edición o si el usuario
                        // cambia manualmente el período
                        if (!_esEdicion) _hora = p.horaDefault;
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
                            Icon(p.icono, size: 22),
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
                        child: Icon(entry.value,
                            size: 24,
                            color: seleccionado
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Botón guardar
            FilledButton(
              onPressed: () => _guardar(),
              child: Text(_esEdicion ? 'Actualizar rutina' : 'Guardar rutina'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      if (_esEdicion) {
        await context.read<RoutineCubit>().editarRutina(
              id:      widget.rutinaEditar!.id,
              nombre:  _nombreCtrl.text.trim(),
              icono:   _iconoSeleccionado,
              periodo: _periodo,
              hora:    _hora,
            );
      } else {
        await context.read<RoutineCubit>().crearRutina(
              nombre:  _nombreCtrl.text.trim(),
              icono:   _iconoSeleccionado,
              periodo: _periodo,
              hora:    _hora,
            );
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString().length > 120 ? e.toString().substring(0, 120) : e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 6),
          ),
        );
      }
    }
  }
}

// ── Estadísticas y rachas de rutinas ──────────────────────────────────────────

class _EstadisticasRutinas extends StatelessWidget {
  final RoutineLoaded state;
  const _EstadisticasRutinas({required this.state});

  @override
  Widget build(BuildContext context) {
    final rutinas = state.rutinas;
    if (rutinas.isEmpty) return const SizedBox.shrink();

    final mejorRacha =
        rutinas.fold<int>(0, (m, r) => r.rachaActual > m ? r.rachaActual : m);
    final promedio =
        (rutinas.fold<int>(0, (s, r) => s + r.rachaActual) / rutinas.length)
            .round();

    // Rutinas ordenadas por racha para la visualización.
    final ordenadas = [...rutinas]
      ..sort((a, b) => b.rachaActual.compareTo(a.rachaActual));
    final topRacha = mejorRacha > 0 ? mejorRacha : 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _MetricaRutina(
                  valor: '${state.completadasHoy}/${rutinas.length}',
                  label: 'Hoy',
                  icon: Icons.today_outlined,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricaRutina(
                  valor: '$mejorRacha',
                  label: 'Mejor racha',
                  icon: Icons.local_fire_department_outlined,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricaRutina(
                  valor: '$promedio',
                  label: 'Racha media',
                  icon: Icons.trending_up,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rachas por rutina',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  for (final r in ordenadas)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 110,
                            child: Text(r.nombre,
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: (r.rachaActual / topRacha).clamp(0.0, 1.0),
                                minHeight: 8,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                                color: r.completadaHoy
                                    ? const Color(0xFFFF7043)
                                    : Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(AppIcons.streak,
                              size: 14,
                              color: Theme.of(context).colorScheme.tertiary),
                          const SizedBox(width: 3),
                          Text('${r.rachaActual}',
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricaRutina extends StatelessWidget {
  final String valor;
  final String label;
  final IconData icon;
  const _MetricaRutina(
      {required this.valor, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, size: 20, color: cs.primary),
            const SizedBox(height: 6),
            Text(valor,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: cs.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
