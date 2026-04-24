/// Representa una Rutina en el dominio de la aplicación.
/// Es independiente de la base de datos — es solo la definición de los datos.
class RoutineEntity {
  final String   id;          // identificador único
  final String   nombre;      // ej: "Ejercicio", "Meditación"
  final String   icono;       // código del ícono, ej: "exercise", "meditation"
  final PeriodoDelDia periodo; // mañana, mediodía o noche
  final String   hora;        // ej: "06:30"
  final bool     completadaHoy; // si ya la hizo hoy
  final int      rachaActual;   // días consecutivos completando esta rutina
  final int      orden;         // posición en la lista (para reordenar)
  final String   usuarioId;     // a qué usuario pertenece esta rutina
  final DateTime creadaEn;

  const RoutineEntity({
    required this.id,
    required this.nombre,
    required this.icono,
    required this.periodo,
    required this.hora,
    required this.completadaHoy,
    required this.rachaActual,
    required this.orden,
    required this.usuarioId,
    required this.creadaEn,
  });

  /// Crea una copia con algunos campos cambiados
  RoutineEntity copyWith({
    String?          id,
    String?          nombre,
    String?          icono,
    PeriodoDelDia?   periodo,
    String?          hora,
    bool?            completadaHoy,
    int?             rachaActual,
    int?             orden,
    String?          usuarioId,
    DateTime?        creadaEn,
  }) {
    return RoutineEntity(
      id:             id             ?? this.id,
      nombre:         nombre         ?? this.nombre,
      icono:          icono          ?? this.icono,
      periodo:        periodo        ?? this.periodo,
      hora:           hora           ?? this.hora,
      completadaHoy:  completadaHoy  ?? this.completadaHoy,
      rachaActual:    rachaActual    ?? this.rachaActual,
      orden:          orden          ?? this.orden,
      usuarioId:      usuarioId      ?? this.usuarioId,
      creadaEn:       creadaEn       ?? this.creadaEn,
    );
  }
}

/// Los tres períodos del día para organizar las rutinas
enum PeriodoDelDia {
  manana,   // ☀️ Mañana
  mediodia, // 🌤️ Mediodía
  noche,    // 🌙 Noche
}

/// Utilidades del enum para mostrar texto e íconos
extension PeriodoDelDiaX on PeriodoDelDia {
  String get nombre {
    switch (this) {
      case PeriodoDelDia.manana:   return 'Mañana';
      case PeriodoDelDia.mediodia: return 'Mediodía';
      case PeriodoDelDia.noche:    return 'Noche';
    }
  }

  String get emoji {
    switch (this) {
      case PeriodoDelDia.manana:   return '☀️';
      case PeriodoDelDia.mediodia: return '🌤️';
      case PeriodoDelDia.noche:    return '🌙';
    }
  }

  /// Hora por defecto al crear una rutina en este período
  String get horaDefault {
    switch (this) {
      case PeriodoDelDia.manana:   return '07:00';
      case PeriodoDelDia.mediodia: return '12:00';
      case PeriodoDelDia.noche:    return '21:00';
    }
  }
}

/// Iconos disponibles para las rutinas (nombre → emoji)
const Map<String, String> iconosRutinas = {
  'exercise':     '🏃',
  'meditation':   '🧘',
  'breakfast':    '🍳',
  'water':        '💧',
  'vitamins':     '💊',
  'reading':      '📚',
  'journaling':   '📝',
  'stretching':   '🤸',
  'sleep':        '😴',
  'walk':         '🚶',
  'lunch':        '🥗',
  'dinner':       '🍽️',
  'music':        '🎵',
  'study':        '🎓',
  'skincare':     '✨',
  'gratitude':    '🙏',
  'cold_shower':  '🚿',
  'no_screens':   '📵',
  'prayer':       '⛪',
  'default':      '⭐',
};
