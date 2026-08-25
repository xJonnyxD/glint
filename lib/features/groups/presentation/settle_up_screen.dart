import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:glint/features/groups/domain/group_detail.dart';
import 'package:glint/features/groups/domain/settlement_entity.dart';
import 'group_detail_cubit.dart';

/// Muestra las transferencias sugeridas para dejar el grupo en paz y permite
/// registrar cada pago (que queda como una transferencia en el historial).
class SettleUpScreen extends StatelessWidget {
  final GroupDetail detalle;
  final NumberFormat fmt;
  const SettleUpScreen({super.key, required this.detalle, required this.fmt});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saldar deudas')),
      body: BlocBuilder<GroupDetailCubit, GroupDetailState>(
        builder: (context, state) {
          // Usar el detalle en vivo si está disponible; si no, el inicial.
          final d = state is GroupDetailLoaded ? state.detalle : detalle;
          final liquidaciones = d.liquidaciones;

          if (liquidaciones.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Symbols.celebration_rounded,
                      size: 56, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 12),
                  Text('¡Todos en paz!',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text('No hay deudas pendientes en el grupo.',
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'La forma más simple de saldar (${liquidaciones.length} ${liquidaciones.length == 1 ? 'pago' : 'pagos'}):',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              for (final s in liquidaciones)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _LiquidacionCard(s: s, fmt: fmt),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _LiquidacionCard extends StatelessWidget {
  final SettlementEntity s;
  final NumberFormat fmt;
  const _LiquidacionCard({required this.s, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(s.deNombre,
                          style: Theme.of(context).textTheme.titleMedium),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Symbols.arrow_forward_rounded, size: 18, color: cs.primary),
                      ),
                      Text(s.aNombre,
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(fmt.format(s.monto),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.bold,
                          )),
                ],
              ),
            ),
            FilledButton.tonal(
              onPressed: () => _registrar(context),
              child: const Text('Pagado'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registrar(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    await context.read<GroupDetailCubit>().registrarPago(s);
    messenger.showSnackBar(
      SnackBar(content: Text('Pago de ${s.deNombre} a ${s.aNombre} registrado')),
    );
  }
}
