import 'package:drift/drift.dart';
import 'package:glint/features/routines/data/routine_table.dart';
import 'package:glint/features/finance/data/transaction_table.dart';
import 'package:glint/features/agenda/data/event_table.dart';
import 'package:glint/features/habits/data/habit_table.dart';
import 'package:glint/features/notes/data/note_table.dart';
import 'connection/connection.dart';

// Este archivo tiene código generado — se crea con build_runner
part 'app_database.g.dart';

/// Base de datos local de Glint usando Drift (SQLite).
/// Se agrega una tabla aquí por cada módulo que necesite persistencia local.
@DriftDatabase(tables: [
  Routines,
  Transactions,
  Events,
  Habits,
  Notes,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(connect());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // Versión 4: se agregó la tabla de Hábitos
      if (from < 4) {
        await m.createTable(habits);
      }
      // Versión 5: se agregó la tabla de Notas
      if (from < 5) {
        await m.createTable(notes);
      }
    },
  );
}
