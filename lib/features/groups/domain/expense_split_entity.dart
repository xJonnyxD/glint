/// La parte de un gasto que le corresponde a un miembro.
///
/// Espeja la tabla `gasto_partes` de Supabase.
class ExpenseSplitEntity {
  final String id;
  final String gastoId;
  final String miembroId;
  final double monto; // cuánto de este gasto le toca a este miembro

  const ExpenseSplitEntity({
    required this.id,
    required this.gastoId,
    required this.miembroId,
    required this.monto,
  });

  ExpenseSplitEntity copyWith({
    String? id,
    String? gastoId,
    String? miembroId,
    double? monto,
  }) {
    return ExpenseSplitEntity(
      id:        id        ?? this.id,
      gastoId:   gastoId   ?? this.gastoId,
      miembroId: miembroId ?? this.miembroId,
      monto:     monto     ?? this.monto,
    );
  }
}
