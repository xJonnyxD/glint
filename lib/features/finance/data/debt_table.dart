import 'package:drift/drift.dart';

/// Tabla de deudas personales.
/// tipo: 0 = leDebo (I owe), 1 = meDebeN (they owe me)
class Debts extends Table {
  TextColumn     get id        => text()();
  TextColumn     get nombre    => text()();
  TextColumn     get concepto  => text().withDefault(const Constant(''))();
  RealColumn     get monto     => real()();
  IntColumn      get tipo      => integer()(); // 0 = leDebo, 1 = meDebeN
  BoolColumn     get pagado    => boolean().withDefault(const Constant(false))();
  DateTimeColumn get fecha     => dateTime()();
  TextColumn     get usuarioId => text()();
  DateTimeColumn get creadoEn  => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
