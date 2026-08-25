import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Retroalimentación háptica centralizada de Glint.
///
/// Un único punto para toda la vibración de la app, con tres razones de ser:
///  - **Web-safe**: en el navegador no hay motor de vibración, así que todo es
///    no-op (como ya hace `NotificationService`).
///  - **Configurable**: el usuario puede apagarla desde Ajustes; la preferencia
///    se cachea en memoria ([_activada]) para no leer `SharedPreferences` en
///    cada toque, que ocurre muchas veces por segundo.
///  - **Semántica**: el resto del código pide `Haptica.exito()`, no
///    `HapticFeedback.mediumImpact()`, así el "qué se siente" se decide aquí y
///    se puede reajustar en un solo sitio.
abstract class Haptica {
  /// Clave de la preferencia (compartida con el switch de Ajustes).
  static const String kPref = 'glint_haptica';

  /// Copia en memoria de la preferencia. Por defecto activada; en web se apaga
  /// en [cargar]. Se mantiene al día desde [definir].
  static bool _activada = true;

  /// `true` si la háptica está activada (y no estamos en web).
  static bool get activada => _activada && !kIsWeb;

  /// Lee la preferencia guardada. Llamar una vez en el arranque, antes de
  /// runApp, junto al resto de la inicialización.
  static Future<void> cargar() async {
    if (kIsWeb) {
      _activada = false;
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    _activada = prefs.getBool(kPref) ?? true;
  }

  /// Activa o desactiva la háptica y lo persiste. Lo llama el switch de Ajustes.
  static Future<void> definir(bool valor) async {
    _activada = valor;
    if (kIsWeb) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kPref, valor);
  }

  static void _si(void Function() efecto) {
    if (!activada) return;
    efecto();
  }

  /// Algo salió bien y es un hito: hábito completado, subida de nivel, meta
  /// alcanzada. Un golpe medio, perceptible sin ser molesto.
  static void exito() => _si(HapticFeedback.mediumImpact);

  /// Cambio de selección: pestaña de la barra, opción de una lista, toggle.
  /// Es el más sutil.
  static void seleccion() => _si(HapticFeedback.selectionClick);

  /// Confirmación ligera de una acción normal (marcar, pulsar un botón).
  static void impactoLigero() => _si(HapticFeedback.lightImpact);

  /// Algo falló o se canceló: un golpe fuerte para que se note el tropiezo.
  static void error() => _si(HapticFeedback.heavyImpact);
}
