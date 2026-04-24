import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── Colores de acento disponibles ─────────────────────────────────────────────
const List<Map<String, String>> coloresAcento = [
  {'nombre': 'Morado',  'hex': '#6750A4'}, // default Material 3
  {'nombre': 'Azul',    'hex': '#1565C0'},
  {'nombre': 'Verde',   'hex': '#2E7D32'},
  {'nombre': 'Rosa',    'hex': '#AD1457'},
  {'nombre': 'Naranja', 'hex': '#E65100'},
  {'nombre': 'Teal',    'hex': '#00695C'},
  {'nombre': 'Índigo',  'hex': '#283593'},
  {'nombre': 'Rojo',    'hex': '#C62828'},
  {'nombre': 'Café',    'hex': '#4E342E'},
  {'nombre': 'Celeste', 'hex': '#0277BD'},
];

// ── Claves de SharedPreferences ────────────────────────────────────────────────
const _kThemeModeKey   = 'glint_theme_mode';   // int: 0=system, 1=light, 2=dark
const _kAccentColorKey = 'glint_accent_color'; // String hex

// ── Estado ────────────────────────────────────────────────────────────────────
class ThemeSettings {
  final ThemeMode modo;
  final String colorAcento; // hex, e.g. '#6750A4'

  const ThemeSettings({
    required this.modo,
    required this.colorAcento,
  });

  /// Convierte el hex almacenado en un objeto [Color] de Flutter.
  Color get color {
    final hex = colorAcento.replaceAll('#', '');
    final value = int.tryParse('FF$hex', radix: 16) ?? 0xFF6750A4;
    return Color(value);
  }

  ThemeSettings copyWith({ThemeMode? modo, String? colorAcento}) {
    return ThemeSettings(
      modo:        modo        ?? this.modo,
      colorAcento: colorAcento ?? this.colorAcento,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ThemeSettings &&
      other.modo == modo &&
      other.colorAcento == colorAcento;

  @override
  int get hashCode => Object.hash(modo, colorAcento);
}

// ── Cubit ─────────────────────────────────────────────────────────────────────
class ThemeCubit extends Cubit<ThemeSettings> {
  ThemeCubit()
      : super(const ThemeSettings(
          modo:        ThemeMode.system,
          colorAcento: '#6750A4',
        )) {
    _cargarPreferencias();
  }

  // ── Persistencia ─────────────────────────────────────────────────────────────

  Future<void> _cargarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();

    final modoIndex   = prefs.getInt(_kThemeModeKey)       ?? 0;
    final hexColor    = prefs.getString(_kAccentColorKey)  ?? '#6750A4';

    final modo = ThemeMode.values[modoIndex.clamp(0, ThemeMode.values.length - 1)];

    emit(ThemeSettings(modo: modo, colorAcento: hexColor));
  }

  // ── Métodos públicos ──────────────────────────────────────────────────────────

  /// Cambia entre modo claro, oscuro o del sistema y persiste la elección.
  Future<void> cambiarModo(ThemeMode nuevoModo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kThemeModeKey, nuevoModo.index);
    emit(state.copyWith(modo: nuevoModo));
  }

  /// Cambia el color de acento (hex, e.g. '#1565C0') y persiste la elección.
  Future<void> cambiarColor(String hexColor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAccentColorKey, hexColor);
    emit(state.copyWith(colorAcento: hexColor));
  }
}
