import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:glint/core/constants/app_constants.dart';
import 'package:glint/features/finance/domain/transaction_entity.dart';
import 'package:glint/shared/services/export_service.dart';
import 'finance_cubit.dart';
import 'finance_state.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocBuilder<FinanceCubit, FinanceState>(
        builder: (context, state) {
          if (state is FinanceLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FinanceLoaded) {
            return _buildContenido(context, state);
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarAgregarTransaccion(context),
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
    );
  }

  Widget _buildContenido(BuildContext context, FinanceLoaded state) {
    return CustomScrollView(
      slivers: [
        // AppBar personalizado
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: _HeaderFinanzas(state: state),
          ),
          title: const Text('Finanzas'),
          actions: [
            // Botón calculadora de salario SV
            IconButton(
              icon: const Icon(Icons.calculate_outlined),
              tooltip: 'Calculadora salarial 🇸🇻',
              onPressed: () => context.push(AppRoutes.salaryCalculator),
            ),
            // Botón exportar CSV
            IconButton(
              icon: const Icon(Icons.download_outlined),
              tooltip: 'Exportar a CSV',
              onPressed: () => _exportarCSV(context, state),
            ),
          ],
        ),

        // Acceso rápido a herramientas financieras
        SliverToBoxAdapter(
          child: _HerramientasFinanzas(),
        ),

        if (state.transacciones.isEmpty)
          SliverFillRemaining(child: _buildEstadoVacio(context))
        else ...[
          // Gráfica de gastos por categoría
          if (state.gastos.isNotEmpty)
            SliverToBoxAdapter(
              child: _GraficaGastos(state: state),
            ),

          // Lista de transacciones
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Movimientos del mes',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) =>
                  _TransaccionCard(transaccion: state.transacciones[i]),
              childCount: state.transacciones.length,
            ),
          ),
        ],

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildEstadoVacio(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.account_balance_wallet_outlined,
                  size: 48, color: colorScheme.primary),
            ),
            const SizedBox(height: 24),
            Text('Sin movimientos este mes',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    )),
            const SizedBox(height: 8),
            Text(
              'Registra tus ingresos y gastos\npara llevar el control de tu dinero',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withAlpha(153),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  /// Exporta las transacciones del mes actual a CSV y abre el menú de compartir
  Future<void> _exportarCSV(
      BuildContext context, FinanceLoaded state) async {
    if (state.transacciones.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay transacciones para exportar este mes'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Mostrar indicador de carga
    final snack = ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 14),
            Text('Generando CSV...'),
          ],
        ),
        duration: Duration(seconds: 10),
        behavior: SnackBarBehavior.floating,
      ),
    );

    final ahora = DateTime.now();
    final nombreArchivo =
        'glint_finanzas_${ahora.year}_${ahora.month.toString().padLeft(2, '0')}.csv';

    final resultado = await ExportService.exportarTransaccionesCSV(
      transacciones: state.transacciones,
      nombreArchivo: nombreArchivo,
    );

    snack.close();

    if (!context.mounted) return;

    if (resultado.exitoso) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '✅ ${resultado.totalRegistros} transacciones exportadas'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green.shade700,
        ),
      );
    } else if (resultado.estaVacio) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay transacciones para exportar'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al exportar: ${resultado.mensajeError}'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  void _mostrarAgregarTransaccion(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<FinanceCubit>(),
        child: const _AgregarTransaccionSheet(),
      ),
    );
  }
}

// ── Header con balance ────────────────────────────────────────────────────────

class _HeaderFinanzas extends StatelessWidget {
  final FinanceLoaded state;
  const _HeaderFinanzas({required this.state});

  @override
  Widget build(BuildContext context) {
    final colorScheme      = Theme.of(context).colorScheme;
    final balancePositivo  = state.balance >= 0;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primary.withAlpha(180),
          ],
        ),
      ),
      padding: EdgeInsets.fromLTRB(
          20, MediaQuery.of(context).padding.top + 60, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Balance del mes',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: colorScheme.onPrimary.withAlpha(200),
                  )),
          const SizedBox(height: 4),
          Text(
            '\$${state.balance.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MiniResumen(
                  icon: Icons.arrow_upward_rounded,
                  label: 'Ingresos',
                  monto: state.totalIngresos,
                  color: Colors.greenAccent,
                  onPrimary: colorScheme.onPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MiniResumen(
                  icon: Icons.arrow_downward_rounded,
                  label: 'Gastos',
                  monto: state.totalGastos,
                  color: balancePositivo
                      ? Colors.redAccent
                      : Colors.red.shade300,
                  onPrimary: colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniResumen extends StatelessWidget {
  final IconData icon;
  final String label;
  final double monto;
  final Color color;
  final Color onPrimary;

  const _MiniResumen({
    required this.icon,
    required this.label,
    required this.monto,
    required this.color,
    required this.onPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withAlpha(50),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      color: onPrimary.withAlpha(180), fontSize: 11)),
              Text(
                '\$${monto.toStringAsFixed(2)}',
                style: TextStyle(
                    color: onPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Gráfica de gastos por categoría ──────────────────────────────────────────

class _GraficaGastos extends StatefulWidget {
  final FinanceLoaded state;
  const _GraficaGastos({required this.state});

  @override
  State<_GraficaGastos> createState() => _GraficaGastosState();
}

class _GraficaGastosState extends State<_GraficaGastos> {
  int? _tocado;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Agrupar gastos por categoría
    final Map<String, double> porCategoria = {};
    for (final t in widget.state.gastos) {
      porCategoria[t.categoria] =
          (porCategoria[t.categoria] ?? 0) + t.monto;
    }
    final categorias = porCategoria.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (categorias.isEmpty) return const SizedBox();

    final colores = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.amber,
      Colors.cyan,
      Colors.red,
    ];

    final secciones = List.generate(categorias.length, (i) {
      final porcentaje =
          (categorias[i].value / widget.state.totalGastos) * 100;
      final tocado = _tocado == i;
      return PieChartSectionData(
        color: colores[i % colores.length],
        value: categorias[i].value,
        title: tocado ? '${porcentaje.toStringAsFixed(0)}%' : '',
        radius: tocado ? 60 : 50,
        titleStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13),
      );
    });

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(80),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withAlpha(50)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Gastos por categoría',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Row(
            children: [
              // Pie chart
              SizedBox(
                height: 140,
                width: 140,
                child: PieChart(
                  PieChartData(
                    sections: secciones,
                    centerSpaceRadius: 30,
                    sectionsSpace: 2,
                    pieTouchData: PieTouchData(
                      touchCallback: (event, response) {
                        setState(() {
                          _tocado = response
                              ?.touchedSection?.touchedSectionIndex;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Leyenda
              Expanded(
                child: Column(
                  children: List.generate(
                    categorias.length > 5 ? 5 : categorias.length,
                    (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: colores[i % colores.length],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              categorias[i].key,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '\$${categorias[i].value.toStringAsFixed(0)}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Tarjeta de transacción ────────────────────────────────────────────────────

class _TransaccionCard extends StatelessWidget {
  final TransactionEntity transaccion;
  const _TransaccionCard({required this.transaccion});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final esIngreso   = transaccion.esIngreso;
    final tieneImagen = transaccion.imagenPath != null &&
        transaccion.imagenPath!.isNotEmpty;
    final tieneNotas  = transaccion.notas != null &&
        transaccion.notas!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
              color: colorScheme.outline.withAlpha(40)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: tieneNotas || tieneImagen
              ? () => _verDetalle(context)
              : null,
          onLongPress: () => _confirmarEliminar(context),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Icono categoría
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: esIngreso
                        ? Colors.green.withAlpha(26)
                        : colorScheme.errorContainer.withAlpha(80),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(transaccion.categoriaEmoji,
                        style: const TextStyle(fontSize: 22)),
                  ),
                ),
                const SizedBox(width: 12),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaccion.descripcion,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            transaccion.categoria,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: colorScheme.onSurface
                                        .withAlpha(128)),
                          ),
                          Text(
                            ' · ${_formatFecha(transaccion.fecha)}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: colorScheme.onSurface
                                        .withAlpha(100)),
                          ),
                        ],
                      ),
                      if (tieneNotas) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.notes,
                                size: 12,
                                color: colorScheme.primary),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                transaccion.notas!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: colorScheme.primary,
                                        fontStyle: FontStyle.italic),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Monto + imagen indicador
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${esIngreso ? '+' : '-'}\$${transaccion.monto.toStringAsFixed(2)}',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(
                            color: esIngreso
                                ? Colors.green
                                : colorScheme.error,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    if (tieneImagen) ...[
                      const SizedBox(height: 4),
                      Icon(Icons.photo_outlined,
                          size: 14,
                          color: colorScheme.onSurface.withAlpha(128)),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatFecha(DateTime fecha) {
    final meses = [
      '', 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];
    return '${fecha.day} ${meses[fecha.month]}';
  }

  void _verDetalle(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _DetalleTransaccionSheet(transaccion: transaccion),
    );
  }

  void _confirmarEliminar(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar transacción'),
        content: Text('¿Eliminar "${transaccion.descripcion}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.error),
            onPressed: () {
              Navigator.pop(ctx);
              context
                  .read<FinanceCubit>()
                  .eliminarTransaccion(transaccion.id);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

// ── Detalle de transacción ────────────────────────────────────────────────────

class _DetalleTransaccionSheet extends StatelessWidget {
  final TransactionEntity transaccion;
  const _DetalleTransaccionSheet({required this.transaccion});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tieneImagen = transaccion.imagenPath != null &&
        transaccion.imagenPath!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Row(
            children: [
              Text(transaccion.categoriaEmoji,
                  style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(transaccion.descripcion,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    Text(transaccion.categoria,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                                color: colorScheme.onSurface
                                    .withAlpha(153))),
                  ],
                ),
              ),
              Text(
                '${transaccion.esIngreso ? '+' : '-'}\$${transaccion.monto.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: transaccion.esIngreso
                          ? Colors.green
                          : colorScheme.error,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
          if (transaccion.notas != null &&
              transaccion.notas!.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text('Notas',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                    )),
            const SizedBox(height: 6),
            Text(transaccion.notas!,
                style: Theme.of(context).textTheme.bodyMedium),
          ],
          if (tieneImagen) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text('Comprobante',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                    )),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(transaccion.imagenPath!),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ── Bottom sheet agregar transacción ─────────────────────────────────────────

class _AgregarTransaccionSheet extends StatefulWidget {
  const _AgregarTransaccionSheet();

  @override
  State<_AgregarTransaccionSheet> createState() =>
      _AgregarTransaccionSheetState();
}

class _AgregarTransaccionSheetState
    extends State<_AgregarTransaccionSheet> {
  final _descripcionCtrl = TextEditingController();
  final _montoCtrl       = TextEditingController();
  final _notasCtrl       = TextEditingController();
  final _formKey         = GlobalKey<FormState>();

  TipoTransaccion  _tipo       = TipoTransaccion.gasto;
  CategoriaGasto   _catGasto   = CategoriaGasto.alimentacion;
  CategoriaIngreso _catIngreso = CategoriaIngreso.salario;
  String? _imagenPath;

  @override
  void dispose() {
    _descripcionCtrl.dispose();
    _montoCtrl.dispose();
    _notasCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      builder: (_, scrollCtrl) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            controller: scrollCtrl,
            padding: EdgeInsets.fromLTRB(
                24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 24),
            children: [
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

              Text('Nueva transacción',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      )),
              const SizedBox(height: 20),

              // Tipo: ingreso / gasto
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: _SegmentBtn(
                        label: '📈 Ingreso',
                        selected: _tipo == TipoTransaccion.ingreso,
                        color: Colors.green,
                        onTap: () =>
                            setState(() => _tipo = TipoTransaccion.ingreso),
                      ),
                    ),
                    Expanded(
                      child: _SegmentBtn(
                        label: '📉 Gasto',
                        selected: _tipo == TipoTransaccion.gasto,
                        color: colorScheme.error,
                        onTap: () =>
                            setState(() => _tipo = TipoTransaccion.gasto),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Monto grande
              TextFormField(
                controller: _montoCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: _tipo == TipoTransaccion.ingreso
                          ? Colors.green
                          : colorScheme.error,
                    ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: '0.00',
                  hintStyle: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(
                          color: colorScheme.onSurface.withAlpha(80),
                          fontWeight: FontWeight.w800),
                  prefixText: '\$  ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Ingresa un monto';
                  if (double.tryParse(v.trim()) == null) {
                    return 'Número inválido';
                  }
                  if (double.parse(v.trim()) <= 0) return 'Debe ser mayor a 0';
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Descripción
              TextFormField(
                controller: _descripcionCtrl,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  prefixIcon: const Icon(Icons.edit_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Agrega una descripción'
                    : null,
              ),
              const SizedBox(height: 14),

              // Categoría
              if (_tipo == TipoTransaccion.gasto)
                DropdownButtonFormField<CategoriaGasto>(
                  initialValue: _catGasto,
                  decoration: InputDecoration(
                    labelText: 'Categoría',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  items: CategoriaGasto.values
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text('${c.emoji}  ${c.nombre}'),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _catGasto = v!),
                )
              else
                DropdownButtonFormField<CategoriaIngreso>(
                  initialValue: _catIngreso,
                  decoration: InputDecoration(
                    labelText: 'Categoría',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  items: CategoriaIngreso.values
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text('${c.emoji}  ${c.nombre}'),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _catIngreso = v!),
                ),
              const SizedBox(height: 14),

              // Notas (comentario libre)
              TextFormField(
                controller: _notasCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Notas (opcional)',
                  hintText: 'Ej: pago de factura de marzo...',
                  prefixIcon: const Icon(Icons.notes_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 14),

              // Foto de comprobante
              _FotoComprobante(
                imagenPath: _imagenPath,
                onImagenSeleccionada: (path) =>
                    setState(() => _imagenPath = path),
              ),
              const SizedBox(height: 24),

              FilledButton(
                onPressed: () => _guardar(),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Guardar transacción',
                    style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final categoria = _tipo == TipoTransaccion.gasto
        ? _catGasto.nombre
        : _catIngreso.nombre;
    final emoji = _tipo == TipoTransaccion.gasto
        ? _catGasto.emoji
        : _catIngreso.emoji;

    try {
      await context.read<FinanceCubit>().agregarTransaccion(
            tipo:           _tipo,
            monto:          double.parse(_montoCtrl.text.trim()),
            descripcion:    _descripcionCtrl.text.trim(),
            categoria:      categoria,
            categoriaEmoji: emoji,
            notas:          _notasCtrl.text.trim().isEmpty
                                ? null
                                : _notasCtrl.text.trim(),
            imagenPath:     _imagenPath,
          );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
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

// ── Widget foto comprobante ───────────────────────────────────────────────────

class _FotoComprobante extends StatelessWidget {
  final String? imagenPath;
  final ValueChanged<String> onImagenSeleccionada;

  const _FotoComprobante({
    required this.imagenPath,
    required this.onImagenSeleccionada,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tieneImagen = imagenPath != null && imagenPath!.isNotEmpty;

    return GestureDetector(
      onTap: () => _seleccionarImagen(context),
      child: Container(
        height: tieneImagen ? 160 : 80,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: colorScheme.outline.withAlpha(80), width: 1.5),
        ),
        child: tieneImagen
            ? ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(File(imagenPath!), fit: BoxFit.cover),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.edit,
                            color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined,
                      color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Agregar foto de comprobante',
                    style: TextStyle(color: colorScheme.primary),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _seleccionarImagen(BuildContext context) async {
    final picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Tomar foto'),
              onTap: () async {
                Navigator.pop(ctx);
                final img = await picker.pickImage(
                    source: ImageSource.camera, imageQuality: 70);
                if (img != null) onImagenSeleccionada(img.path);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Elegir de galería'),
              onTap: () async {
                Navigator.pop(ctx);
                final img = await picker.pickImage(
                    source: ImageSource.gallery, imageQuality: 70);
                if (img != null) onImagenSeleccionada(img.path);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Botón segmentado ──────────────────────────────────────────────────────────

class _SegmentBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _SegmentBtn({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? color.withAlpha(220) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : null,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Acceso rápido a herramientas financieras ──────────────────────────────────

class _HerramientasFinanzas extends StatelessWidget {
  const _HerramientasFinanzas();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Herramientas',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _HerramientaCard(
                  icon: Icons.pie_chart_outline,
                  label: 'Presupuesto',
                  color: const Color(0xFF1565C0),
                  onTap: () => context.push(AppRoutes.financeBudget),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HerramientaCard(
                  icon: Icons.savings_outlined,
                  label: 'Mis Metas',
                  color: const Color(0xFF2E7D32),
                  onTap: () => context.push(AppRoutes.financeSavingsGoals),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HerramientaCard(
                  icon: Icons.swap_horiz_outlined,
                  label: 'Deudas',
                  color: const Color(0xFFAD1457),
                  onTap: () => context.push(AppRoutes.financeDebts),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HerramientaCard(
                  icon: Icons.repeat_outlined,
                  label: 'Recurrentes',
                  color: const Color(0xFFE65100),
                  onTap: () => context.push(AppRoutes.financeRecurring),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HerramientaCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _HerramientaCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withAlpha(60)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
