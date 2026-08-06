import 'package:drift/drift.dart';

/// Borradores del editor de notas.
///
/// Existe para que no se pierda lo escrito cuando el usuario minimiza la app,
/// cambia a otra o pulsa atrás sin darle a guardar. El editor va volcando aquí
/// lo que hay en pantalla (con un pequeño retardo para no escribir en cada
/// tecla) y al reabrir la nota se restaura tal cual estaba.
///
/// Es una tabla **puramente local**: no entra en
/// [AppDatabase.tablasSincronizables] porque un borrador a medias no tiene
/// nada que hacer en los otros dispositivos del usuario. Se borra en cuanto el
/// contenido se guarda de verdad como nota, o cuando se descarta.
class NoteDrafts extends Table {
  /// Id de la nota que se está editando; para una nota nueva, la palabra
  /// `nueva` (solo puede haber un borrador de nota nueva a la vez por usuario).
  TextColumn get id => text()();

  TextColumn get usuarioId => text()();

  TextColumn get titulo => text().withDefault(const Constant(''))();
  TextColumn get contenido => text().withDefault(const Constant(''))();
  TextColumn get tags => text().withDefault(const Constant(''))();

  /// Elementos de la lista de tareas, en el mismo formato que usa `notes`.
  TextColumn get itemsJson => text().withDefault(const Constant('[]'))();

  IntColumn get categoria => integer().withDefault(const Constant(0))();
  TextColumn get color => text().withDefault(const Constant('#FFF9C4'))();
  BoolColumn get esFijada => boolean().withDefault(const Constant(false))();
  BoolColumn get esChecklist => boolean().withDefault(const Constant(false))();

  DateTimeColumn get actualizadoEn =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id, usuarioId};
}
