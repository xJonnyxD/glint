import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Avisa al servidor de que la sesión sigue viva, para que el panel de
/// administración pueda mostrar quién está en línea.
///
/// Llama a la función `registrar_actividad` de PostgREST, que solo puede
/// tocar la fila del propio usuario: el id sale del JWT, no de un parámetro.
class PresenceService {
  /// Cada cuánto se manda el latido. El panel considera "en línea" a quien
  /// tenga actividad en los últimos 5 minutos, así que 2 minutos deja margen
  /// de sobra para un latido perdido sin que el usuario parezca desconectado.
  static const Duration _intervalo = Duration(minutes: 2);

  static Timer? _timer;
  static SupabaseClient? _cliente;

  static String get _plataforma {
    if (kIsWeb) return 'web';
    try {
      if (Platform.isAndroid) return 'android';
      if (Platform.isIOS) return 'ios';
      if (Platform.isWindows) return 'windows';
      if (Platform.isMacOS) return 'macos';
      if (Platform.isLinux) return 'linux';
    } catch (_) {
      // Platform no está disponible en algunos entornos de test
    }
    return 'desconocido';
  }

  /// Arranca los latidos. Es seguro llamarla varias veces.
  static void iniciar(SupabaseClient cliente) {
    _cliente = cliente;
    _timer?.cancel();
    _latir();
    _timer = Timer.periodic(_intervalo, (_) => _latir());
  }

  /// Detiene los latidos (al cerrar sesión).
  static void detener() {
    _timer?.cancel();
    _timer = null;
    _cliente = null;
  }

  static Future<void> _latir() async {
    final cliente = _cliente;
    if (cliente == null || cliente.auth.currentSession == null) return;
    try {
      await cliente.rpc<void>(
        'registrar_actividad',
        params: {'p_plataforma': _plataforma},
      );
    } catch (e) {
      // La presencia es información accesoria: si falla, la app sigue igual.
      debugPrint('Glint: no se pudo registrar la actividad — $e');
    }
  }
}
