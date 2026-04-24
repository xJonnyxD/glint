import 'package:drift/drift.dart';
import 'package:glint/shared/database/app_database.dart';
import 'package:glint/features/finance/domain/savings_goal_entity.dart';

class SavingsGoalRepository {
  final AppDatabase _db;

  SavingsGoalRepository(this._db);

  /// Escucha todas las metas de ahorro de un usuario
  Stream<List<SavingsGoalEntity>> watchMetas(String usuarioId) {
    return (_db.select(_db.savingsGoals)
          ..where((s) => s.usuarioId.equals(usuarioId))
          ..orderBy([(s) => OrderingTerm.desc(s.creadoEn)]))
        .watch()
        .map((rows) => rows.map(_rowToEntity).toList());
  }

  /// Crea una nueva meta de ahorro
  Future<void> crearMeta(SavingsGoalEntity meta) async {
    await _db.into(_db.savingsGoals).insert(_entityToCompanion(meta));
  }

  /// Agrega un monto al ahorro actual de la meta
  Future<void> agregarAhorro(String id, double monto) async {
    final fila = await (_db.select(_db.savingsGoals)
          ..where((s) => s.id.equals(id)))
        .getSingle();

    final nuevoMonto = fila.montoActual + monto;

    await (_db.update(_db.savingsGoals)..where((s) => s.id.equals(id))).write(
      SavingsGoalsCompanion(montoActual: Value(nuevoMonto)),
    );
  }

  /// Elimina una meta de ahorro por su id
  Future<void> eliminarMeta(String id) async {
    await (_db.delete(_db.savingsGoals)..where((s) => s.id.equals(id))).go();
  }

  // ---------- Conversores privados ----------

  SavingsGoalEntity _rowToEntity(SavingsGoal row) => SavingsGoalEntity(
        id:          row.id,
        nombre:      row.nombre,
        emoji:       row.emoji,
        montoMeta:   row.montoMeta,
        montoActual: row.montoActual,
        fechaMeta:   row.fechaMeta,
        color:       row.color,
        usuarioId:   row.usuarioId,
        creadoEn:    row.creadoEn,
      );

  SavingsGoalsCompanion _entityToCompanion(SavingsGoalEntity e) =>
      SavingsGoalsCompanion(
        id:          Value(e.id),
        nombre:      Value(e.nombre),
        emoji:       Value(e.emoji),
        montoMeta:   Value(e.montoMeta),
        montoActual: Value(e.montoActual),
        fechaMeta:   Value(e.fechaMeta),
        color:       Value(e.color),
        usuarioId:   Value(e.usuarioId),
        creadoEn:    Value(e.creadoEn),
      );
}
