import 'balance_entity.dart';
import 'debt_simplifier.dart';
import 'group_entity.dart';
import 'member_entity.dart';
import 'settlement_entity.dart';
import 'shared_expense_entity.dart';

/// Todo lo que una pantalla de detalle de grupo necesita, ya calculado:
/// el grupo, sus miembros, sus gastos, los saldos y las transferencias
/// sugeridas para saldar.
class GroupDetail {
  final GroupEntity grupo;
  final List<MemberEntity> miembros;
  final List<SharedExpenseEntity> gastos;
  final List<BalanceEntity> balances;
  final List<SettlementEntity> liquidaciones;

  const GroupDetail({
    required this.grupo,
    required this.miembros,
    required this.gastos,
    required this.balances,
    required this.liquidaciones,
  });

  /// Construye el detalle calculando saldos y liquidaciones a partir de los
  /// datos crudos.
  factory GroupDetail.calcular({
    required GroupEntity grupo,
    required List<MemberEntity> miembros,
    required List<SharedExpenseEntity> gastos,
  }) {
    final balances =
        DebtSimplifier.calcularBalances(miembros: miembros, gastos: gastos);
    return GroupDetail(
      grupo: grupo,
      miembros: miembros,
      gastos: gastos,
      balances: balances,
      liquidaciones: DebtSimplifier.simplificar(balances),
    );
  }

  /// Total gastado en el grupo (sin contar transferencias de pago).
  double get totalGastado => gastos
      .where((g) => !g.esTransferencia)
      .fold(0.0, (s, g) => s + g.monto);

  MemberEntity? miembroPorId(String id) {
    for (final m in miembros) {
      if (m.id == id) return m;
    }
    return null;
  }
}
