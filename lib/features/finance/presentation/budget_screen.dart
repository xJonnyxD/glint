import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter/material.dart';
import 'package:glint/shared/widgets/skeleton_lista.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:glint/features/finance/domain/budget_entity.dart';
import 'package:glint/features/finance/domain/transaction_entity.dart';
import 'package:glint/features/finance/presentation/finance_icons.dart';
import 'package:glint/features/finance/presentation/movimiento_sheet.dart';
import 'budget_cubit.dart';
import 'finance_cubit.dart';
import 'finance_state.dart';

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
            return const SkeletonLista();
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

        // Movimientos del mes: se pueden añadir, editar y borrar desde aquí,
        // y el resumen de arriba se recalcula solo al cambiar cualquiera.
        SliverToBoxAdapter(
          child: _MovimientosDelMes(mes: state.mes, anio: state.anio),
        ),

        // Límites por categoría
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: Text(
              'Límites por categoría',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
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

// ── Movimientos del mes ───────────────────────────────────────────────────────

class _MovimientosDelMes extends StatelessWidget {
  final int mes;
  final int anio;
  const _MovimientosDelMes({required this.mes, required this.anio});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinanceCubit, FinanceState>(
      builder: (context, finanzas) {
        final movimientos = finanzas is FinanceLoaded
            ? (finanzas.transacciones
                .where((t) => t.fecha.month == mes && t.fecha.year == anio)
                .toList()
              ..sort((a, b) => b.fecha.compareTo(a.fecha)))
            : <TransactionEntity>[];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 12, 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Movimientos del mes',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _abrirEditor(context),
                    icon: const Icon(Symbols.add_rounded, size: 18),
                    label: const Text('Añadir'),
                  ),
                ],
              ),
            ),
            if (movimientos.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: Text(
                  'Sin movimientos todavía.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              )
            else
              ...movimientos.map(
                (t) => _FilaMovimiento(
                  tx: t,
                  onEditar: () => _abrirEditor(context, original: t),
                  onEliminar: () => _confirmarEliminar(context, t),
                ),
              ),
          ],
        );
      },
    );
  }

  void _abrirEditor(BuildContext context, {TransactionEntity? original}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<FinanceCubit>(),
        child: MovimientoSheet(
          original: original,
          mes: mes,
          anio: anio,
        ),
      ),
    );
  }

  /// Borrar dinero registrado no debería poder pasar por un toque accidental.
  Future<void> _confirmarEliminar(
    BuildContext context,
    TransactionEntity tx,
  ) async {
    final cubit = context.read<FinanceCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Eliminar este movimiento?'),
        content: Text(
          '${tx.descripcion.isEmpty ? tx.categoria : tx.descripcion} · '
          '${_fmt.format(tx.monto)}\n\nEsta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmado != true) return;

    try {
      await cubit.eliminarTransaccion(tx.id);
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('No se pudo eliminar. Inténtalo de nuevo.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class _FilaMovimiento extends StatelessWidget {
  final TransactionEntity tx;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const _FilaMovimiento({
    required this.tx,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final esGasto = tx.esGasto;
    final color = esGasto ? cs.error : Colors.green.shade600;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          onTap: onEditar,
          leading: CircleAvatar(
            backgroundColor: color.withAlpha(30),
            child: Icon(iconoDeCategoriaEmoji(tx.categoriaEmoji),
                size: 20, color: color),
          ),
          title: Text(
            tx.descripcion.isEmpty ? tx.categoria : tx.descripcion,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '${tx.categoria} · ${DateFormat('d MMM', 'es').format(tx.fecha)}',
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${esGasto ? '−' : '+'}${_fmt.format(tx.monto)}',
                style: TextStyle(color: color, fontWeight: FontWeight.w700),
              ),
              IconButton(
                icon: const Icon(Symbols.delete_rounded, size: 20),
                tooltip: 'Eliminar',
                onPressed: onEliminar,
              ),
            ],
          ),
        ),
      ),
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

    // El resumen sale de los movimientos REALES del mes, no de cuántas
    // categorías tienen un límite puesto: eso es lo que se mostraba antes y
    // no decía nada sobre el dinero.
    return BlocBuilder<FinanceCubit, FinanceState>(
      builder: (context, finanzas) {
        final delMes = finanzas is FinanceLoaded
            ? finanzas.transacciones
                .where((t) => t.fecha.month == state.mes && t.fecha.year == state.anio)
                .toList()
            : const <TransactionEntity>[];

        final ingresos = delMes
            .where((t) => !t.esGasto)
            .fold(0.0, (s, t) => s + t.monto);
        final gastos = delMes
            .where((t) => t.esGasto)
            .fold(0.0, (s, t) => s + t.monto);
        final disponible = ingresos - gastos;
        final consumido = ingresos > 0 ? (gastos / ingresos * 100) : 0.0;

        // Rojo al pasarse, ámbar al acercarse: se ve de un vistazo sin leer.
        final Color colorBarra;
        if (consumido >= 100) {
          colorBarra = colorScheme.error;
        } else if (consumido >= 80) {
          colorBarra = Colors.orange;
        } else {
          colorBarra = colorScheme.primary;
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _Dato(
                        etiqueta: 'Ingresos',
                        valor: _fmt.format(ingresos),
                        color: Colors.green.shade600,
                        icono: Symbols.arrow_downward_rounded,
                      ),
                    ),
                    Expanded(
                      child: _Dato(
                        etiqueta: 'Gastos',
                        valor: _fmt.format(gastos),
                        color: colorScheme.error,
                        icono: Symbols.arrow_upward_rounded,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 28),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Disponible',
                              style: Theme.of(context).textTheme.bodySmall),
                          Text(
                            _fmt.format(disponible),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: disponible >= 0
                                      ? colorScheme.onSurface
                                      : colorScheme.error,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${consumido.round()}% consumido',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorBarra,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (consumido / 100).clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    color: colorBarra,
                  ),
                ),
                if (ingresos == 0 && gastos == 0) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Aún no hay movimientos este mes. Añade tus ingresos y '
                    'gastos con el botón de abajo.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Una cifra con su etiqueta e icono, para el resumen de arriba.
class _Dato extends StatelessWidget {
  final String etiqueta;
  final String valor;
  final Color color;
  final IconData icono;

  const _Dato({
    required this.etiqueta,
    required this.valor,
    required this.color,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icono, size: 14, color: color),
            const SizedBox(width: 4),
            Text(etiqueta, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          valor,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
        ),
      ],
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

    return BlocBuilder<FinanceCubit, FinanceState>(
      builder: (context, financeState) {
        double gastoCategoria = 0.0;
        if (financeState is FinanceLoaded) {
          final ahora = DateTime.now();
          gastoCategoria = financeState.transacciones
              .where((t) =>
                  t.esGasto &&
                  t.categoria == budget.categoria &&
                  t.fecha.month == ahora.month &&
                  t.fecha.year == ahora.year)
              .fold(0.0, (sum, t) => sum + t.monto);
        }

        final progreso = budget.limite > 0
            ? (gastoCategoria / budget.limite).clamp(0.0, 1.0)
            : 0.0;
        final porcentaje = budget.limite > 0
            ? (gastoCategoria / budget.limite * 100)
            : 0.0;

        final Color barColor;
        if (porcentaje >= 100) {
          barColor = Colors.red;
        } else if (porcentaje >= 80) {
          barColor = Colors.orange;
        } else {
          barColor = colorScheme.primary;
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          categoria.emoji,
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            categoria.nombre,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '${_fmt.format(gastoCategoria)} de ${_fmt.format(budget.limite)}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: barColor,
                                  fontWeight: porcentaje >= 80
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Symbols.edit_rounded, color: colorScheme.primary),
                          onPressed: () =>
                              _mostrarSheet(context, presupuestoExistente: budget),
                          tooltip: 'Editar límite',
                        ),
                        IconButton(
                          icon: Icon(Symbols.delete_rounded, color: colorScheme.error),
                          onPressed: () =>
                              context.read<BudgetCubit>().eliminar(budget.id),
                          tooltip: 'Eliminar presupuesto',
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progreso,
                    minHeight: 6,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(barColor),
                  ),
                ),
                if (porcentaje >= 100) ...[
                  const SizedBox(height: 4),
                  Text(
                    '¡Superaste el límite! (${porcentaje.round()}%)',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ] else if (porcentaje >= 80) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Cerca del límite (${porcentaje.round()}%)',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.orange,
                        ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
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
          child: const Icon(Symbols.add_rounded, size: 20),
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
                  icon: const Icon(Symbols.close_rounded),
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
