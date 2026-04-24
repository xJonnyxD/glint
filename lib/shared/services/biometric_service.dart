import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricService {
  static final _auth = LocalAuthentication();
  static const _kBiometricEnabled = 'glint_biometric_enabled';

  /// Verifica si el dispositivo soporta biometría
  static Future<bool> isAvailable() async {
    try {
      final capable = await _auth.isDeviceSupported();
      final enrolled = await _auth.canCheckBiometrics;
      return capable && enrolled;
    } catch (e) {
      return false;
    }
  }

  /// Verifica si el usuario activó biometría en ajustes
  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kBiometricEnabled) ?? false;
  }

  /// Activa o desactiva la biometría
  static Future<void> setEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kBiometricEnabled, value);
  }

  /// Muestra el prompt biométrico — retorna true si autenticó correctamente
  static Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Usa tu huella o Face ID para entrar a Glint',
        options: const AuthenticationOptions(
          biometricOnly: false, // permite PIN como fallback
          stickyAuth: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}
