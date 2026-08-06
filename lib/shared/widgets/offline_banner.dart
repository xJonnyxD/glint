import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

/// Widget que envuelve a su [child] y muestra un banner rojo
/// en la parte superior cuando no hay conexión a internet.
///
/// Uso:
/// ```dart
/// OfflineBanner(child: MiWidget())
/// ```
class OfflineBanner extends StatefulWidget {
  final Widget child;
  const OfflineBanner({super.key, required this.child});

  @override
  State<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends State<OfflineBanner>
    with SingleTickerProviderStateMixin {
  late StreamSubscription<List<ConnectivityResult>> _sub;
  bool _sinConexion = false;
  late AnimationController _animCtrl;
  late Animation<double> _slideAnim;

  @override
  void initState() {
    super.initState();

    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnim = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut),
    );

    // Verificar estado inicial
    Connectivity().checkConnectivity().then(_actualizarEstado);

    // Escuchar cambios de conectividad en tiempo real
    _sub = Connectivity().onConnectivityChanged.listen(_actualizarEstado);
  }

  void _actualizarEstado(List<ConnectivityResult> results) {
    final offline = results.isEmpty ||
        results.every((r) => r == ConnectivityResult.none);
    if (offline != _sinConexion) {
      setState(() => _sinConexion = offline);
      if (offline) {
        _animCtrl.forward();
      } else {
        _animCtrl.reverse();
      }
    }
  }

  @override
  void dispose() {
    _sub.cancel();
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Banner deslizante de sin conexión
        AnimatedBuilder(
          animation: _slideAnim,
          builder: (context, child) => ClipRect(
            child: Align(
              heightFactor: _animCtrl.value,
              child: child,
            ),
          ),
          child: Material(
            color: Colors.red.shade700,
            elevation: 4,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.wifi_off_rounded,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Sin conexión a internet — los datos se guardan localmente',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Contenido principal
        Expanded(child: widget.child),
      ],
    );
  }
}
