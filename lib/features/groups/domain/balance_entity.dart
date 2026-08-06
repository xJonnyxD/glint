/// El saldo neto de un miembro dentro de un grupo.
///
/// [balance] > 0  → le deben (puso más de lo que le tocaba).
/// [balance] < 0  → debe (le tocaba más de lo que puso).
/// [balance] ≈ 0  → está en paz.
class BalanceEntity {
  final String miembroId;
  final String nombre;
  final double balance;

  const BalanceEntity({
    required this.miembroId,
    required this.nombre,
    required this.balance,
  });

  bool get leDeben => balance > 0.005;
  bool get debe    => balance < -0.005;
  bool get enPaz   => !leDeben && !debe;
}
