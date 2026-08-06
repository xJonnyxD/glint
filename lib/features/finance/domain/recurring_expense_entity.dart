/// Frecuencia de repetición de un gasto recurrente
enum FrecuenciaRecurrente { diario, semanal, mensual, anual }

/// Entidad de gasto recurrente (suscripciones, servicios, etc.)
class RecurringExpenseEntity {
  final String id;
  final String nombre;
  final String categoria;
  final String categoriaEmoji;
  final double monto;
  final FrecuenciaRecurrente frecuencia;
  final int diaDelMes; // 1-31, relevante para frecuencia mensual
  final bool activo;
  final String usuarioId;
  final DateTime creadoEn;

  const RecurringExpenseEntity({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.categoriaEmoji,
    required this.monto,
    required this.frecuencia,
    required this.diaDelMes,
    required this.activo,
    required this.usuarioId,
    required this.creadoEn,
  });

  RecurringExpenseEntity copyWith({
    String? id,
    String? nombre,
    String? categoria,
    String? categoriaEmoji,
    double? monto,
    FrecuenciaRecurrente? frecuencia,
    int? diaDelMes,
    bool? activo,
    String? usuarioId,
    DateTime? creadoEn,
  }) {
    return RecurringExpenseEntity(
      id:             id             ?? this.id,
      nombre:         nombre         ?? this.nombre,
      categoria:      categoria      ?? this.categoria,
      categoriaEmoji: categoriaEmoji ?? this.categoriaEmoji,
      monto:          monto          ?? this.monto,
      frecuencia:     frecuencia     ?? this.frecuencia,
      diaDelMes:      diaDelMes      ?? this.diaDelMes,
      activo:         activo         ?? this.activo,
      usuarioId:      usuarioId      ?? this.usuarioId,
      creadoEn:       creadoEn       ?? this.creadoEn,
    );
  }
}

extension FrecuenciaX on FrecuenciaRecurrente {
  /// Nombre legible de la frecuencia
  String get nombre {
    switch (this) {
      case FrecuenciaRecurrente.diario:   return 'Diario';
      case FrecuenciaRecurrente.semanal:  return 'Semanal';
      case FrecuenciaRecurrente.mensual:  return 'Mensual';
      case FrecuenciaRecurrente.anual:    return 'Anual';
    }
  }

  /// Emoji representativo de la frecuencia
  String get emoji {
    switch (this) {
      case FrecuenciaRecurrente.diario:   return '📅';
      case FrecuenciaRecurrente.semanal:  return '🗓️';
      case FrecuenciaRecurrente.mensual:  return '📆';
      case FrecuenciaRecurrente.anual:    return '🗃️';
    }
  }
}
