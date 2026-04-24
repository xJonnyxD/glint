import 'package:drift/drift.dart';

class Notes extends Table {
  TextColumn get id => text()();
  TextColumn get titulo => text().withLength(min: 0, max: 200)();
  TextColumn get contenido => text().withDefault(const Constant(''))();
  IntColumn get categoria => integer().withDefault(const Constant(0))();
  TextColumn get color => text().withDefault(const Constant('#FFF9C4'))();
  BoolColumn get esFijada => boolean().withDefault(const Constant(false))();
  BoolColumn get esChecklist => boolean().withDefault(const Constant(false))();
  // items del checklist guardados como JSON string: '[{"texto":"...","completado":false}]'
  TextColumn get itemsJson => text().withDefault(const Constant('[]'))();
  TextColumn get usuarioId => text()();
  DateTimeColumn get creadaEn => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get actualizadaEn => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
