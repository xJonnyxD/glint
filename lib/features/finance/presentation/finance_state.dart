import 'package:glint/features/finance/domain/transaction_entity.dart';

abstract class FinanceState {}

class FinanceLoading extends FinanceState {}

class FinanceLoaded extends FinanceState {
  final List<TransactionEntity> transacciones;

  FinanceLoaded(this.transacciones);

  double get totalIngresos => transacciones
      .where((t) => t.esIngreso)
      .fold(0.0, (sum, t) => sum + t.monto);

  double get totalGastos => transacciones
      .where((t) => t.esGasto)
      .fold(0.0, (sum, t) => sum + t.monto);

  double get balance => totalIngresos - totalGastos;

  List<TransactionEntity> get ingresos =>
      transacciones.where((t) => t.esIngreso).toList();

  List<TransactionEntity> get gastos =>
      transacciones.where((t) => t.esGasto).toList();
}

class FinanceError extends FinanceState {
  final String mensaje;
  FinanceError(this.mensaje);
}
