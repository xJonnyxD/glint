import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class XpService {
  static const _keyXpTotal = 'glint_xp_total';
  static const _keyHistorial = 'glint_xp_historial';

  // ─── Niveles ───────────────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> _niveles = [
    {'nombre': 'Principiante', 'emoji': '🌱', 'minXP': 0,    'maxXP': 499},
    {'nombre': 'Explorador',   'emoji': '🔍', 'minXP': 500,  'maxXP': 1499},
    {'nombre': 'Constante',    'emoji': '⭐', 'minXP': 1500, 'maxXP': 3499},
    {'nombre': 'Dedicado',     'emoji': '🔥', 'minXP': 3500, 'maxXP': 7499},
    {'nombre': 'Elite',        'emoji': '👑', 'minXP': 7500, 'maxXP': 999999},
  ];

  // ─── Leer XP total ─────────────────────────────────────────────────────────
  static Future<int> getXP() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyXpTotal) ?? 0;
  }

  // ─── Agregar XP ─────────────────────────────────────────────────────────────
  static Future<void> agregarXP(int xp, {String motivo = ''}) async {
    final prefs = await SharedPreferences.getInstance();
    final actual = prefs.getInt(_keyXpTotal) ?? 0;
    await prefs.setInt(_keyXpTotal, actual + xp);

    // Guardar en historial (últimas 20 acciones)
    final historialRaw = prefs.getStringList(_keyHistorial) ?? [];
    final entrada = jsonEncode({
      'xp': xp,
      'motivo': motivo,
      'fecha': DateTime.now().toIso8601String(),
    });
    historialRaw.insert(0, entrada);
    if (historialRaw.length > 20) historialRaw.removeLast();
    await prefs.setStringList(_keyHistorial, historialRaw);
  }

  // ─── Info del nivel ────────────────────────────────────────────────────────
  static Map<String, dynamic> infoNivel(int xp) {
    for (final nivel in _niveles.reversed) {
      if (xp >= (nivel['minXP'] as int)) return nivel;
    }
    return _niveles.first;
  }

  static String getNombreNivel(int xp) => infoNivel(xp)['nombre'] as String;
  static String getEmojiNivel(int xp)  => infoNivel(xp)['emoji']  as String;

  /// XP necesario para llegar al siguiente nivel (0 si ya es Elite)
  static int xpParaSiguienteNivel(int xp) {
    for (int i = 0; i < _niveles.length - 1; i++) {
      if (xp <= (_niveles[i]['maxXP'] as int)) {
        return (_niveles[i]['maxXP'] as int) + 1 - xp;
      }
    }
    return 0; // ya es Elite
  }

  /// Progreso dentro del nivel actual (0.0 – 1.0)
  static double progresEnNivel(int xp) {
    final nivel = infoNivel(xp);
    final min = nivel['minXP'] as int;
    final max = nivel['maxXP'] as int;
    if (max >= 999999) return 1.0;
    return ((xp - min) / (max - min + 1)).clamp(0.0, 1.0);
  }

  // ─── Historial ─────────────────────────────────────────────────────────────
  static Future<List<Map<String, dynamic>>> getHistorial() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_keyHistorial) ?? [];
    return raw
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .toList();
  }
}
