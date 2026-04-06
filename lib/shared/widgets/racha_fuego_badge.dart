import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Badge de racha en fuego — se muestra cuando la racha es >= 3 días.
/// >= 7 días: fuego 🔥, >= 3 días: rayo ⚡
class RachaFuegoBadge extends StatelessWidget {
  final int racha;
  final bool grande; // true = versión grande para detalle, false = chip pequeño

  const RachaFuegoBadge({super.key, required this.racha, this.grande = false});

  @override
  Widget build(BuildContext context) {
    if (racha < 3) return const SizedBox.shrink();

    final esFuego = racha >= 7;
    final color = esFuego ? Colors.deepOrange : Colors.amber;
    final emoji = esFuego ? '🔥' : '⚡';

    if (grande) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color.withAlpha(30),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withAlpha(100)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24))
                .animate(onComplete: (c) => c.repeat())
                .scaleXY(begin: 1.0, end: 1.2, duration: 600.ms)
                .then()
                .scaleXY(begin: 1.2, end: 1.0, duration: 600.ms),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$racha días seguidos',
                  style: TextStyle(
                      fontWeight: FontWeight.w800, color: color, fontSize: 16),
                ),
                Text(
                  esFuego ? '¡Estás en racha de fuego!' : '¡Sigue así!',
                  style: TextStyle(fontSize: 11, color: color.withAlpha(180)),
                ),
              ],
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(duration: 400.ms)
          .slideX(begin: -0.2);
    }

    // Versión chip pequeño
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(80), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 3),
          Text(
            '$racha',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    )
        .animate(onComplete: (c) => esFuego ? c.repeat() : null)
        .shimmer(duration: 1200.ms, color: color.withAlpha(60));
  }
}
