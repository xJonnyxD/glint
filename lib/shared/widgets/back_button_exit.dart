import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Widget que implementa comportamiento de "double-tap para salir"
/// - 1er tap: muestra mensaje "Presiona atrás de nuevo para salir"
/// - 2do tap dentro de 2 segundos: sale de la app
/// - Después de 2 segundos sin input: reinicia contador
class BackButtonExit extends StatefulWidget {
  final Widget child;

  const BackButtonExit({super.key, required this.child});

  @override
  State<BackButtonExit> createState() => _BackButtonExitState();
}

class _BackButtonExitState extends State<BackButtonExit> {
  DateTime? _lastPopTime;

  @override
  void dispose() {
    _lastPopTime = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (!mounted) return;

        final now = DateTime.now();

        // Si hace menos de 2 segundos que presionó atrás → salir de la app
        if (_lastPopTime != null &&
            now.difference(_lastPopTime!) < const Duration(seconds: 2)) {
          SystemNavigator.pop(); // cierra la app correctamente en Android
          return;
        }

        // Si es la primera vez o pasaron más de 2 segundos → mostrar mensaje
        _lastPopTime = now;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Presiona atrás de nuevo para salir'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: widget.child,
    );
  }
}
