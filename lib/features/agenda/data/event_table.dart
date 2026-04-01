import 'package:drift/drift.dart';

/// Tabla de eventos/tareas de la agenda en SQLite
class Events extends Table {
  TextColumn  get id          => text()();
  TextColumn  get titulo      => text()();
  TextColumn  get descripcion => text().nullable()();
  DateTimeColumn get fecha    => dateTime()();
  TextColumn  get hora        => text().nullable()(); // 'HH:mm' o null si es todo el día
  BoolColumn  get todoElDia   => boolean().withDefault(const Constant(false))();
  BoolColumn  get completado  => boolean().withDefault(const Constant(false))();
  TextColumn  get color       => text().withDefault(const Constant('#6750A4'))();
  TextColumn  get tipo        => text().withDefault(const Constant('evento'))(); // 'evento' | 'tarea'
  TextColumn  get usuarioId   => text()();
  DateTimeColumn get creadoEn => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
