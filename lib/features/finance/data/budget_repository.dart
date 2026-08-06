import 'package:drift/drift.dart';
import 'package:glint/shared/database/app_database.dart';
import 'package:glint/features/finance/domain/budget_entity.dart';

class BudgetRepository {
  final AppDatabase _db;

  BudgetRepository(this._db);

  /// Escucha los presupuestos de un usuario para un mes y año específicos
  Stream<List<BudgetEntity>> watchBudgets(
    String usuarioId,
    int mes,
    int anio,
  ) {
    return (_db.select(_db.budgets)
          ..where(
            (b) =>
                b.usuarioId.equals(usuarioId) &
                b.mes.equals(mes) &
                b.anio.equals(anio),
          )
          ..orderBy([(b) => OrderingTerm.asc(b.categoria)]))
        .watch()
        .map((rows) => rows.map(_rowToEntity).toList());
  }

  /// Crea un nuevo presupuesto
  Future<void> crearBudget(BudgetEntity budget) async {
    await _db.into(_db.budgets).insert(_entityToCompanion(budget));
  }

  /// Actualiza el límite de un presupuesto existente
  Future<void> actualizarLimite(String id, double nuevoLimite) async {
    await (_db.update(_db.budgets)..where((b) => b.id.equals(id))).write(
      BudgetsCompanion(limite: Value(nuevoLimite)),
    );
  }

  /// Elimina un presupuesto por su id
  Future<void> eliminarBudget(String id) async {
    await (_db.delete(_db.budgets)..where((b) => b.id.equals(id))).go();
  }

  // ---------- Conversores privados ----------

  BudgetEntity _rowToEntity(Budget row) => BudgetEntity(
        id:        row.id,
        categoria: row.categoria,
        limite:    row.limite,
        mes:       row.mes,
        anio:      row.anio,
        usuarioId: row.usuarioId,
        creadoEn:  row.creadoEn,
      );

  BudgetsCompanion _entityToCompanion(BudgetEntity e) => BudgetsCompanion(
        id:        Value(e.id),
        categoria: Value(e.categoria),
        limite:    Value(e.limite),
        mes:       Value(e.mes),
        anio:      Value(e.anio),
        usuarioId: Value(e.usuarioId),
        creadoEn:  Value(e.creadoEn),
      );
}
