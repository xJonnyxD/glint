import 'package:flutter/material.dart';

/// Hace que la app se vea bien en pantallas anchas (PC y tablet).
///
/// Las pantallas de Glint están pensadas para teléfono; en una ventana ancha
/// se estirarían y las tarjetas quedarían enormes. En su lugar, centramos la
/// app en una columna de ancho cómodo sobre un fondo neutro, como hacen muchas
/// apps móviles servidas en web.
///
/// Clave: además de limitar el ancho, sobrescribimos el `MediaQuery` para que
/// las pantallas de dentro crean que la pantalla mide [_anchoApp]. Si no, un
/// grid que calcula columnas según el ancho de ventana se desbordaría dentro
/// de la columna estrecha.
class AppResponsiva extends StatelessWidget {
  final Widget child;
  const AppResponsiva({super.key, required this.child});

  /// A partir de aquí se enmarca (teléfonos en vertical quedan por debajo).
  static const double _puntoDeCorte = 600;

  /// Ancho del marco de la app según el ancho de la ventana. En escritorio se
  /// da bastante espacio (hasta 1100) para que el shell adaptativo pueda mostrar
  /// el NavigationRail lateral; en tablet un marco intermedio.
  static double _anchoMarco(double anchoVentana) {
    if (anchoVentana >= 1200) return 1100;
    return (anchoVentana * 0.94).clamp(0.0, 900.0);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    if (mq.size.width <= _puntoDeCorte) return child; // teléfono: completa

    final theme = Theme.of(context);
    final oscuro = theme.brightness == Brightness.dark;
    final fondo = oscuro ? const Color(0xFF0A0E1A) : const Color(0xFFDCE2EA);
    final ancho = _anchoMarco(mq.size.width);

    return ColoredBox(
      color: fondo,
      child: Center(
        child: Container(
          width: ancho,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            border: Border.symmetric(
              vertical: BorderSide(color: theme.dividerColor, width: 0.5),
            ),
          ),
          // Override del MediaQuery al ancho del marco: así las grillas que
          // calculan columnas por ancho lo hacen contra el marco (no la ventana)
          // y no se desbordan.
          child: MediaQuery(
            data: mq.copyWith(size: Size(ancho, mq.size.height)),
            child: child,
          ),
        ),
      ),
    );
  }
}
