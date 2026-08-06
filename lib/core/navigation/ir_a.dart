import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'package:glint/core/constants/app_constants.dart';

/// Navegación que respeta el botón "atrás".
///
/// En go_router, `go` **reemplaza** la pila de pantallas y `push` **apila**.
/// Usar `go` para abrir una pantalla que no es una pestaña deja la pila vacía,
/// y entonces "atrás" no tiene a dónde volver: la app se cierra. Era lo que
/// pasaba, por ejemplo, al entrar desde el panel de inicio a "Gastos
/// compartidos" o a la calculadora.
///
/// [irA] elige solo: `go` si el destino es una de las pestañas de la barra
/// (cambiar de sección no debe apilar), `push` en cualquier otro caso.
///
/// Para casos concretos siguen estando `context.go` y `context.push`; esto es
/// para cuando la ruta es una variable y no se sabe de antemano cuál es.
extension NavegacionGlint on BuildContext {
  void irA(String ruta, {Object? extra}) {
    if (AppRoutes.esPestana(ruta)) {
      go(ruta, extra: extra);
    } else {
      push(ruta, extra: extra);
    }
  }
}
