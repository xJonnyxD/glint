import 'package:drift/drift.dart';

/// Tabla de transacciones financieras en SQLite
class Transactions extends Table {
  TextColumn     get id             => text()();
  TextColumn     get tipo           => text()(); // 'ingreso' | 'gasto'
  RealColumn     get monto          => real()();
  TextColumn     get descripcion    => text()();
  TextColumn     get categoria      => text()();
  TextColumn     get categoriaEmoji => text()();
  DateTimeColumn get fecha          => dateTime()();
  TextColumn     get notas          => text().nullable()();
  TextColumn     get imagenPath     => text().nullable()();
  TextColumn     get usuarioId      => text()();
  DateTimeColumn get creadaEn       => dateTime()();

  // Sincronización (las gestionan triggers de SQLite; ver app_database.dart)
  DateTimeColumn get actualizadoEn => dateTime().withDefault(currentDateAndTime)();
  BoolColumn     get pendienteSync => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}
