/// Una transferencia sugerida para saldar deudas: [deId] debe pagarle [monto]
/// a [aId]. Los nombres se incluyen para pintar la UI sin volver a buscar.
class SettlementEntity {
  final String deId;
  final String deNombre;
  final String aId;
  final String aNombre;
  final double monto;

  const SettlementEntity({
    required this.deId,
    required this.deNombre,
    required this.aId,
    required this.aNombre,
    required this.monto,
  });
}
