import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:glint/features/groups/domain/balance_entity.dart';

/// Visualización de saldos tipo "burbujas": cada miembro es un círculo cuyo
/// tamaño crece con lo que debe o le deben, verde si le deben y rojo si debe.
/// Es la vista que hace que el estado del grupo se entienda de un vistazo
/// (inspirada en el "quién debe pagar" de las apps de gastos compartidos).
class BalanceBubbles extends StatelessWidget {
  final List<BalanceEntity> balances;
  final NumberFormat fmt;

  const BalanceBubbles({super.key, required this.balances, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    // Ordenar de "más le deben" a "más debe" para una lectura natural.
    final ordenados = [...balances]..sort((a, b) => b.balance.compareTo(a.balance));
    final maxAbs = ordenados.fold<double>(
        0.01, (m, b) => b.balance.abs() > m ? b.balance.abs() : m);

    const minD = 64.0;
    const maxD = 116.0;

    if (ordenados.every((b) => b.enPaz)) {
      return _todosEnPaz(context);
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 14,
      runSpacing: 14,
      children: [
        for (var i = 0; i < ordenados.length; i++)
          _burbuja(context, ordenados[i], maxAbs, minD, maxD, cs)
              .animate()
              .fadeIn(duration: 300.ms, delay: (i * 70).ms)
              .scale(begin: const Offset(0.6, 0.6), curve: Curves.easeOutBack),
      ],
    );
  }

  Widget _burbuja(BuildContext context, BalanceEntity b, double maxAbs,
      double minD, double maxD, ColorScheme cs) {
    final t = (b.balance.abs() / maxAbs).clamp(0.0, 1.0);
    final d = b.enPaz ? minD : (minD + (maxD - minD) * t);
    final (color, etiqueta) = b.leDeben
        ? (const Color(0xFF2A9D5C), 'le deben')
        : b.debe
            ? (cs.error, 'debe')
            : (cs.onSurface.withAlpha(120), 'en paz');

    return SizedBox(
      width: d,
      height: d,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color.withAlpha(48), color.withAlpha(28)],
          ),
          border: Border.all(color: color.withAlpha(150), width: 2),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              b.nombre,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              b.enPaz ? '—' : fmt.format(b.balance.abs()),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              etiqueta,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: color, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _todosEnPaz(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Icon(Symbols.celebration_rounded,
              size: 40, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 6),
          Text('Todos en paz',
              style: Theme.of(context).textTheme.titleMedium),
        ],
      ).animate().fadeIn(duration: 400.ms),
    );
  }
}
