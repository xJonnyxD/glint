import 'package:drift/drift.dart';
import 'package:glint/shared/database/app_database.dart';
import 'package:glint/features/finance/domain/debt_entity.dart';

class DebtRepository {
  final AppDatabase _db;

  DebtRepository(this._db);

  /// Escucha todas las deudas de un usuario
  Stream<List<DebtEntity>> watchDeudas(String usuarioId) {
    return (_db.select(_db.debts)
          ..where((d) => d.usuarioId.equals(usuarioId))
          ..orderBy([(d) => OrderingTerm.desc(d.fecha)]))
        .watch()
        .map((rows) => rows.map(_rowToEntity).toList());
  }

  /// Crea una nueva deuda
  Future<void> crearDeuda(DebtEntity deuda) async {
    await _db.into(_db.debts).insert(_entityToCompanion(deuda));
  }

  /// Marca una deuda como pagada
  Future<void> marcarPagado(String id) async {
    await (_db.update(_db.debts)..where((d) => d.id.equals(id))).write(
      const DebtsCompanion(pagado: Value(true)),
    );
  }

  /// Elimina una deuda por su id
  Future<void> eliminarDeuda(String id) async {
    await (_db.delete(_db.debts)..where((d) => d.id.equals(id))).go();
  }

  // ---------- Conversores privados ----------

  DebtEntity _rowToEntity(Debt row) => DebtEntity(
        id:        row.id,
        nombre:    row.nombre,
        concepto:  row.concepto,
        monto:     row.monto,
        tipo:      row.tipo == 0 ? TipoDeuda.leDebo : TipoDeuda.meDebeN,
        pagado:    row.pagado,
        fecha:     row.fecha,
        usuarioId: row.usuarioId,
        creadoEn:  row.creadoEn,
      );

  DebtsCompanion _entityToCompanion(DebtEntity e) => DebtsCompanion(
        id:        Value(e.id),
        nombre:    Value(e.nombre),
        concepto:  Value(e.concepto),
        monto:     Value(e.monto),
        tipo:      Value(e.tipo == TipoDeuda.leDebo ? 0 : 1),
        pagado:    Value(e.pagado),
        fecha:     Value(e.fecha),
        usuarioId: Value(e.usuarioId),
        creadoEn:  Value(e.creadoEn),
      );
}
