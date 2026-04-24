import 'package:drift/drift.dart';
import 'package:glint/features/routines/data/routine_table.dart';
import 'package:glint/features/finance/data/transaction_table.dart';
import 'package:glint/features/finance/data/budget_table.dart';
import 'package:glint/features/finance/data/savings_goal_table.dart';
import 'package:glint/features/finance/data/debt_table.dart';
import 'package:glint/features/finance/data/recurring_expense_table.dart';
import 'package:glint/features/agenda/data/event_table.dart';
import 'package:glint/features/habits/data/habit_table.dart';
import 'package:glint/features/habits/data/habit_completion_table.dart';
import 'package:glint/features/notes/data/note_table.dart';
import 'connection/connection.dart';

// Este archivo tiene código generado — se crea con build_runner
part 'app_database.g.dart';

/// Base de datos local de Glint usando Drift (SQLite).
@DriftDatabase(tables: [
  Routines,
  Transactions,
  Budgets,
  SavingsGoals,
  Debts,
  RecurringExpenses,
  Events,
  Habits,
  HabitCompletions,
  Notes,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(connect());

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 4) await m.createTable(habits);
      if (from < 5) await m.createTable(notes);
      if (from < 6) {
        await m.createTable(budgets);
        await m.createTable(savingsGoals);
        await m.createTable(debts);
        await m.createTable(recurringExpenses);
      }
      if (from < 7) await m.createTable(habitCompletions);
    },
  );
}
