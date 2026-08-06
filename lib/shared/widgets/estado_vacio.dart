import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Estado vacío premium: un icono dentro de un círculo con gradiente de marca,
/// título y subtítulo, con una entrada animada. Reemplaza a los emojis grandes
/// y da un vacío que se siente cuidado (una alternativa sin dependencias a Lottie;
/// si más adelante se añaden animaciones .json, se puede intercambiar aquí).
class EstadoVacio extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String? subtitulo;
  final Widget? accion;

  const EstadoVacio({
    super.key,
    required this.icono,
    required this.titulo,
    this.subtitulo,
    this.accion,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    cs.primary.withValues(alpha: 0.18),
                    cs.tertiary.withValues(alpha: 0.14),
                  ],
                ),
              ),
              child: Icon(icono, size: 48, color: cs.primary),
            )
                .animate()
                .fadeIn(duration: 400.ms)
                .scale(begin: const Offset(0.7, 0.7), curve: Curves.easeOutBack),
            const SizedBox(height: 20),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.3),
            if (subtitulo != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitulo!,
                textAlign: TextAlign.center,
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ).animate().fadeIn(delay: 250.ms),
            ],
            if (accion != null) ...[
              const SizedBox(height: 24),
              accion!.animate().fadeIn(delay: 350.ms).slideY(begin: 0.3),
            ],
          ],
        ),
      ),
    );
  }
}
