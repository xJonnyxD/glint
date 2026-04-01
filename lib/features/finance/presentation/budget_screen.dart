import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:glint/features/finance/domain/budget_entity.dart';
import 'package:glint/features/finance/domain/transaction_entity.dart';
import 'budget_cubit.dart';

final _fmt = NumberFormat.currency(locale: 'en_US', symbol: '\$');

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocBuilder<BudgetCubit, BudgetState>(
        builder: (context, state) {
          if (state is BudgetLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is BudgetLoaded) {
            return _BudgetContenido(state: state);
          }
          return const SizedBox();
        },
      ),
    );
  }
}

// ── Contenido principal ───────────────────────────────────────────────────────

class _BudgetContenido extends StatelessWidget {
  final BudgetLoaded state;
  const _BudgetContenido({required this.state});

  @override
  Widget build(BuildContext context) {
    final categorias = CategoriaGasto.values;
    final mesNombre = DateFormat('MMMM yyyy', 'es').format(
      DateTime(state.anio, state.mes),
    );

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Presupuesto del Mes'),
              Text(
                mesNombre,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),

        // Tarjeta resumen
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: _TarjetaResumen(state: state),
          ),
        ),

        // Lista de categorías
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          sliver: SliverList.builder(
            itemCount: categorias.length,
            itemBuilder: (context, index) {
              final cat = categorias[index];
              final budget = state.budgets.where(
                (b) => b.categoria == cat.name,
              ).firstOrNull;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: budget != null
                    ? _CategoriaConPresupuesto(
                        categoria: cat,
                        budget: budget,
                      )
                    : _CategoriaSinPresupuesto(categoria: cat),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── Tarjeta resumen ───────────────────────────────────────────────────────────

class _TarjetaResumen extends StatelessWidget {
  final BudgetLoaded state;
  const _TarjetaResumen({required this.state});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final total = CategoriaGasto.values.length;
    final asignadas = state.budgets.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.account_balance_wallet_outlined,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$asignadas de $total categorías',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    'con presupuesto asignado',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Text(
              '${((asignadas / total) * 100).round()}%',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Categoría con presupuesto ─────────────────────────────────────────────────

class _CategoriaConPresupuesto extends StatelessWidget {
  final CategoriaGasto categoria;
  final BudgetEntity budget;
  const _CategoriaConPresupuesto({
    required this.categoria,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(categoria.emoji, style: const TextStyle(fontSize: 22)),
          ),
        ),
        title: Text(
          categoria.nombre,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          'Límite: ${_fmt.format(budget.limite)}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit_outlined, color: colorScheme.primary),
              onPressed: () => _mostrarSheet(context, presupuestoExistente: budget),
              tooltip: 'Editar límite',
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: colorScheme.error),
              onPressed: () => context.read<BudgetCubit>().eliminar(budget.id),
              tooltip: 'Eliminar presupuesto',
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarSheet(BuildContext context, {BudgetEntity? presupuestoExistente}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<BudgetCubit>(),
        child: _PresupuestoSheet(
          categoria: categoria,
          presupuestoExistente: presupuestoExistente,
        ),
      ),
    );
  }
}

// ── Categoría sin presupuesto ─────────────────────────────────────────────────

class _CategoriaSinPresupuesto extends StatelessWidget {
  final CategoriaGasto categoria;
  const _CategoriaSinPresupuesto({required this.categoria});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.surface,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              categoria.emoji,
              style: const TextStyle(fontSize: 22),
            ),
          ),
        ),
        title: Text(
          categoria.nombre,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface.withAlpha(153),
              ),
        ),
        subtitle: Text(
          'Sin presupuesto asignado',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: FilledButton.tonal(
          onPressed: () => _mostrarSheet(context),
          style: FilledButton.styleFrom(
            minimumSize: const Size(40, 36),
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          child: const Icon(Icons.add, size: 20),
        ),
      ),
    );
  }

  void _mostrarSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<BudgetCubit>(),
        child: _PresupuestoSheet(categoria: categoria),
      ),
    );
  }
}

// ── Sheet para agregar / editar presupuesto ───────────────────────────────────

class _PresupuestoSheet extends StatefulWidget {
  final CategoriaGasto categoria;
  final BudgetEntity? presupuestoExistente;

  const _PresupuestoSheet({
    required this.categoria,
    this.presupuestoExistente,
  });

  @override
  State<_PresupuestoSheet> createState() => _PresupuestoSheetState();
}

class _PresupuestoSheetState extends State<_PresupuestoSheet> {
  final _montoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.presupuestoExistente != null) {
      _montoController.text =
          widget.presupuestoExistente!.limite.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _montoController.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;
    final monto = double.tryParse(_montoController.text.trim()) ?? 0;
    if (monto <= 0) return;

    final cubit = context.read<BudgetCubit>();
    if (widget.presupuestoExistente != null) {
      cubit.actualizarLimite(widget.presupuestoExistente!.id, monto);
    } else {
      cubit.crearPresupuesto(widget.categoria.name, monto);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final esEdicion = widget.presupuestoExistente != null;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  widget.categoria.emoji,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${esEdicion ? 'Editar' : 'Agregar'} presupuesto',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.categoria.nombre,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withAlpha(153),
                  ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _montoController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: const InputDecoration(
                labelText: 'Monto límite mensual',
                prefixText: '\$ ',
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Ingresa un monto';
                final n = double.tryParse(v.trim());
                if (n == null || n <= 0) return 'Ingresa un monto válido';
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _guardar,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
