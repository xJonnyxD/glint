import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Si los importes se muestran o se tapan con puntos.
///
/// Es una preferencia de privacidad que el propio usuario controla —para no
/// enseñar su saldo a quien pase por al lado—, no un permiso ni algo que dependa
/// de su rol.
///
/// Se guarda **por usuario**: en un móvil compartido, que uno tape su saldo no
/// debe tapárselo al otro. Y sobrevive a cerrar la app.
class PrivacidadSaldo extends ValueNotifier<bool> {
  PrivacidadSaldo._() : super(false);

  static final PrivacidadSaldo instancia = PrivacidadSaldo._();

  static const _prefijo = 'glint_ocultar_saldo_';
  String? _usuarioId;

  /// Carga la preferencia del usuario al iniciar sesión.
  Future<void> cargarPara(String usuarioId) async {
    _usuarioId = usuarioId;
    final prefs = await SharedPreferences.getInstance();
    value = prefs.getBool('$_prefijo$usuarioId') ?? false;
  }

  Future<void> alternar() async {
    value = !value;
    final id = _usuarioId;
    if (id == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_prefijo$id', value);
  }

  /// Devuelve el importe ya formateado, o los puntos si está oculto.
  ///
  /// Se usa en TODOS los importes de la tarjeta, no solo en el total: tapar el
  /// balance y dejar ingresos y gastos a la vista no ocultaría nada.
  String formatear(String textoVisible) => value ? '••••••' : textoVisible;
}
