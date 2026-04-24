import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Widget que muestra una animación de confeti sobre su hijo.
/// Usa flutter_animate para simular partículas cayendo desde arriba.
///
/// Uso:
/// ```dart
/// ConfettiOverlay(
///   mostrar: _celebrando,
///   child: MiWidget(),
/// )
/// ```
class ConfettiOverlay extends StatelessWidget {
  final Widget child;
  final bool mostrar;

  const ConfettiOverlay({
    super.key,
    required this.child,
    this.mostrar = false,
  });

  @override
  Widget build(BuildContext context) {
    final colores = [
      Colors.purple,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.pink,
      Colors.yellow,
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        child,
        if (mostrar)
          ...List.generate(20, (i) {
            final color = colores[i % colores.length];
            final left = (i * 5.3) % 100; // posición horizontal en %
            final delay = i * 80; // ms de delay escalonado

            return Positioned(
              left: screenWidth * left / 100,
              top: -20,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(i % 2 == 0 ? 5 : 2),
                ),
              )
                  .animate(onComplete: (c) => c.repeat())
                  .moveY(
                    begin: 0,
                    end: screenHeight + 20,
                    duration: Duration(milliseconds: 1500 + (i * 50)),
                    delay: Duration(milliseconds: delay),
                    curve: Curves.easeIn,
                  )
                  .rotate(
                    begin: 0,
                    end: 2,
                    duration: Duration(milliseconds: 1500 + (i * 50)),
                  ),
            );
          }),
      ],
    );
  }
}
