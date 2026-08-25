import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:glint/features/groups/domain/debt_simplifier.dart';
import 'package:glint/features/groups/domain/group_detail.dart';
import 'package:glint/features/groups/domain/shared_expense_entity.dart';
import 'group_categories.dart';
import 'group_detail_cubit.dart';
import 'widgets/member_avatar.dart';

final _fmtFecha = DateFormat('dd MMM yyyy', 'es');

/// Cómo se reparte un gasto entre los miembros.
enum ModoReparto { igual, cantidades, porcentajes }

/// Formulario para registrar o editar un gasto, con reparto flexible:
/// equitativo, por cantidades exactas o por porcentajes.
class AddExpenseScreen extends StatefulWidget {
  final GroupDetail detalle;
  final SharedExpenseEntity? gastoEditar;
  const AddExpenseScreen({super.key, required this.detalle, this.gastoEditar});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descCtrl = TextEditingController();
  final _montoCtrl = TextEditingController();

  late String _pagadoPor;
  late Set<String> _entre; // para modo "igual"
  final Map<String, TextEditingController> _cantidadCtrls = {};
  final Map<String, TextEditingController> _porcentajeCtrls = {};
  ModoReparto _modo = ModoReparto.igual;
  String _categoria = '🧾';
  DateTime _fecha = DateTime.now();

  bool get _esEdicion => widget.gastoEditar != null;

  @override
  void initState() {
    super.initState();
    for (final m in widget.detalle.miembros) {
      _cantidadCtrls[m.id] = TextEditingController();
      _porcentajeCtrls[m.id] = TextEditingController();
    }

    final g = widget.gastoEditar;
    if (g != null) {
      _descCtrl.text = g.descripcion;
      _montoCtrl.text = g.monto.toStringAsFixed(2);
      _pagadoPor = g.pagadoPor;
      _categoria = g.categoria;
      _fecha = g.fecha;
      // Prefill de partes: se guarda por cantidades exactas.
      _entre = {for (final p in g.partes) p.miembroId};
      for (final p in g.partes) {
        _cantidadCtrls[p.miembroId]?.text = p.monto.toStringAsFixed(2);
      }
      // Si todas las partes son iguales, se queda en "igual"; si no, cantidades.
      final montos = g.partes.map((p) => p.monto).toSet();
      _modo = montos.length <= 1 ? ModoReparto.igual : ModoReparto.cantidades;
    } else {
      _pagadoPor = widget.detalle.miembros.first.id;
      _entre = {for (final m in widget.detalle.miembros) m.id};
    }
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    _montoCtrl.dispose();
    for (final c in _cantidadCtrls.values) {
      c.dispose();
    }
    for (final c in _porcentajeCtrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  double get _monto => double.tryParse(_montoCtrl.text.trim()) ?? 0;

  double _num(TextEditingController c) => double.tryParse(c.text.trim()) ?? 0;

  /// Construye el mapa miembroId → monto según el modo. Devuelve null si no
  /// cuadra (para bloquear el guardado).
  Map<String, double>? _calcularPartes() {
    switch (_modo) {
      case ModoReparto.igual:
        if (_entre.isEmpty) return null;
        return DebtSimplifier.repartirEquitativo(_monto, _entre.toList());
      case ModoReparto.cantidades:
        final partes = <String, double>{};
        for (final e in _cantidadCtrls.entries) {
          final v = _num(e.value);
          if (v > 0) partes[e.key] = double.parse(v.toStringAsFixed(2));
        }
        if (partes.isEmpty) return null;
        final suma = partes.values.fold(0.0, (s, v) => s + v);
        if ((suma - _monto).abs() > 0.01) return null; // debe cuadrar
        return partes;
      case ModoReparto.porcentajes:
        final pcts = <String, double>{};
        for (final e in _porcentajeCtrls.entries) {
          final v = _num(e.value);
          if (v > 0) pcts[e.key] = v;
        }
        if (pcts.isEmpty) return null;
        final sumaPct = pcts.values.fold(0.0, (s, v) => s + v);
        if ((sumaPct - 100).abs() > 0.1) return null; // debe sumar 100%
        // Repartir el monto según % y cuadrar céntimos en el primero.
        final partes = <String, double>{};
        var acumulado = 0.0;
        final ids = pcts.keys.toList();
        for (var i = 0; i < ids.length; i++) {
          if (i == ids.length - 1) {
            partes[ids[i]] = double.parse((_monto - acumulado).toStringAsFixed(2));
          } else {
            final v = double.parse((_monto * pcts[ids[i]]! / 100).toStringAsFixed(2));
            partes[ids[i]] = v;
            acumulado += v;
          }
        }
        return partes;
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final partes = _calcularPartes();
    if (partes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El reparto no cuadra con el monto')),
      );
      return;
    }
    final nav = Navigator.of(context);
    final cubit = context.read<GroupDetailCubit>();
    final moneda = widget.detalle.grupo.moneda;

    if (_esEdicion) {
      await cubit.editarGasto(
        gastoId: widget.gastoEditar!.id,
        descripcion: _descCtrl.text.trim(),
        monto: _monto,
        pagadoPor: _pagadoPor,
        fecha: _fecha,
        partes: partes,
        categoria: _categoria,
        moneda: moneda,
      );
    } else {
      await cubit.crearGasto(
        descripcion: _descCtrl.text.trim(),
        monto: _monto,
        pagadoPor: _pagadoPor,
        fecha: _fecha,
        partes: partes,
        categoria: _categoria,
        moneda: moneda,
      );
    }
    nav.pop();
  }

  Future<void> _seleccionarFecha() async {
    final f = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (f != null) setState(() => _fecha = f);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final miembros = widget.detalle.miembros;

    return Scaffold(
      appBar: AppBar(title: Text(_esEdicion ? 'Editar gasto' : 'Nuevo gasto')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Monto grande protagonista.
            Center(
              child: IntrinsicWidth(
                child: TextFormField(
                  controller: _montoCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  onChanged: (_) => setState(() {}),
                  style: TextStyle(
                      fontSize: 44, fontWeight: FontWeight.bold, color: cs.primary),
                  decoration: InputDecoration(
                    prefixText: '\$ ',
                    prefixStyle:
                        TextStyle(fontSize: 32, color: cs.primary.withAlpha(160)),
                    hintText: '0',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  validator: (v) {
                    final n = double.tryParse((v ?? '').trim());
                    if (n == null || n <= 0) return 'Ingresa un monto válido';
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _descCtrl,
              decoration: InputDecoration(
                labelText: 'Descripción',
                hintText: 'Ej. Gasolina, Cena, Súper',
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(_categoria, style: const TextStyle(fontSize: 22)),
                ),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Describe el gasto' : null,
            ),
            const SizedBox(height: 16),

            Text('Categoría', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final c in categoriasGasto)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        avatar: Icon(c.icono, size: 18),
                        label: Text(c.etiqueta),
                        selected: _categoria == c.emoji,
                        onSelected: (_) => setState(() => _categoria = c.emoji),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text('¿Quién pagó?', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _pagadoPor,
              decoration: const InputDecoration(
                prefixIcon: Icon(Symbols.account_circle_rounded),
              ),
              items: [
                for (final m in miembros)
                  DropdownMenuItem(
                    value: m.id,
                    child: Row(
                      children: [
                        MemberAvatar(
                            nombre: m.nombre,
                            seed: m.id,
                            esVirtual: m.esVirtual,
                            radio: 12),
                        const SizedBox(width: 8),
                        Text(m.nombre),
                      ],
                    ),
                  ),
              ],
              onChanged: (v) => setState(() => _pagadoPor = v ?? _pagadoPor),
            ),
            const SizedBox(height: 20),

            // Modo de reparto
            Text('¿Cómo se reparte?', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            SegmentedButton<ModoReparto>(
              segments: const [
                ButtonSegment(value: ModoReparto.igual, label: Text('Igual')),
                ButtonSegment(value: ModoReparto.cantidades, label: Text('\$')),
                ButtonSegment(value: ModoReparto.porcentajes, label: Text('%')),
              ],
              selected: {_modo},
              onSelectionChanged: (s) => setState(() => _modo = s.first),
            ),
            const SizedBox(height: 10),

            _buildReparto(miembros, cs),
            const SizedBox(height: 12),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Symbols.calendar_today_rounded),
              title: Text(_fmtFecha.format(_fecha)),
              subtitle: const Text('Fecha del gasto'),
              onTap: _seleccionarFecha,
            ),
            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: _guardar,
              icon: const Icon(Symbols.check_rounded),
              label: Text(_esEdicion ? 'Guardar cambios' : 'Guardar gasto'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReparto(List miembros, ColorScheme cs) {
    if (_modo == ModoReparto.igual) {
      final porCabeza = _entre.isEmpty ? 0.0 : _monto / _entre.length;
      return Column(
        children: [
          if (_monto > 0 && _entre.isNotEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: Text('\$${porCabeza.toStringAsFixed(2)} c/u',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: cs.primary, fontWeight: FontWeight.bold)),
            ),
          Card(
            child: Column(
              children: [
                for (final m in miembros)
                  CheckboxListTile(
                    value: _entre.contains(m.id),
                    secondary: MemberAvatar(
                        nombre: m.nombre,
                        seed: m.id,
                        esVirtual: m.esVirtual,
                        radio: 16),
                    title: Text(m.nombre),
                    dense: true,
                    onChanged: (sel) => setState(() {
                      if (sel == true) {
                        _entre.add(m.id);
                      } else {
                        _entre.remove(m.id);
                      }
                    }),
                  ),
              ],
            ),
          ),
        ],
      );
    }

    // Cantidades o porcentajes: campo por miembro + indicador de suma.
    final esPct = _modo == ModoReparto.porcentajes;
    final ctrls = esPct ? _porcentajeCtrls : _cantidadCtrls;
    final objetivo = esPct ? 100.0 : _monto;
    final suma = ctrls.values.fold(0.0, (s, c) => s + _num(c));
    final cuadra = (suma - objetivo).abs() <= (esPct ? 0.1 : 0.01);

    return Column(
      children: [
        Card(
          child: Column(
            children: [
              for (final m in miembros)
                ListTile(
                  dense: true,
                  leading: MemberAvatar(
                      nombre: m.nombre,
                      seed: m.id,
                      esVirtual: m.esVirtual,
                      radio: 16),
                  title: Text(m.nombre),
                  trailing: SizedBox(
                    width: 90,
                    child: TextField(
                      controller: ctrls[m.id],
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      textAlign: TextAlign.right,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        isDense: true,
                        prefixText: esPct ? null : '\$',
                        suffixText: esPct ? '%' : null,
                        hintText: '0',
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(esPct ? 'Suma de %' : 'Asignado',
                style: Theme.of(context).textTheme.bodySmall),
            Text(
              esPct
                  ? '${suma.toStringAsFixed(1)} / 100%'
                  : '\$${suma.toStringAsFixed(2)} / \$${_monto.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: cuadra ? const Color(0xFF2A9D5C) : cs.error,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
