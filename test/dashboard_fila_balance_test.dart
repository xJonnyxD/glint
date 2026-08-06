import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glint/core/icons/app_icons.dart';
import 'package:glint/core/theme/app_theme.dart';

/// La fila del título de la tarjeta "Balance del mes" del dashboard.
///
/// Réplica de la estructura real, con los mismos paddings, para poder medirla
/// a distintos anchos sin montar el dashboard entero (que exige media docena
/// de cubits).
///
/// **Por qué existe este test**: la fila se escribió con un `Spacer` entre el
/// título y los botones y se pasaba del ancho en CUALQUIER móvil. La tarjeta
/// recorta lo que sobresale (`clipBehavior: Clip.antiAlias` en el tema), así
/// que el botón del ojo desaparecía de la vista pero seguía respondiendo al
/// tacto: parecía "invisible pero funcionando", y no había franja amarilla de
/// desbordamiento que lo delatara porque el recorte se la comía. Con `Expanded`
/// es el título el que cede espacio.
Widget _filaTitulo(BuildContext context, ColorScheme cs) => Row(
      children: [
        Icon(Icons.account_balance_wallet, color: cs.primary, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Balance del mes',
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(AppIcons.visible, size: 20),
          color: cs.onSurfaceVariant,
          visualDensity: VisualDensity.compact,
          tooltip: 'Ocultar importes',
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text('Ver más'),
        ),
      ],
    );

void main() {
  group('la fila del balance cabe y el ojo queda a la vista', () {
    // Anchos de móvil habituales, y el aumento de letra del sistema.
    for (final ancho in [320.0, 360.0, 412.0]) {
      for (final escala in [1.0, 1.3]) {
        testWidgets('$ancho dp con texto x$escala', (tester) async {
          tester.view.physicalSize = Size(ancho, 800);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(tester.view.reset);

          await tester.pumpWidget(MaterialApp(
            theme: AppTheme.buildLight(const Color(0xFF705BFF)),
            home: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(escala)),
              child: Scaffold(
                body: Padding(
                  // 16 de margen de pantalla + 16 de relleno de la tarjeta
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Builder(
                    builder: (c) => _filaTitulo(c, Theme.of(c).colorScheme),
                  ),
                ),
              ),
            ),
          ));

          expect(tester.takeException(), isNull,
              reason: 'la fila se desborda a $ancho dp con texto x$escala, '
                  'así que el ojo se recorta y deja de verse');
          expect(find.byIcon(AppIcons.visible), findsOneWidget);
        });
      }
    }
  });

  testWidgets('el icono del ojo contrasta sobre la tarjeta', (tester) async {
    late ColorScheme cs;
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.buildLight(const Color(0xFF705BFF)),
      home: Builder(builder: (context) {
        cs = Theme.of(context).colorScheme;
        return const SizedBox.shrink();
      }),
    ));

    // Iconos que transmiten información: 3:1 según WCAG 1.4.11.
    final razon = _contraste(cs.onSurfaceVariant, cs.surfaceContainerHighest);
    expect(razon, greaterThanOrEqualTo(3.0),
        reason: 'el ojo quedaría difuso sobre el fondo de la tarjeta');
  });
}

double _contraste(Color a, Color b) {
  double lum(Color c) {
    double canal(double v) => v <= 0.03928
        ? v / 12.92
        : _pow((v + 0.055) / 1.055, 2.4);
    return 0.2126 * canal(c.r) + 0.7152 * canal(c.g) + 0.0722 * canal(c.b);
  }

  final la = lum(a), lb = lum(b);
  final alto = la > lb ? la : lb;
  final bajo = la > lb ? lb : la;
  return (alto + 0.05) / (bajo + 0.05);
}

/// x elevado a y, sin arrastrar `dart:math` a un archivo de test de widgets.
double _pow(double x, double y) {
  var resultado = 1.0;
  var base = x;
  var exp = y;
  // parte entera
  while (exp >= 1) {
    resultado *= base;
    exp -= 1;
  }
  // parte fraccionaria, por bisección de raíces cuadradas
  var raiz = base;
  var paso = 0.5;
  for (var i = 0; i < 24; i++) {
    raiz = _raiz(raiz);
    if (exp >= paso) {
      resultado *= raiz;
      exp -= paso;
    }
    paso /= 2;
  }
  return resultado;
}

double _raiz(double v) {
  var r = v;
  for (var i = 0; i < 30; i++) {
    r = 0.5 * (r + v / r);
  }
  return r;
}
