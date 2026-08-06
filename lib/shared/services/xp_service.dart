import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Una entrada del ranking de amigos por XP.
class RankingEntry {
  final String id;
  final String nombre;
  final int xp;
  final bool esYo;
  const RankingEntry(
      {required this.id, required this.nombre, required this.xp, required this.esYo});
}

class XpService {
  static const _keyXpTotal = 'glint_xp_total';
  static const _keyHistorial = 'glint_xp_historial';

  /// Usuario activo. El XP se guarda por usuario para que varias cuentas
  /// en el mismo dispositivo no compartan progreso.
  static String? _usuarioActual;

  /// Llamar al iniciar/cerrar sesión (lo hace AuthCubit automáticamente).
  static void setUsuario(String? usuarioId) => _usuarioActual = usuarioId;

  static String get _keyXp   => '${_keyXpTotal}_$_usuarioActual';
  static String get _keyHist => '${_keyHistorial}_$_usuarioActual';

  /// Migra los datos legacy (globales, previos al XP por usuario) a la
  /// cuenta actual la primera vez que se accede con sesión iniciada.
  static Future<void> _migrarLegacy(SharedPreferences prefs) async {
    if (!prefs.containsKey(_keyXpTotal) || prefs.containsKey(_keyXp)) return;
    await prefs.setInt(_keyXp, prefs.getInt(_keyXpTotal) ?? 0);
    final hist = prefs.getStringList(_keyHistorial);
    if (hist != null) await prefs.setStringList(_keyHist, hist);
    await prefs.remove(_keyXpTotal);
    await prefs.remove(_keyHistorial);
  }

  // ─── Niveles ───────────────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> _niveles = [
    {'nombre': 'Principiante', 'icono': Symbols.eco_rounded,                 'minXP': 0,    'maxXP': 499},
    {'nombre': 'Explorador',   'icono': Symbols.explore_rounded,             'minXP': 500,  'maxXP': 1499},
    {'nombre': 'Constante',    'icono': Symbols.star_rounded,                'minXP': 1500, 'maxXP': 3499},
    {'nombre': 'Dedicado',     'icono': Symbols.local_fire_department_rounded,'minXP': 3500, 'maxXP': 7499},
    {'nombre': 'Elite',        'icono': Symbols.workspace_premium_rounded,   'minXP': 7500, 'maxXP': 999999},
  ];

  // ─── Leer XP total ─────────────────────────────────────────────────────────
  static Future<int> getXP() async {
    if (_usuarioActual == null) return 0;
    final prefs = await SharedPreferences.getInstance();
    await _migrarLegacy(prefs);
    return prefs.getInt(_keyXp) ?? 0;
  }

  // ─── Agregar XP ─────────────────────────────────────────────────────────────
  static Future<void> agregarXP(int xp, {String motivo = ''}) async {
    if (_usuarioActual == null) return;
    final prefs = await SharedPreferences.getInstance();
    await _migrarLegacy(prefs);
    final actual = prefs.getInt(_keyXp) ?? 0;
    await prefs.setInt(_keyXp, actual + xp);

    // Guardar en historial (últimas 20 acciones)
    final historialRaw = prefs.getStringList(_keyHist) ?? [];
    final entrada = jsonEncode({
      'xp': xp,
      'motivo': motivo,
      'fecha': DateTime.now().toIso8601String(),
    });
    historialRaw.insert(0, entrada);
    if (historialRaw.length > 20) historialRaw.removeLast();
    await prefs.setStringList(_keyHist, historialRaw);

    // Sincroniza el total con el servidor para el ranking entre amigos.
    unawaited(_pushXP(actual + xp));
  }

  // ─── Ranking entre amigos (servidor) ────────────────────────────────────────

  /// Sube el XP total al servidor (para poder compararlo con los amigos). No
  /// lanza: si no hay red o sesión, se ignora y se reintentará al ganar más XP.
  static Future<void> _pushXP(int total) async {
    try {
      await Supabase.instance.client
          .rpc('actualizar_xp', params: {'p_xp': total});
    } catch (_) {
      // Silencioso a propósito.
    }
  }

  /// Empuja el XP actual al servidor (para llamar al abrir la gamificación).
  static Future<void> sincronizarXP() async {
    final xp = await getXP();
    await _pushXP(xp);
  }

  /// Ranking de XP de mis amigos + yo (rpc `ranking_amigos`).
  static Future<List<RankingEntry>> obtenerRanking() async {
    try {
      final res = await Supabase.instance.client.rpc('ranking_amigos');
      return [
        for (final r in (res as List))
          RankingEntry(
            id: (r as Map)['id'] as String,
            nombre: (r['nombre'] as String?) ?? '',
            xp: (r['xp'] as num?)?.toInt() ?? 0,
            esYo: (r['es_yo'] as bool?) ?? false,
          ),
      ];
    } catch (_) {
      return const [];
    }
  }

  // ─── Info del nivel ────────────────────────────────────────────────────────
  static Map<String, dynamic> infoNivel(int xp) {
    for (final nivel in _niveles.reversed) {
      if (xp >= (nivel['minXP'] as int)) return nivel;
    }
    return _niveles.first;
  }

  static String getNombreNivel(int xp) => infoNivel(xp)['nombre'] as String;
  static IconData getIconoNivel(int xp) => infoNivel(xp)['icono'] as IconData;

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
    if (_usuarioActual == null) return [];
    final prefs = await SharedPreferences.getInstance();
    await _migrarLegacy(prefs);
    final raw = prefs.getStringList(_keyHist) ?? [];
    return raw
        .map((e) => jsonDecode(e) as Map<String, dynamic>)
        .toList();
  }
}
