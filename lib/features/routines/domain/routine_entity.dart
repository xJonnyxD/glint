import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';

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

  /// Ícono vectorial del período (reemplaza al emoji en la UI).
  IconData get icono {
    switch (this) {
      case PeriodoDelDia.manana:   return Symbols.wb_sunny_rounded;
      case PeriodoDelDia.mediodia: return Symbols.partly_cloudy_day_rounded;
      case PeriodoDelDia.noche:    return Symbols.bedtime_rounded;
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

/// Iconos disponibles para las rutinas (clave → icono vectorial). La clave es lo
/// que se guarda en `RoutineEntity.icono`, así que el mapa se puede cambiar de
/// emoji a IconData sin migrar datos.
const Map<String, IconData> iconosRutinas = {
  'exercise':     Symbols.directions_run_rounded,
  'meditation':   Symbols.self_improvement_rounded,
  'breakfast':    Symbols.skillet_rounded,
  'water':        Symbols.water_drop_rounded,
  'vitamins':     Symbols.medication_rounded,
  'reading':      Symbols.menu_book_rounded,
  'journaling':   Symbols.edit_note_rounded,
  'stretching':   Symbols.sports_gymnastics_rounded,
  'sleep':        Symbols.bedtime_rounded,
  'walk':         Symbols.directions_walk_rounded,
  'lunch':        Symbols.restaurant_rounded,
  'dinner':       Symbols.dinner_dining_rounded,
  'music':        Symbols.music_note_rounded,
  'study':        Symbols.school_rounded,
  'skincare':     Symbols.spa_rounded,
  'gratitude':    Symbols.volunteer_activism_rounded,
  'cold_shower':  Symbols.shower_rounded,
  'no_screens':   Symbols.mobile_off_rounded,
  'prayer':       Symbols.church_rounded,
  'default':      Symbols.star_rounded,
};
