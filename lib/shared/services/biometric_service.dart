import 'package:flutter/services.dart' show PlatformException;
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:shared_preferences/shared_preferences.dart';

/// En qué acabó un intento de desbloqueo.
///
/// Antes esto era un simple `bool`: cualquier fallo devolvía `false` y no había
/// forma de distinguir "el usuario canceló" de "este móvil no tiene huella
/// configurada". El usuario se quedaba mirando una pantalla bloqueada sin
/// saber qué hacer.
enum ResultadoBiometrico {
  exito,

  /// El usuario canceló el diálogo (o pulsó atrás).
  cancelado,

  /// El dispositivo no tiene lector, o el sistema no lo soporta.
  noDisponible,

  /// Hay lector, pero no hay ninguna huella/rostro dado de alta, ni PIN.
  noConfigurada,

  /// Demasiados intentos fallidos: el sistema bloqueó la biometría un rato.
  bloqueadaTemporalmente,

  /// Bloqueada hasta que el usuario desbloquee con PIN/patrón.
  bloqueadaPermanente,

  /// Cualquier otro fallo.
  error;

  /// Mensaje para enseñar al usuario. `null` cuando no hay nada que decir
  /// (éxito, o cancelación, que ya sabe que hizo él).
  String? get mensaje => switch (this) {
        ResultadoBiometrico.exito => null,
        ResultadoBiometrico.cancelado => null,
        ResultadoBiometrico.noDisponible =>
          'Este dispositivo no admite desbloqueo biométrico.',
        ResultadoBiometrico.noConfigurada =>
          'No tienes huella ni bloqueo de pantalla configurados. '
              'Configúralos en los ajustes del teléfono para usar esta opción.',
        ResultadoBiometrico.bloqueadaTemporalmente =>
          'Demasiados intentos. Espera unos segundos y vuelve a probar.',
        ResultadoBiometrico.bloqueadaPermanente =>
          'La biometría está bloqueada. Desbloquea el teléfono con tu PIN o '
              'patrón y vuelve a intentarlo.',
        ResultadoBiometrico.error =>
          'No se pudo verificar tu identidad. Inténtalo de nuevo.',
      };

  /// Si el desbloqueo no puede funcionar en este dispositivo, no tiene sentido
  /// dejar al usuario fuera: se le deja pasar y se le explica.
  bool get debePermitirEntrar =>
      this == ResultadoBiometrico.exito ||
      this == ResultadoBiometrico.noDisponible ||
      this == ResultadoBiometrico.noConfigurada;
}

class BiometricService {
  static final _auth = LocalAuthentication();
  static const _kBiometricEnabled = 'glint_biometric_enabled';

  /// El dispositivo puede pedir huella, rostro o, en su defecto, PIN/patrón.
  static Future<bool> isAvailable() async {
    try {
      // isDeviceSupported() incluye el PIN/patrón como método válido;
      // canCheckBiometrics mira solo huella/rostro. Basta con el primero,
      // porque autenticamos con `biometricOnly: false`.
      return await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  /// Hay al menos una huella o rostro dado de alta.
  static Future<bool> hayBiometriaRegistrada() async {
    try {
      final tipos = await _auth.getAvailableBiometrics();
      return tipos.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Si el usuario activó el desbloqueo en los ajustes de Glint.
  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kBiometricEnabled) ?? false;
  }

  static Future<void> setEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kBiometricEnabled, value);
  }

  /// Pide el desbloqueo y cuenta qué pasó.
  ///
  /// `biometricOnly: false` es deliberado: si la huella falla o el móvil no
  /// tiene lector, el sistema ofrece el PIN o el patrón. Así nunca se queda
  /// nadie fuera de sus propios datos.
  static Future<ResultadoBiometrico> autenticar({
    String motivo = 'Desbloquea Glint para continuar',
  }) async {
    try {
      final ok = await _auth.authenticate(
        localizedReason: motivo,
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true, // sobrevive a que la app pase a segundo plano
          useErrorDialogs: true,
        ),
      );
      return ok ? ResultadoBiometrico.exito : ResultadoBiometrico.cancelado;
    } on PlatformException catch (e) {
      return switch (e.code) {
        auth_error.notAvailable => ResultadoBiometrico.noDisponible,
        auth_error.notEnrolled => ResultadoBiometrico.noConfigurada,
        auth_error.passcodeNotSet => ResultadoBiometrico.noConfigurada,
        auth_error.lockedOut => ResultadoBiometrico.bloqueadaTemporalmente,
        auth_error.permanentlyLockedOut =>
          ResultadoBiometrico.bloqueadaPermanente,
        // Con FlutterActivity en vez de FlutterFragmentActivity el plugin
        // devolvía esto siempre; se corrigió en MainActivity.kt.
        'no_fragment_activity' => ResultadoBiometrico.noDisponible,
        _ => ResultadoBiometrico.error,
      };
    } catch (_) {
      return ResultadoBiometrico.error;
    }
  }

  /// Compatibilidad con el código que solo quiere saber si entró o no.
  static Future<bool> authenticate() async =>
      (await autenticar()) == ResultadoBiometrico.exito;
}
