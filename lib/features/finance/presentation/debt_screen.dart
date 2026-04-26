import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:glint/features/finance/domain/debt_entity.dart';
import 'debt_cubit.dart';

final _fmt = NumberFormat.currency(locale: 'en_US', symbol: '\$');
final _fmtFecha = DateFormat('dd/MM/yyyy', 'es');

class DebtScreen extends StatelessWidget {
  const DebtScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocBuilder<DebtCubit, DebtState>(
        builder: (context, state) {
          if (state is DebtLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DebtLoaded) {
            return _DebtContenido(state: state);
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

  void _mostrarFormulario(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<DebtCubit>(),
        child: const _DeudaSheet(),
      ),
    );
  }
}

// ── Contenido principal ───────────────────────────────────────────────────────

class _DebtContenido extends StatefulWidget {
  final DebtLoaded state;
  const _DebtContenido({required this.state});

  @override
  State<_DebtContenido> createState() => _DebtContenidoState();
}

class _DebtContenidoState extends State<_DebtContenido> {
  int _tabSeleccionada = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final deudasLeDebo = widget.state.deudas
        .where((d) => d.tipo == TipoDeuda.leDebo)
        .toList();
    final deudasMeDebeN = widget.state.deudas
        .where((d) => d.tipo == TipoDeuda.meDebeN)
        .toList();
    final deudas = _tabSeleccionada == 0 ? deudasLeDebo : deudasMeDebeN;

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          pinned: true,
          title: Text('Mis Deudas'),
        ),

        // Tarjetas resumen
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: _TarjetaResumen(
                    emoji: '📤',
                    titulo: 'Le debo',
                    monto: widget.state.totalLeDebo,
                    color: colorScheme.error,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TarjetaResumen(
                    emoji: '📥',
                    titulo: 'Me deben',
                    monto: widget.state.totalMeDebeN,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),

        // SegmentedButton tabs
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('📤  Le debo')),
                ButtonSegment(value: 1, label: Text('📥  Me deben')),
              ],
              selected: {_tabSeleccionada},
              onSelectionChanged: (s) => setState(() => _tabSeleccionada = s.first),
            ),
          ),
        ),

        // Lista de deudas
        if (deudas.isEmpty)
          SliverFillRemaining(child: _buildEstadoVacio(context))
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            sliver: SliverList.builder(
              itemCount: deudas.length,
              itemBuilder: (context, index) {
                final deuda = deudas[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _DeudaCard(deuda: deuda),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildEstadoVacio(BuildContext context) {
    final tipo = _tabSeleccionada == 0 ? 'Le debo' : 'Me deben';
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _tabSeleccionada == 0 ? '📤' : '📥',
            style: const TextStyle(fontSize: 56),
          ),
          const SizedBox(height: 16),
          Text(
            'Sin deudas en "$tipo"',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Toca + para registrar una deuda',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

// ── Tarjeta resumen ───────────────────────────────────────────────────────────

class _TarjetaResumen extends StatelessWidget {
  final String emoji;
  final String titulo;
  final double monto;
  final Color color;

  const _TarjetaResumen({
    required this.emoji,
    required this.titulo,
    required this.monto,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text(titulo, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(
              _fmt.format(monto),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Card de deuda ─────────────────────────────────────────────────────────────

class _DeudaCard extends StatelessWidget {
  final DebtEntity deuda;
  const _DeudaCard({required this.deuda});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final esLeDebo = deuda.tipo == TipoDeuda.leDebo;
    final color = esLeDebo ? colorScheme.error : Colors.green;

    return Dismissible(
      key: Key(deuda.id),
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
            title: const Text('Eliminar deuda'),
            content: Text('¿Eliminar deuda con "${deuda.nombre}"?'),
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
      onDismissed: (_) => context.read<DebtCubit>().eliminar(deuda.id),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withAlpha(26),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        deuda.tipo.emoji,
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
                          deuda.nombre,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                decoration: deuda.pagado
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: deuda.pagado
                                    ? colorScheme.onSurface.withAlpha(128)
                                    : null,
                              ),
                        ),
                        Text(
                          deuda.concepto,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: deuda.pagado
                                    ? colorScheme.onSurface.withAlpha(100)
                                    : null,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _fmtFecha.format(deuda.fecha),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _fmt.format(deuda.monto),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: deuda.pagado
                                  ? colorScheme.onSurface.withAlpha(128)
                                  : color,
                              fontWeight: FontWeight.bold,
                              decoration: deuda.pagado
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                      ),
                      const SizedBox(height: 4),
                      if (!deuda.pagado)
                        IconButton(
                          icon: Icon(Icons.check_circle_outline, color: color),
                          onPressed: () =>
                              context.read<DebtCubit>().marcarPagado(deuda.id),
                          tooltip: 'Marcar como pagado',
                          visualDensity: VisualDensity.compact,
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.withAlpha(26),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Pagado',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            // Calculadora de proyección — solo para deudas no pagadas
            if (!deuda.pagado)
              _ProyeccionDeuda(monto: deuda.monto),
          ],
        ),
      ),
    );
  }
}

// ── Proyección de pago de deuda ───────────────────────────────────────────────

class _ProyeccionDeuda extends StatelessWidget {
  final double monto;
  const _ProyeccionDeuda({required this.monto});

  Widget _proyeccion(BuildContext context) {
    final cuotas = [
      (monto * 0.10).roundToDouble(),
      (monto * 0.15).roundToDouble(),
      (monto * 0.20).roundToDouble(),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: cuotas.map((cuota) {
          final meses = (monto / cuota).ceil();
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                const Icon(Icons.calendar_month_outlined, size: 14),
                const SizedBox(width: 6),
                Text(
                  'Pagando \$${cuota.toStringAsFixed(0)}/mes → $meses ${meses == 1 ? 'mes' : 'meses'}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: Icon(
          Icons.calculate_outlined,
          size: 18,
          color: colorScheme.primary,
        ),
        title: Text(
          '¿Cuándo termino de pagar?',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
        ),
        children: [_proyeccion(context)],
      ),
    );
  }
}

// ── Sheet para nueva deuda ────────────────────────────────────────────────────

class _DeudaSheet extends StatefulWidget {
  const _DeudaSheet();

  @override
  State<_DeudaSheet> createState() => _DeudaSheetState();
}

class _DeudaSheetState extends State<_DeudaSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _conceptoController = TextEditingController();
  final _montoController = TextEditingController();

  TipoDeuda _tipoSeleccionado = TipoDeuda.leDebo;
  DateTime _fecha = DateTime.now();

  @override
  void dispose() {
    _nombreController.dispose();
    _conceptoController.dispose();
    _montoController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (fecha != null) setState(() => _fecha = fecha);
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;
    final monto = double.tryParse(_montoController.text.trim()) ?? 0;
    if (monto <= 0) return;

    context.read<DebtCubit>().crearDeuda(
          _nombreController.text.trim(),
          _conceptoController.text.trim(),
          monto,
          _tipoSeleccionado,
          _fecha,
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Nueva deuda',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Tipo de deuda
              SegmentedButton<TipoDeuda>(
                segments: const [
                  ButtonSegment(
                    value: TipoDeuda.leDebo,
                    label: Text('📤  Le debo'),
                  ),
                  ButtonSegment(
                    value: TipoDeuda.meDebeN,
                    label: Text('📥  Me deben'),
                  ),
                ],
                selected: {_tipoSeleccionado},
                onSelectionChanged: (s) =>
                    setState(() => _tipoSeleccionado = s.first),
              ),
              const SizedBox(height: 20),

              // Nombre persona
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la persona',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Ingresa el nombre' : null,
              ),
              const SizedBox(height: 16),

              // Concepto
              TextFormField(
                controller: _conceptoController,
                decoration: const InputDecoration(
                  labelText: 'Concepto (¿por qué?)',
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Ingresa el concepto' : null,
              ),
              const SizedBox(height: 16),

              // Monto
              TextFormField(
                controller: _montoController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Monto',
                  prefixText: '\$ ',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Ingresa un monto';
                  final n = double.tryParse(v.trim());
                  if (n == null || n <= 0) return 'Ingresa un monto válido';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Fecha
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today_outlined),
                title: Text(_fmtFecha.format(_fecha)),
                subtitle: const Text('Fecha de la deuda'),
                onTap: _seleccionarFecha,
              ),
              const SizedBox(height: 24),

              FilledButton(
                onPressed: _guardar,
                child: const Text('Guardar deuda'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
