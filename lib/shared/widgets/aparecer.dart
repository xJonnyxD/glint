import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Animación de entrada estándar de Glint: fundido + un leve deslizamiento
/// hacia arriba. Con [indice] se escalona la aparición de una lista (cada
/// elemento entra un poco después que el anterior), lo que da esa sensación de
/// "cascada" viva en vez de que todo aparezca de golpe.
///
/// Uso:
/// ```dart
/// Aparecer(indice: i, child: MiTarjeta())
/// ```
class Aparecer extends StatelessWidget {
  final Widget child;
  final int indice;
  final Duration duracion;
  final Duration pasoStagger;
  final double desplazamiento;

  const Aparecer({
    super.key,
    required this.child,
    this.indice = 0,
    this.duracion = const Duration(milliseconds: 300),
    this.pasoStagger = const Duration(milliseconds: 45),
    this.desplazamiento = 0.14,
  });

  @override
  Widget build(BuildContext context) {
    // Tope al escalonado para que listas largas no tarden una eternidad en
    // terminar de aparecer.
    final delay = pasoStagger * (indice.clamp(0, 12));
    return child
        .animate()
        .fadeIn(duration: duracion, delay: delay)
        .slideY(begin: desplazamiento, curve: Curves.easeOutCubic);
  }
}

/// Azúcar sintáctico para envolver cualquier widget con la [Aparecer] estándar.
extension AparecerX on Widget {
  Widget aparecer({int indice = 0}) => Aparecer(indice: indice, child: this);
}
