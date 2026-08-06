import 'package:drift/drift.dart';

/// Tabla de eventos/tareas de la agenda en SQLite
class Events extends Table {
  TextColumn  get id          => text()();
  TextColumn  get titulo      => text()();
  TextColumn  get descripcion => text().nullable()();
  DateTimeColumn get fecha    => dateTime()();
  TextColumn  get hora        => text().nullable()(); // 'HH:mm' o null si es todo el día
  /// Cuánto dura el evento, en minutos. Sin esto no se puede dibujar un bloque
  /// en la rejilla horaria: habría que inventarse su altura. Se guardan minutos
  /// en vez de una hora de fin para no tratar como caso especial los eventos
  /// que se pasan de la medianoche.
  IntColumn   get duracionMinutos => integer().withDefault(const Constant(60))();
  BoolColumn  get todoElDia   => boolean().withDefault(const Constant(false))();
  BoolColumn  get completado  => boolean().withDefault(const Constant(false))();
  TextColumn  get color       => text().withDefault(const Constant('#6750A4'))();
  TextColumn  get tipo        => text().withDefault(const Constant('evento'))(); // 'evento' | 'tarea'
  TextColumn  get usuarioId   => text()();
  DateTimeColumn get creadoEn => dateTime()();

  DateTimeColumn get actualizadoEn => dateTime().withDefault(currentDateAndTime)();
  BoolColumn     get pendienteSync => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}
