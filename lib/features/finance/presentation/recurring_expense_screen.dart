import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:glint/features/finance/domain/recurring_expense_entity.dart';
import 'recurring_expense_cubit.dart';

final _fmt = NumberFormat.currency(locale: 'en_US', symbol: '\$');

// Categorías disponibles para gastos recurrentes
const _categoriasRecurrentes = [
  {'nombre': 'Entretenimiento', 'emoji': '🎬'},
  {'nombre': 'Música',          'emoji': '🎵'},
  {'nombre': 'Tecnología',      'emoji': '💻'},
  {'nombre': 'Servicios',       'emoji': '💡'},
  {'nombre': 'Salud',           'emoji': '💊'},
  {'nombre': 'Educación',       'emoji': '📚'},
  {'nombre': 'Transporte',      'emoji': '🚗'},
  {'nombre': 'Alimentación',    'emoji': '🍔'},
  {'nombre': 'Hogar',           'emoji': '🏠'},
  {'nombre': 'Otro',            'emoji': '📦'},
];

class RecurringExpenseScreen extends StatelessWidget {
  const RecurringExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocBuilder<RecurringExpenseCubit, RecurringExpenseState>(
        builder: (context, state) {
          if (state is RecurringExpenseLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is RecurringExpenseLoaded) {
            return _Contenido(state: state);
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarFormulario(context),
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
    );
  }
}

// ── Contenido principal ───────────────────────────────────────────────────────

class _Contenido extends StatelessWidget {
  final RecurringExpenseLoaded state;
  const _Contenido({required this.state});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final gastos = state.gastos;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 140,
          backgroundColor: colorScheme.primary,
          title: const Text(
            'Gastos Recurrentes',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [colorScheme.primary, colorScheme.primary.withAlpha(200)],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'Total mensual estimado',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _fmt.format(state.totalMensual),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(30),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${gastos.where((g) => g.activo).length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Text(
                              'activos',
                              style: TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        if (gastos.isEmpty)
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.repeat_outlined, size: 72, color: colorScheme.primary.withAlpha(100)),
                  const SizedBox(height: 16),
                  Text(
                    'Sin gastos recurrentes',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface.withAlpha(150),
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Agrega Netflix, Spotify, internet...',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withAlpha(100),
                        ),
                  ),
                ],
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final gasto = gastos[i];
                  return _GastoCard(gasto: gasto);
                },
                childCount: gastos.length,
              ),
            ),
          ),
      ],
    );
  }
}

// ── Card de gasto recurrente ──────────────────────────────────────────────────

class _GastoCard extends StatelessWidget {
  final RecurringExpenseEntity gasto;
  const _GastoCard({required this.gasto});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: Key(gasto.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: colorScheme.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      confirmDismiss: (dir) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Eliminar gasto'),
            content: Text('¿Eliminar "${gasto.nombre}"?'),
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
      onDismissed: (_) =>
          context.read<RecurringExpenseCubit>().eliminar(gasto.id),
      child: Opacity(
        opacity: gasto.activo ? 1.0 : 0.5,
        child: Card(
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  gasto.categoriaEmoji,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            title: Text(
              gasto.nombre,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                decoration:
                    gasto.activo ? null : TextDecoration.lineThrough,
              ),
            ),
            subtitle: Text(
              '${gasto.frecuencia.nombre} · ${gasto.categoria}',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurface.withAlpha(150),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _fmt.format(gasto.monto),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.primary,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      gasto.frecuencia.emoji,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Switch(
                  value: gasto.activo,
                  onChanged: (val) => context
                      .read<RecurringExpenseCubit>()
                      .toggleActivo(gasto.id, val),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Formulario ────────────────────────────────────────────────────────────────

void _mostrarFormulario(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => BlocProvider.value(
      value: context.read<RecurringExpenseCubit>(),
      child: const _FormularioGasto(),
    ),
  );
}

class _FormularioGasto extends StatefulWidget {
  const _FormularioGasto();

  @override
  State<_FormularioGasto> createState() => _FormularioGastoState();
}

class _FormularioGastoState extends State<_FormularioGasto> {
  final _nombreCtrl = TextEditingController();
  final _montoCtrl  = TextEditingController();
  FrecuenciaRecurrente _frecuencia = FrecuenciaRecurrente.mensual;
  int _diaDelMes = 1;
  int _categoriaIdx = 0;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _montoCtrl.dispose();
    super.dispose();
  }

  void _guardar() {
    final nombre = _nombreCtrl.text.trim();
    final monto  = double.tryParse(_montoCtrl.text.replaceAll(',', '.'));

    if (nombre.isEmpty || monto == null || monto <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos correctamente')),
      );
      return;
    }

    final cat = _categoriasRecurrentes[_categoriaIdx];

    context.read<RecurringExpenseCubit>().crearGasto(
      nombre,
      cat['nombre']!,
      cat['emoji']!,
      monto,
      _frecuencia,
      _diaDelMes,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (ctx, scrollCtrl) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withAlpha(60),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Nuevo gasto recurrente',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            Expanded(
              child: ListView(
                controller: scrollCtrl,
                padding: EdgeInsets.fromLTRB(
                  20, 20, 20,
                  MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                children: [
                  // Nombre
                  TextField(
                    controller: _nombreCtrl,
                    decoration: InputDecoration(
                      labelText: 'Nombre del servicio',
                      hintText: 'Netflix, Spotify, Internet...',
                      prefixIcon: const Icon(Icons.repeat),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 16),

                  // Categoría
                  Text(
                    'Categoría',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      _categoriasRecurrentes.length,
                      (i) {
                        final cat = _categoriasRecurrentes[i];
                        final sel = i == _categoriaIdx;
                        return GestureDetector(
                          onTap: () => setState(() => _categoriaIdx = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: sel
                                  ? colorScheme.primaryContainer
                                  : colorScheme.surface,
                              border: Border.all(
                                color: sel
                                    ? colorScheme.primary
                                    : colorScheme.outline.withAlpha(80),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(cat['emoji']!,
                                    style: const TextStyle(fontSize: 16)),
                                const SizedBox(width: 4),
                                Text(
                                  cat['nombre']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: sel
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                    color: sel
                                        ? colorScheme.primary
                                        : colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Monto
                  TextField(
                    controller: _montoCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*[.,]?\d{0,2}')),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Monto',
                      prefixIcon: const Icon(Icons.attach_money),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Frecuencia
                  Text(
                    'Frecuencia',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<FrecuenciaRecurrente>(
                    segments: const [
                      ButtonSegment(
                          value: FrecuenciaRecurrente.diario,
                          label: Text('Diario'),
                          icon: Icon(Icons.today_outlined, size: 16)),
                      ButtonSegment(
                          value: FrecuenciaRecurrente.semanal,
                          label: Text('Semanal'),
                          icon: Icon(Icons.view_week_outlined, size: 16)),
                      ButtonSegment(
                          value: FrecuenciaRecurrente.mensual,
                          label: Text('Mensual'),
                          icon: Icon(Icons.calendar_month_outlined, size: 16)),
                      ButtonSegment(
                          value: FrecuenciaRecurrente.anual,
                          label: Text('Anual'),
                          icon: Icon(Icons.event_outlined, size: 16)),
                    ],
                    selected: {_frecuencia},
                    onSelectionChanged: (sel) =>
                        setState(() => _frecuencia = sel.first),
                  ),
                  const SizedBox(height: 16),

                  // Día del mes (solo si es mensual)
                  if (_frecuencia == FrecuenciaRecurrente.mensual) ...[
                    Text(
                      'Día del mes de cobro',
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      initialValue: _diaDelMes,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.event_note_outlined),
                      ),
                      items: List.generate(
                        28,
                        (i) => DropdownMenuItem(
                          value: i + 1,
                          child: Text('Día ${i + 1}'),
                        ),
                      ),
                      onChanged: (val) =>
                          setState(() => _diaDelMes = val ?? 1),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Botón guardar
                  FilledButton.icon(
                    onPressed: _guardar,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Guardar gasto recurrente'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
