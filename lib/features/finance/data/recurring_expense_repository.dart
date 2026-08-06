import 'package:drift/drift.dart';
import 'package:glint/shared/database/app_database.dart';
import 'package:glint/features/finance/domain/recurring_expense_entity.dart';

class RecurringExpenseRepository {
  final AppDatabase _db;

  RecurringExpenseRepository(this._db);

  /// Escucha todos los gastos recurrentes de un usuario
  Stream<List<RecurringExpenseEntity>> watchRecurrentes(String usuarioId) {
    return (_db.select(_db.recurringExpenses)
          ..where((r) => r.usuarioId.equals(usuarioId))
          ..orderBy([(r) => OrderingTerm.asc(r.nombre)]))
        .watch()
        .map((rows) => rows.map(_rowToEntity).toList());
  }

  /// Crea un nuevo gasto recurrente
  Future<void> crearRecurrente(RecurringExpenseEntity gasto) async {
    await _db.into(_db.recurringExpenses).insert(_entityToCompanion(gasto));
  }

  /// Activa o desactiva un gasto recurrente
  Future<void> toggleActivo(String id, bool activo) async {
    await (_db.update(_db.recurringExpenses)..where((r) => r.id.equals(id)))
        .write(RecurringExpensesCompanion(activo: Value(activo)));
  }

  /// Elimina un gasto recurrente por su id
  Future<void> eliminarRecurrente(String id) async {
    await (_db.delete(_db.recurringExpenses)..where((r) => r.id.equals(id)))
        .go();
  }

  // ---------- Conversores privados ----------

  RecurringExpenseEntity _rowToEntity(RecurringExpense row) =>
      RecurringExpenseEntity(
        id:             row.id,
        nombre:         row.nombre,
        categoria:      row.categoria,
        categoriaEmoji: row.categoriaEmoji,
        monto:          row.monto,
        frecuencia:     _intToFrecuencia(row.frecuencia),
        diaDelMes:      row.diaDelMes,
        activo:         row.activo,
        usuarioId:      row.usuarioId,
        creadoEn:       row.creadoEn,
      );

  RecurringExpensesCompanion _entityToCompanion(RecurringExpenseEntity e) =>
      RecurringExpensesCompanion(
        id:             Value(e.id),
        nombre:         Value(e.nombre),
        categoria:      Value(e.categoria),
        categoriaEmoji: Value(e.categoriaEmoji),
        monto:          Value(e.monto),
        frecuencia:     Value(_frecuenciaToInt(e.frecuencia)),
        diaDelMes:      Value(e.diaDelMes),
        activo:         Value(e.activo),
        usuarioId:      Value(e.usuarioId),
        creadoEn:       Value(e.creadoEn),
      );

  FrecuenciaRecurrente _intToFrecuencia(int value) {
    switch (value) {
      case 0:  return FrecuenciaRecurrente.diario;
      case 1:  return FrecuenciaRecurrente.semanal;
      case 3:  return FrecuenciaRecurrente.anual;
      default: return FrecuenciaRecurrente.mensual; // 2 es el default
    }
  }

  int _frecuenciaToInt(FrecuenciaRecurrente f) {
    switch (f) {
      case FrecuenciaRecurrente.diario:   return 0;
      case FrecuenciaRecurrente.semanal:  return 1;
      case FrecuenciaRecurrente.mensual:  return 2;
      case FrecuenciaRecurrente.anual:    return 3;
    }
  }
}
