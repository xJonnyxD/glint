import 'package:drift/drift.dart';

/// Tabla de presupuestos mensuales por categoría
class Budgets extends Table {
  TextColumn     get id         => text()();
  TextColumn     get categoria  => text()();
  RealColumn     get limite     => real()();
  IntColumn      get mes        => integer()();
  IntColumn      get anio       => integer()();
  TextColumn     get usuarioId  => text()();
  DateTimeColumn get creadoEn   => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
