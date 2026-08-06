import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Catálogo de iconos elegibles para hábitos y rutinas.
///
/// El campo `icono` (String) de hábitos/rutinas guarda una CLAVE estable de este
/// mapa (p.ej. `'water'`), no un emoji. [iconoDeClave] la resuelve a un
/// [IconData]. Para los datos antiguos que guardaron un emoji, [claveDesde]
/// mapea el emoji → clave (o `'default'` si no se reconoce), de modo que la
/// migración no pierde nada y no exige tocar el esquema de la base.
abstract class HabitIcons {
  static const String claveDefault = 'default';

  /// Clave → icono. El orden es el que se muestra en el selector.
  static const Map<String, IconData> catalogo = {
    'default':   Symbols.check_circle_rounded,
    'water':     Symbols.water_drop_rounded,
    'run':       Symbols.directions_run_rounded,
    'gym':       Symbols.fitness_center_rounded,
    'stretch':   Symbols.sports_gymnastics_rounded,
    'cycle':     Symbols.directions_bike_rounded,
    'swim':      Symbols.pool_rounded,
    'walk':      Symbols.directions_walk_rounded,
    'meditate':  Symbols.self_improvement_rounded,
    'sleep':     Symbols.bedtime_rounded,
    'read':      Symbols.menu_book_rounded,
    'study':     Symbols.school_rounded,
    'learn':     Symbols.psychology_rounded,
    'write':     Symbols.edit_note_rounded,
    'code':      Symbols.code_rounded,
    'language':  Symbols.language_rounded,
    'music':     Symbols.music_note_rounded,
    'eat':       Symbols.restaurant_rounded,
    'cook':      Symbols.skillet_rounded,
    'coffee':    Symbols.local_cafe_rounded,
    'medicine':  Symbols.medication_rounded,
    'teeth':     Symbols.dentistry_rounded,
    'no_smoke':  Symbols.smoke_free_rounded,
    'no_alcohol':Symbols.no_drinks_rounded,
    'clean':     Symbols.cleaning_services_rounded,
    'money':     Symbols.savings_rounded,
    'gratitude': Symbols.volunteer_activism_rounded,
    'nature':    Symbols.park_rounded,
    'pets':      Symbols.pets_rounded,
    'phone':     Symbols.phone_iphone_rounded,
    'sun':       Symbols.wb_sunny_rounded,
    'goal':      Symbols.flag_rounded,
    'star':      Symbols.star_rounded,
    'heart':     Symbols.favorite_rounded,
    'fire':      Symbols.local_fire_department_rounded,
  };

  /// Claves en orden para pintar el selector.
  static List<String> get claves => catalogo.keys.toList();

  /// Resuelve una clave (o un emoji heredado) a su icono, con fallback seguro.
  static IconData iconoDeClave(String? clave) {
    if (clave == null || clave.isEmpty) return catalogo[claveDefault]!;
    if (catalogo.containsKey(clave)) return catalogo[clave]!;
    // Dato antiguo: probablemente un emoji.
    return catalogo[claveDesde(clave)] ?? catalogo[claveDefault]!;
  }

  /// Emoji heredado → clave del catálogo. `'default'` si no se reconoce.
  static String claveDesde(String emoji) => _migracionEmoji[emoji] ?? claveDefault;

  /// Devuelve una CLAVE válida a partir de cualquier valor guardado: si ya es
  /// una clave del catálogo la deja igual; si es un emoji heredado lo mapea; si
  /// no reconoce nada, `'default'`. Úsalo para inicializar el selector.
  static String normalizar(String? valor) {
    if (valor == null || valor.isEmpty) return claveDefault;
    if (catalogo.containsKey(valor)) return valor;
    return claveDesde(valor);
  }

  static const Map<String, String> _migracionEmoji = {
    '💧': 'water', '🚰': 'water',
    '🏃': 'run', '🏃‍♂️': 'run', '🏃‍♀️': 'run',
    '💪': 'gym', '🏋️': 'gym', '🏋️‍♂️': 'gym',
    '🤸': 'stretch', '🧗': 'stretch',
    '🚴': 'cycle', '🚴‍♂️': 'cycle',
    '🏊': 'swim', '🏊‍♂️': 'swim',
    '🚶': 'walk', '🚶‍♂️': 'walk', '🚶‍♀️': 'walk',
    '🧘': 'meditate', '🧘‍♀️': 'meditate', '🧘‍♂️': 'meditate',
    '😴': 'sleep', '🛌': 'sleep', '💤': 'sleep',
    '📚': 'read', '📖': 'read',
    '🎓': 'study', '✏️': 'study',
    '🧠': 'learn',
    '✍️': 'write', '🖊️': 'write', '📝': 'write',
    '💻': 'code', '⌨️': 'code',
    '🌐': 'language', '🗣️': 'language',
    '🎵': 'music', '🎶': 'music', '🎸': 'music',
    '🥗': 'eat', '🍎': 'eat', '🍽️': 'eat',
    '🍳': 'cook', '👨‍🍳': 'cook',
    '☕': 'coffee', '🍵': 'coffee',
    '💊': 'medicine', '🩺': 'medicine',
    '🦷': 'teeth', '🪥': 'teeth',
    '🚭': 'no_smoke',
    '🍷': 'no_alcohol', '🍺': 'no_alcohol', '🚫': 'no_alcohol',
    '🧹': 'clean', '🧼': 'clean',
    '💰': 'money', '💵': 'money', '🪙': 'money',
    '🙏': 'gratitude', '🤲': 'gratitude',
    '🌳': 'nature', '🌲': 'nature', '🌱': 'nature', '🌿': 'nature',
    '🐕': 'pets', '🐶': 'pets', '🐈': 'pets', '🐱': 'pets',
    '📱': 'phone',
    '☀️': 'sun', '🌅': 'sun',
    '🎯': 'goal', '🚩': 'goal',
    '⭐': 'star', '🌟': 'star', '✨': 'star',
    '❤️': 'heart', '💖': 'heart', '💗': 'heart',
    '🔥': 'fire',
  };
}
