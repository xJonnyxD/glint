import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:glint/core/feedback/haptica.dart';
import 'package:glint/core/theme/app_colors.dart';

/// Celebración global: una ráfaga de partículas de colores Aurora que cae sobre
/// toda la pantalla, para los hitos que se deben sentir (subir de nivel,
/// completar el último hábito del día, alcanzar una meta).
///
/// Se dispara desde cualquier sitio —incluso sin `BuildContext`, como un
/// cubit— con [lanzar]; el [CelebracionHost] que envuelve la app la pinta. Es
/// deliberadamente sin dependencias (nada de Lottie, que se quitó por tamaño),
/// igual que `estado_vacio.dart`.
abstract class Celebracion {
  /// Cada incremento dispara una ráfaga. El host lo escucha.
  static final ValueNotifier<int> senal = ValueNotifier<int>(0);

  /// Color dominante de la última ráfaga (null = mezcla Aurora completa).
  static Color? colorSugerido;

  /// Lanza una celebración. [color] tiñe las partículas hacia ese tono (por
  /// ejemplo el color del dominio); si es null, usa toda la paleta Aurora.
  /// Dispara también la háptica de éxito.
  static void lanzar({Color? color}) {
    colorSugerido = color;
    Haptica.exito();
    senal.value++;
  }
}

/// Envuelve la app (desde el `builder` de MaterialApp) y pinta las ráfagas por
/// encima del contenido, sin capturar toques.
class CelebracionHost extends StatefulWidget {
  final Widget child;
  const CelebracionHost({super.key, required this.child});

  @override
  State<CelebracionHost> createState() => _CelebracionHostState();
}

class _CelebracionHostState extends State<CelebracionHost>
    with SingleTickerProviderStateMixin {
  late final AnimationController _control = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );
  List<_Particula> _particulas = const [];

  @override
  void initState() {
    super.initState();
    Celebracion.senal.addListener(_alLanzar);
  }

  @override
  void dispose() {
    Celebracion.senal.removeListener(_alLanzar);
    _control.dispose();
    super.dispose();
  }

  void _alLanzar() {
    // Reduce-motion: quien pidió menos animación no quiere confeti en la cara.
    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) return;
    _particulas = _generarParticulas(Celebracion.colorSugerido);
    _control.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _control,
              builder: (context, _) {
                if (!_control.isAnimating) return const SizedBox.shrink();
                return CustomPaint(
                  painter: _CelebracionPainter(_particulas, _control.value),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// Una chispa de la ráfaga. Posiciones y velocidades son relativas (0..1) para
/// no depender del tamaño de pantalla hasta pintarlas.
class _Particula {
  final double x; // origen horizontal 0..1
  final double anguloRad; // dirección inicial
  final double velocidad; // magnitud del impulso
  final double giro; // rotación por unidad de tiempo
  final double tam; // lado del rombo en px
  final Color color;

  const _Particula({
    required this.x,
    required this.anguloRad,
    required this.velocidad,
    required this.giro,
    required this.tam,
    required this.color,
  });
}

const List<Color> _paletaAurora = [
  AppColors.auroraLavanda,
  AppColors.auroraRosa,
  AppColors.auroraAzulHielo,
  AppColors.auroraMorado,
  AppColors.auroraDorado,
];

List<_Particula> _generarParticulas(Color? color) {
  final rnd = math.Random();
  final colores = color == null
      ? _paletaAurora
      : [color, color, Color.lerp(color, Colors.white, 0.4)!, ..._paletaAurora];
  return List.generate(34, (_) {
    // Salen desde la franja superior, disparadas hacia abajo en abanico.
    final angulo = (math.pi / 2) + (rnd.nextDouble() - 0.5) * 1.4;
    return _Particula(
      x: rnd.nextDouble(),
      anguloRad: angulo,
      velocidad: 0.5 + rnd.nextDouble() * 0.9,
      giro: (rnd.nextDouble() - 0.5) * 12,
      tam: 7 + rnd.nextDouble() * 8,
      color: colores[rnd.nextInt(colores.length)],
    );
  });
}

class _CelebracionPainter extends CustomPainter {
  final List<_Particula> particulas;
  final double t; // 0..1

  _CelebracionPainter(this.particulas, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final gravedad = size.height * 0.9;
    // Se desvanecen en el último tercio.
    final opacidad = (1.0 - ((t - 0.66) / 0.34)).clamp(0.0, 1.0);
    final pintura = Paint();

    for (final p in particulas) {
      final dx = math.cos(p.anguloRad) * p.velocidad * size.width * 0.5 * t;
      final dy = math.sin(p.anguloRad) * p.velocidad * size.height * 0.4 * t +
          gravedad * t * t * 0.5;
      final cx = p.x * size.width + dx;
      final cy = -20.0 + dy;

      pintura.color = p.color.withValues(alpha: opacidad);
      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(p.giro * t);
      // Un rombo simple: liviano de pintar y se lee como confeti.
      final r = p.tam / 2;
      final camino = Path()
        ..moveTo(0, -r)
        ..lineTo(r * 0.7, 0)
        ..lineTo(0, r)
        ..lineTo(-r * 0.7, 0)
        ..close();
      canvas.drawPath(camino, pintura);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_CelebracionPainter old) => old.t != t;
}
