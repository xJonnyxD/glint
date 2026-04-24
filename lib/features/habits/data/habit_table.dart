import 'package:drift/drift.dart';

/// Tabla de hábitos en SQLite local.
/// Cada campo aquí = una columna en la base de datos.
class Habits extends Table {
  // Llave primaria: texto único por hábito (UUID)
  TextColumn get id => text()();
  TextColumn get nombre => text().withLength(min: 1, max: 60)();
  TextColumn get icono => text().withDefault(const Constant('⭐'))();

  // Categoría: guardamos el índice del enum (0=salud, 1=mente, etc.)
  IntColumn get categoria => integer().withDefault(const Constant(0))();

  // Frecuencia: 0=diario, 1=semanal
  IntColumn get frecuencia => integer().withDefault(const Constant(0))();

  // Meta semanal: si es semanal, cuántos días por semana (1-7)
  IntColumn get metaSemanal => integer().withDefault(const Constant(7))();

  BoolColumn get completadoHoy =>
      boolean().withDefault(const Constant(false))();
  IntColumn get rachaActual => integer().withDefault(const Constant(0))();
  IntColumn get rachaMaxima => integer().withDefault(const Constant(0))();
  IntColumn get totalCompletados =>
      integer().withDefault(const Constant(0))();

  // Color hex para la tarjeta del hábito
  TextColumn get color =>
      text().withDefault(const Constant('#1E88E5'))();

  TextColumn get usuarioId => text()();
  DateTimeColumn get creadoEn =>
      dateTime().withDefault(currentDateAndTime)();

  // La llave primaria es el id (UUID)
  @override
  Set<Column> get primaryKey => {id};
}
