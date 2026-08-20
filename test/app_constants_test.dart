import 'package:flutter_test/flutter_test.dart';
import 'package:glint/core/constants/app_constants.dart';

/// SEC-08: la app no debe llevar ningún backend embebido.
///
/// Hasta el 19 de agosto de 2026, `app_constants.dart` traía como valor por
/// defecto la URL y la clave anon de un proyecto Supabase alojado en la nube,
/// distinto del servidor de producción. Cualquier build que se olvidara de los
/// `--dart-define` hablaba con ese backend sin avisar.
///
/// Los tests se ejecutan sin `--dart-define`, así que aquí las dos constantes
/// tienen que estar vacías. Si alguien vuelve a poner un `defaultValue`, este
/// test lo caza.
void main() {
  test('no hay backend embebido en el código (SEC-08)', () {
    expect(AppConstants.supabaseUrl, isEmpty,
        reason: 'SUPABASE_URL debe venir de --dart-define, no del código');
    expect(AppConstants.supabaseAnonKey, isEmpty,
        reason: 'SUPABASE_ANON_KEY debe venir de --dart-define, no del código');
    expect(AppConstants.hayBackend, isFalse);
  });
}
