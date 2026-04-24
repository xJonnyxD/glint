import 'package:shared_preferences/shared_preferences.dart';

/// Servicio de persistencia local para los datos de perfil del usuario.
///
/// Todos los métodos son estáticos para facilitar su uso sin necesidad
/// de instanciar la clase.
abstract class ProfileSettings {
  // ── Claves ─────────────────────────────────────────────────────────────────
  static const _kFoto   = 'glint_perfil_foto';
  static const _kEstado = 'glint_perfil_estado';
  static const _kNombre = 'glint_perfil_nombre';

  // ── Foto de perfil ─────────────────────────────────────────────────────────

  /// Devuelve la ruta local guardada de la foto de perfil, o `null` si no hay.
  static Future<String?> getFoto() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kFoto);
  }

  /// Guarda la ruta local de la foto de perfil.
  static Future<void> setFoto(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kFoto, path);
  }

  // ── Estado / frase ─────────────────────────────────────────────────────────

  /// Devuelve el estado del usuario.
  /// Valor por defecto: `'✨ Viviendo al máximo'`.
  static Future<String> getEstado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kEstado) ?? '✨ Viviendo al máximo';
  }

  /// Guarda el estado del usuario.
  static Future<void> setEstado(String estado) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kEstado, estado);
  }

  // ── Nombre local ───────────────────────────────────────────────────────────

  /// Devuelve el nombre guardado localmente, o `null` si no se ha guardado.
  static Future<String?> getNombreLocal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kNombre);
  }

  /// Guarda el nombre del usuario de forma local.
  static Future<void> setNombreLocal(String nombre) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kNombre, nombre);
  }
}
