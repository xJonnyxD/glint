import 'package:drift/drift.dart';

/// Tabla de gastos recurrentes (suscripciones, servicios, etc.).
/// frecuencia: 0=diario, 1=semanal, 2=mensual, 3=anual
class RecurringExpenses extends Table {
  TextColumn     get id             => text()();
  TextColumn     get nombre         => text()();
  TextColumn     get categoria      => text()();
  TextColumn     get categoriaEmoji => text().withDefault(const Constant('📦'))();
  RealColumn     get monto          => real()();
  IntColumn      get frecuencia     => integer().withDefault(const Constant(2))(); // 2 = mensual
  IntColumn      get diaDelMes      => integer().withDefault(const Constant(1))();
  BoolColumn     get activo         => boolean().withDefault(const Constant(true))();
  TextColumn     get usuarioId      => text()();
  DateTimeColumn get creadoEn       => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
