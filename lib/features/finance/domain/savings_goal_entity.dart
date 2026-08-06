/// Entidad de meta de ahorro
class SavingsGoalEntity {
  final String id;
  final String nombre;
  final String emoji;        // e.g. '🏠', '✈️', '🚗'
  final double montoMeta;    // monto objetivo
  final double montoActual;  // monto ahorrado hasta ahora
  final DateTime? fechaMeta; // fecha límite opcional
  final String color;        // color hex, e.g. '#1E88E5'
  final String usuarioId;
  final DateTime creadoEn;

  const SavingsGoalEntity({
    required this.id,
    required this.nombre,
    required this.emoji,
    required this.montoMeta,
    required this.montoActual,
    this.fechaMeta,
    required this.color,
    required this.usuarioId,
    required this.creadoEn,
  });

  /// Porcentaje de progreso entre 0.0 y 1.0
  double get porcentaje =>
      montoMeta > 0 ? (montoActual / montoMeta).clamp(0.0, 1.0) : 0.0;

  /// Cuánto falta para alcanzar la meta
  double get faltante => (montoMeta - montoActual).clamp(0.0, double.infinity);

  /// Si ya se alcanzó la meta
  bool get completado => montoActual >= montoMeta;

  SavingsGoalEntity copyWith({
    String? id,
    String? nombre,
    String? emoji,
    double? montoMeta,
    double? montoActual,
    DateTime? fechaMeta,
    bool clearFechaMeta = false,
    String? color,
    String? usuarioId,
    DateTime? creadoEn,
  }) {
    return SavingsGoalEntity(
      id:          id          ?? this.id,
      nombre:      nombre      ?? this.nombre,
      emoji:       emoji       ?? this.emoji,
      montoMeta:   montoMeta   ?? this.montoMeta,
      montoActual: montoActual ?? this.montoActual,
      fechaMeta:   clearFechaMeta ? null : (fechaMeta ?? this.fechaMeta),
      color:       color       ?? this.color,
      usuarioId:   usuarioId   ?? this.usuarioId,
      creadoEn:    creadoEn    ?? this.creadoEn,
    );
  }
}
