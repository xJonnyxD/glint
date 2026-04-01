import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:glint/features/finance/domain/savings_goal_entity.dart';
import 'savings_goal_cubit.dart';

final _fmt = NumberFormat.currency(locale: 'en_US', symbol: '\$');
final _fmtFecha = DateFormat('dd/MM/yyyy', 'es');

// Emojis disponibles para metas
const _emojisDisponibles = [
  '🏠', '✈️', '🚗', '💻', '📱', '🏋️', '🎓', '💍', '🌴', '🎮',
  '🎸', '📷', '🐕', '⛵', '🏖️', '🎨', '🍕', '💊', '📚', '🚀',
];

// Colores disponibles
const _coloresDisponibles = [
  '#1E88E5', '#43A047', '#E53935', '#FB8C00', '#8E24AA',
  '#00ACC1', '#F4511E', '#3949AB', '#00897B', '#C0CA33',
];

class SavingsGoalScreen extends StatelessWidget {
  const SavingsGoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocBuilder<SavingsGoalCubit, SavingsGoalState>(
        builder: (context, state) {
          if (state is SavingsGoalLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SavingsGoalLoaded) {
            return _SavingsGoalContenido(state: state);
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarFormulario(context),
        icon: const Icon(Icons.add),
        label: const Text('Nueva meta'),
      ),
    );
  }

  void _mostrarFormulario(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<SavingsGoalCubit>(),
        child: const _NuevaMetaSheet(),
      ),
    );
  }
}

// ── Contenido principal ───────────────────────────────────────────────────────

class _SavingsGoalContenido extends StatelessWidget {
  final SavingsGoalLoaded state;
  const _SavingsGoalContenido({required this.state});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          pinned: true,
          title: Text('Mis Metas de Ahorro'),
        ),

        if (state.metas.isEmpty)
          SliverFillRemaining(child: _buildEstadoVacio(context))
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            sliver: SliverList.builder(
              itemCount: state.metas.length,
              itemBuilder: (context, index) {
                final meta = state.metas[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _MetaCard(meta: meta),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildEstadoVacio(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🎯', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Text(
            'Sin metas de ahorro',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Toca el botón + para crear tu primera meta',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

// ── Card de meta ──────────────────────────────────────────────────────────────

class _MetaCard extends StatelessWidget {
  final SavingsGoalEntity meta;
  const _MetaCard({required this.meta});

  Color _colorFromHex(String hex) {
    final h = hex.replaceFirst('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = _colorFromHex(meta.color);

    return Dismissible(
      key: Key(meta.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: colorScheme.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.delete_outline, color: colorScheme.onError),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Eliminar meta'),
            content: Text('¿Eliminar "${meta.nombre}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Eliminar'),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) =>
          context.read<SavingsGoalCubit>().eliminar(meta.id),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: color.withAlpha(38),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        meta.emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                meta.nombre,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            if (meta.completado)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withAlpha(38),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Completada!',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (meta.fechaMeta != null)
                          Text(
                            'Meta: ${_fmtFecha.format(meta.fechaMeta!)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _fmt.format(meta.montoActual),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    '/ ${_fmt.format(meta.montoMeta)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: meta.porcentaje,
                  minHeight: 8,
                  backgroundColor: color.withAlpha(38),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(meta.porcentaje * 100).round()}% completado',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (!meta.completado)
                    Text(
                      'Falta ${_fmt.format(meta.faltante)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
              if (!meta.completado) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _mostrarAbonar(context),
                    icon: const Icon(Icons.savings_outlined, size: 18),
                    label: const Text('Abonar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: color,
                      side: BorderSide(color: color),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarAbonar(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Abonar a "${meta.nombre}"'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          decoration: const InputDecoration(
            labelText: 'Monto a abonar',
            prefixText: '\$ ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              final monto = double.tryParse(controller.text.trim()) ?? 0;
              if (monto > 0) {
                context.read<SavingsGoalCubit>().agregarAhorro(meta.id, monto);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Abonar'),
          ),
        ],
      ),
    );
  }
}

// ── Sheet para nueva meta ─────────────────────────────────────────────────────

class _NuevaMetaSheet extends StatefulWidget {
  const _NuevaMetaSheet();

  @override
  State<_NuevaMetaSheet> createState() => _NuevaMetaSheetState();
}

class _NuevaMetaSheetState extends State<_NuevaMetaSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _montoController = TextEditingController();

  String _emojiSeleccionado = '🎯';
  String _colorSeleccionado = _coloresDisponibles[0];
  DateTime? _fechaMeta;

  @override
  void dispose() {
    _nombreController.dispose();
    _montoController.dispose();
    super.dispose();
  }

  Color _colorFromHex(String hex) {
    final h = hex.replaceFirst('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  Future<void> _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    if (fecha != null) setState(() => _fechaMeta = fecha);
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;
    final monto = double.tryParse(_montoController.text.trim()) ?? 0;
    if (monto <= 0) return;

    context.read<SavingsGoalCubit>().crearMeta(
          _nombreController.text.trim(),
          _emojiSeleccionado,
          monto,
          _colorSeleccionado,
          fechaMeta: _fechaMeta,
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          MediaQuery.viewInsetsOf(context).bottom + 24,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Nueva meta de ahorro',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Nombre
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre de la meta'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Ingresa un nombre' : null,
              ),
              const SizedBox(height: 20),

              // Selector de emoji
              Text(
                'Elige un emoji',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 56,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _emojisDisponibles.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final emoji = _emojisDisponibles[i];
                    final seleccionado = emoji == _emojiSeleccionado;
                    return GestureDetector(
                      onTap: () => setState(() => _emojiSeleccionado = emoji),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: seleccionado
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                          border: seleccionado
                              ? Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Monto meta
              TextFormField(
                controller: _montoController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Monto objetivo',
                  prefixText: '\$ ',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Ingresa un monto';
                  final n = double.tryParse(v.trim());
                  if (n == null || n <= 0) return 'Ingresa un monto válido';
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Fecha límite (opcional)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today_outlined),
                title: Text(
                  _fechaMeta == null
                      ? 'Fecha límite (opcional)'
                      : _fmtFecha.format(_fechaMeta!),
                ),
                trailing: _fechaMeta != null
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() => _fechaMeta = null),
                      )
                    : null,
                onTap: _seleccionarFecha,
              ),
              const SizedBox(height: 12),

              // Selector de color
              Text(
                'Color de la meta',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _coloresDisponibles.map((hex) {
                  final color = _colorFromHex(hex);
                  final seleccionado = hex == _colorSeleccionado;
                  return GestureDetector(
                    onTap: () => setState(() => _colorSeleccionado = hex),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: seleccionado
                            ? Border.all(
                                color: Theme.of(context).colorScheme.onSurface,
                                width: 3,
                              )
                            : null,
                      ),
                      child: seleccionado
                          ? const Icon(Icons.check, color: Colors.white, size: 20)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),

              FilledButton(
                onPressed: _guardar,
                child: const Text('Guardar meta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
