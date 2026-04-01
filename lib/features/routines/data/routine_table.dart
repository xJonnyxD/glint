import 'package:drift/drift.dart';

/// Tabla de rutinas en SQLite local.
/// Cada campo aquí = una columna en la base de datos.
class Routines extends Table {
  // Llave primaria: texto único por rutina
  TextColumn get id          => text()();
  TextColumn get nombre      => text().withLength(min: 1, max: 50)();
  TextColumn get icono       => text().withDefault(const Constant('default'))();

  // Período: guardamos el índice del enum (0=mañana, 1=mediodía, 2=noche)
  IntColumn  get periodo     => integer()();

  TextColumn get hora        => text().withDefault(const Constant('07:00'))();
  BoolColumn get completadaHoy => boolean().withDefault(const Constant(false))();
  IntColumn  get rachaActual => integer().withDefault(const Constant(0))();
  IntColumn  get orden       => integer().withDefault(const Constant(0))();
  TextColumn get usuarioId   => text()();
  DateTimeColumn get creadaEn => dateTime().withDefault(currentDateAndTime)();

  // La llave primaria es el id (no autoincremental porque usamos UUID)
  @override
  Set<Column> get primaryKey => {id};
}
