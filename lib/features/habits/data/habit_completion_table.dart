import 'package:drift/drift.dart';

/// Registra cada día específico que el usuario completó un hábito.
/// Esto permite construir el mapa de calor y calcular estadísticas históricas.
class HabitCompletions extends Table {
  TextColumn get id         => text()();
  TextColumn get habitId    => text()();
  TextColumn get usuarioId  => text()();
  /// Solo se guarda la fecha (año-mes-día), sin hora
  DateTimeColumn get fecha  => dateTime()();

  // true = falta subir esta completación a Supabase (cola offline).
  BoolColumn get pendienteSync =>
      boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tumbas: filas borradas localmente que todavía hay que borrar en Supabase.
///
/// Sin esto, un borrado no viaja: al no existir ya la fila, la subida no tiene
/// nada que enviar y la próxima descarga volvería a traerla. Guardamos el id y
/// la tabla para poder aplicar el DELETE remoto y, una vez confirmado, quitar
/// la tumba.
class SyncTombstones extends Table {
  /// id de la fila borrada (mismo UUID que tenía en su tabla)
  TextColumn get filaId    => text()();
  /// nombre lógico de la tabla: 'habits' o 'habit_completions'
  TextColumn get tabla     => text()();
  TextColumn get usuarioId => text()();
  DateTimeColumn get borradoEn => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {filaId, tabla};
}
