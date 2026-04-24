/// Entidad de presupuesto mensual por categoría
class BudgetEntity {
  final String id;
  final String categoria; // nombre de CategoriaGasto
  final double limite;    // monto máximo mensual
  final int mes;          // 1-12
  final int anio;
  final String usuarioId;
  final DateTime creadoEn;

  const BudgetEntity({
    required this.id,
    required this.categoria,
    required this.limite,
    required this.mes,
    required this.anio,
    required this.usuarioId,
    required this.creadoEn,
  });

  BudgetEntity copyWith({
    String? id,
    String? categoria,
    double? limite,
    int? mes,
    int? anio,
    String? usuarioId,
    DateTime? creadoEn,
  }) {
    return BudgetEntity(
      id:         id         ?? this.id,
      categoria:  categoria  ?? this.categoria,
      limite:     limite     ?? this.limite,
      mes:        mes        ?? this.mes,
      anio:       anio       ?? this.anio,
      usuarioId:  usuarioId  ?? this.usuarioId,
      creadoEn:   creadoEn   ?? this.creadoEn,
    );
  }
}
