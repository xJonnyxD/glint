/// Representa un Hábito en el dominio de la aplicación.
/// Es independiente de la base de datos — solo define los datos del hábito.
class HabitEntity {
  final String id;
  final String nombre;
  final String icono; // emoji del hábito
  final CategoriaHabito categoria;
  final FrecuenciaHabito frecuencia; // diario, semanal
  final int metaSemanal; // si es semanal: cuántos días por semana (1-7)
  final bool completadoHoy;
  final int rachaActual; // días consecutivos completando el hábito
  final int rachaMaxima; // mejor racha histórica
  final int totalCompletados; // veces completado en total
  final String color; // color hex para la tarjeta, ej: "#4CAF50"
  final String usuarioId;
  final DateTime creadoEn;

  const HabitEntity({
    required this.id,
    required this.nombre,
    required this.icono,
    required this.categoria,
    required this.frecuencia,
    required this.metaSemanal,
    required this.completadoHoy,
    required this.rachaActual,
    required this.rachaMaxima,
    required this.totalCompletados,
    required this.color,
    required this.usuarioId,
    required this.creadoEn,
  });

  /// Crea una copia con algunos campos cambiados
  HabitEntity copyWith({
    String? id,
    String? nombre,
    String? icono,
    CategoriaHabito? categoria,
    FrecuenciaHabito? frecuencia,
    int? metaSemanal,
    bool? completadoHoy,
    int? rachaActual,
    int? rachaMaxima,
    int? totalCompletados,
    String? color,
    String? usuarioId,
    DateTime? creadoEn,
  }) {
    return HabitEntity(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      icono: icono ?? this.icono,
      categoria: categoria ?? this.categoria,
      frecuencia: frecuencia ?? this.frecuencia,
      metaSemanal: metaSemanal ?? this.metaSemanal,
      completadoHoy: completadoHoy ?? this.completadoHoy,
      rachaActual: rachaActual ?? this.rachaActual,
      rachaMaxima: rachaMaxima ?? this.rachaMaxima,
      totalCompletados: totalCompletados ?? this.totalCompletados,
      color: color ?? this.color,
      usuarioId: usuarioId ?? this.usuarioId,
      creadoEn: creadoEn ?? this.creadoEn,
    );
  }
}

/// Categorías de hábitos para organizar en grupos
enum CategoriaHabito {
  salud, // 💪 Salud & Fitness
  mente, // 🧠 Mente & Bienestar
  productividad, // 🎯 Productividad
  nutricion, // 🥗 Nutrición
  social, // 👥 Social
  finanzas, // 💰 Finanzas
  otro, // ⭐ Otro
}

extension CategoriaHabitoX on CategoriaHabito {
  String get nombre {
    switch (this) {
      case CategoriaHabito.salud:
        return 'Salud';
      case CategoriaHabito.mente:
        return 'Mente';
      case CategoriaHabito.productividad:
        return 'Productividad';
      case CategoriaHabito.nutricion:
        return 'Nutrición';
      case CategoriaHabito.social:
        return 'Social';
      case CategoriaHabito.finanzas:
        return 'Finanzas';
      case CategoriaHabito.otro:
        return 'Otro';
    }
  }

  String get emoji {
    switch (this) {
      case CategoriaHabito.salud:
        return '💪';
      case CategoriaHabito.mente:
        return '🧠';
      case CategoriaHabito.productividad:
        return '🎯';
      case CategoriaHabito.nutricion:
        return '🥗';
      case CategoriaHabito.social:
        return '👥';
      case CategoriaHabito.finanzas:
        return '💰';
      case CategoriaHabito.otro:
        return '⭐';
    }
  }

  /// Color representativo de cada categoría
  String get colorHex {
    switch (this) {
      case CategoriaHabito.salud:
        return '#E53935'; // rojo
      case CategoriaHabito.mente:
        return '#8E24AA'; // morado
      case CategoriaHabito.productividad:
        return '#1E88E5'; // azul
      case CategoriaHabito.nutricion:
        return '#43A047'; // verde
      case CategoriaHabito.social:
        return '#FB8C00'; // naranja
      case CategoriaHabito.finanzas:
        return '#00897B'; // verde azulado
      case CategoriaHabito.otro:
        return '#757575'; // gris
    }
  }
}

/// Frecuencia con que se debe hacer el hábito
enum FrecuenciaHabito {
  diario, // todos los días
  semanal, // X días a la semana
}

extension FrecuenciaHabitoX on FrecuenciaHabito {
  String get nombre {
    switch (this) {
      case FrecuenciaHabito.diario:
        return 'Diario';
      case FrecuenciaHabito.semanal:
        return 'Semanal';
    }
  }
}

/// Hábitos sugeridos al usuario al crear su primer hábito
const List<Map<String, dynamic>> habitosSugeridos = [
  {'nombre': 'Ejercicio', 'icono': '🏃', 'categoria': CategoriaHabito.salud},
  {'nombre': 'Meditación', 'icono': '🧘', 'categoria': CategoriaHabito.mente},
  {
    'nombre': 'Leer 30 min',
    'icono': '📚',
    'categoria': CategoriaHabito.productividad
  },
  {'nombre': 'Tomar agua', 'icono': '💧', 'categoria': CategoriaHabito.salud},
  {
    'nombre': 'Comer sano',
    'icono': '🥗',
    'categoria': CategoriaHabito.nutricion
  },
  {
    'nombre': 'Journaling',
    'icono': '📝',
    'categoria': CategoriaHabito.mente
  },
  {
    'nombre': 'Sin redes sociales',
    'icono': '📵',
    'categoria': CategoriaHabito.productividad
  },
  {'nombre': 'Dormir 8h', 'icono': '😴', 'categoria': CategoriaHabito.salud},
  {
    'nombre': 'Vitaminas',
    'icono': '💊',
    'categoria': CategoriaHabito.salud
  },
  {
    'nombre': 'Ahorro diario',
    'icono': '💰',
    'categoria': CategoriaHabito.finanzas
  },
  {
    'nombre': 'Llamar a familia',
    'icono': '📞',
    'categoria': CategoriaHabito.social
  },
  {
    'nombre': 'Ducha fría',
    'icono': '🚿',
    'categoria': CategoriaHabito.salud
  },
];

/// Iconos disponibles para elegir al crear un hábito
const List<String> iconosHabitos = [
  '🏃', '🧘', '📚', '💧', '🥗', '📝', '📵', '😴',
  '💊', '💰', '📞', '🚿', '🏋️', '🚴', '🧗', '🤸',
  '🎵', '🎨', '✍️', '🙏', '🌱', '🌞', '⭐', '🔥',
  '🎯', '🧠', '❤️', '🫁', '🦷', '🥤', '🫖', '🍎',
];
