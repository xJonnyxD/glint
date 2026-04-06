import 'package:drift/drift.dart';

/// Registra cada día específico que el usuario completó un hábito.
/// Esto permite construir el mapa de calor y calcular estadísticas históricas.
class HabitCompletions extends Table {
  TextColumn get id         => text()();
  TextColumn get habitId    => text()();
  TextColumn get usuarioId  => text()();
  /// Solo se guarda la fecha (año-mes-día), sin hora
  DateTimeColumn get fecha  => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
