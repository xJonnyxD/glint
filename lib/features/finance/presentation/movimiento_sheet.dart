import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:glint/features/finance/domain/transaction_entity.dart';
import 'package:glint/features/finance/presentation/finance_cubit.dart';
import 'package:glint/features/finance/presentation/finance_icons.dart';

/// Alta y edición de un movimiento propio (ingreso o gasto).
///
/// Al guardar no hay que refrescar nada a mano: el presupuesto, el resumen y
/// las barras por categoría leen del mismo flujo de transacciones, así que se
/// recalculan solos.
class MovimientoSheet extends StatefulWidget {
  /// Movimiento a editar; `null` para crear uno nuevo.
  final TransactionEntity? original;

  /// Mes y año que se está viendo, para que la fecha por defecto caiga ahí.
  final int mes;
  final int anio;

  const MovimientoSheet({
    super.key,
    this.original,
    required this.mes,
    required this.anio,
  });

  @override
  State<MovimientoSheet> createState() => _MovimientoSheetState();
}

class _MovimientoSheetState extends State<MovimientoSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _conceptoCtrl;
  late final TextEditingController _montoCtrl;

  late TipoTransaccion _tipo;
  late DateTime _fecha;
  CategoriaGasto _catGasto = CategoriaGasto.alimentacion;
  CategoriaIngreso _catIngreso = CategoriaIngreso.salario;
  bool _guardando = false;

  bool get _esEdicion => widget.original != null;

  @override
  void initState() {
    super.initState();
    final o = widget.original;
    _conceptoCtrl = TextEditingController(text: o?.descripcion ?? '');
    _montoCtrl = TextEditingController(
      text: o != null ? o.monto.toStringAsFixed(2) : '',
    );
    _tipo = o?.tipo ?? TipoTransaccion.gasto;

    final ahora = DateTime.now();
    _fecha = o?.fecha ??
        (ahora.month == widget.mes && ahora.year == widget.anio
            ? DateTime(ahora.year, ahora.month, ahora.day)
            : DateTime(widget.anio, widget.mes, 1));

    if (o != null) {
      if (o.esGasto) {
        _catGasto = CategoriaGasto.values.firstWhere(
          (c) => c.nombre == o.categoria,
          orElse: () => CategoriaGasto.otro,
        );
      } else {
        _catIngreso = CategoriaIngreso.values.firstWhere(
          (c) => c.nombre == o.categoria,
          orElse: () => CategoriaIngreso.otro,
        );
      }
    }
  }

  @override
  void dispose() {
    _conceptoCtrl.dispose();
    _montoCtrl.dispose();
    super.dispose();
  }

  Future<void> _elegirFecha() async {
    final elegida = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (elegida == null || !mounted) return;
    // Solo año/mes/día, y en hora local: guardar una fecha en UTC hace que el
    // movimiento aparezca el día anterior en zonas al oeste de Greenwich.
    setState(
      () => _fecha = DateTime(elegida.year, elegida.month, elegida.day),
    );
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final esGasto = _tipo == TipoTransaccion.gasto;
    final monto = double.parse(_montoCtrl.text.replaceAll(',', '.'));
    final categoria = esGasto ? _catGasto.nombre : _catIngreso.nombre;
    // Se sigue guardando el emoji de la categoría porque es lo que espera el
    // esquema y lo que viaja al servidor; en pantalla se pinta como icono.
    final emoji = esGasto ? _catGasto.emoji : _catIngreso.emoji;

    setState(() => _guardando = true);
    final cubit = context.read<FinanceCubit>();
    final navegador = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    try {
      if (_esEdicion) {
        await cubit.editarTransaccion(
          original: widget.original!,
          tipo: _tipo,
          monto: monto,
          descripcion: _conceptoCtrl.text.trim(),
          categoria: categoria,
          categoriaEmoji: emoji,
          fecha: _fecha,
        );
      } else {
        await cubit.agregarTransaccion(
          tipo: _tipo,
          monto: monto,
          descripcion: _conceptoCtrl.text.trim(),
          categoria: categoria,
          categoriaEmoji: emoji,
          fecha: _fecha,
        );
      }
      navegador.pop();
    } catch (_) {
      if (mounted) setState(() => _guardando = false);
      messenger.showSnackBar(
        const SnackBar(
          content: Text('No se pudo guardar el movimiento.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: cs.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  _esEdicion ? 'Editar movimiento' : 'Nuevo movimiento',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),

                SegmentedButton<TipoTransaccion>(
                  segments: const [
                    ButtonSegment(
                      value: TipoTransaccion.gasto,
                      label: Text('Gasto'),
                      icon: Icon(Icons.trending_down),
                    ),
                    ButtonSegment(
                      value: TipoTransaccion.ingreso,
                      label: Text('Ingreso'),
                      icon: Icon(Icons.trending_up),
                    ),
                  ],
                  selected: {_tipo},
                  onSelectionChanged: (s) => setState(() => _tipo = s.first),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _conceptoCtrl,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Concepto',
                    hintText: 'Ej: Compra del súper',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Escribe un concepto'
                      : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _montoCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Monto',
                    prefixText: '\$ ',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    final n = double.tryParse((v ?? '').replaceAll(',', '.'));
                    if (n == null) return 'Escribe un monto válido';
                    if (n <= 0) return 'El monto debe ser mayor que cero';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                if (_tipo == TipoTransaccion.gasto)
                  DropdownButtonFormField<CategoriaGasto>(
                    initialValue: _catGasto,
                    decoration: const InputDecoration(
                      labelText: 'Categoría',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      for (final c in CategoriaGasto.values)
                        DropdownMenuItem(
                          value: c,
                          child: Row(children: [
                            Icon(iconoGasto(c), size: 18),
                            const SizedBox(width: 8),
                            Text(c.nombre),
                          ]),
                        ),
                    ],
                    onChanged: (v) => setState(() => _catGasto = v!),
                  )
                else
                  DropdownButtonFormField<CategoriaIngreso>(
                    initialValue: _catIngreso,
                    decoration: const InputDecoration(
                      labelText: 'Categoría',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      for (final c in CategoriaIngreso.values)
                        DropdownMenuItem(
                          value: c,
                          child: Row(children: [
                            Icon(iconoIngreso(c), size: 18),
                            const SizedBox(width: 8),
                            Text(c.nombre),
                          ]),
                        ),
                    ],
                    onChanged: (v) => setState(() => _catIngreso = v!),
                  ),
                const SizedBox(height: 12),

                OutlinedButton.icon(
                  onPressed: _elegirFecha,
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: Text(DateFormat('d MMMM yyyy', 'es').format(_fecha)),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                const SizedBox(height: 20),

                FilledButton(
                  onPressed: _guardando ? null : _guardar,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: _guardando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          _esEdicion ? 'Guardar cambios' : 'Añadir movimiento'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
