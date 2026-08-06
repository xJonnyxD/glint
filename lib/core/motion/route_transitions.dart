import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Transición de ruta estándar de Glint: fundido + escala sutil (300ms).
/// Da sensación de calidad sin marear. Se usa en las rutas de GoRouter con
/// `pageBuilder: (c, s) => fadeScalePage(s, const MiPantalla())`.
Page<T> fadeScalePage<T>(GoRouterState state, Widget child) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curva = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curva,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.98, end: 1.0).animate(curva),
          child: child,
        ),
      );
    },
  );
}
