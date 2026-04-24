import 'package:drift/drift.dart';
import 'package:glint/shared/database/app_database.dart';
import 'package:glint/features/finance/domain/transaction_entity.dart';

class TransactionRepository {
  final AppDatabase _db;

  TransactionRepository(this._db);

  Stream<List<TransactionEntity>> watchTransacciones(String usuarioId) {
    return (_db.select(_db.transactions)
          ..where((t) => t.usuarioId.equals(usuarioId))
          ..orderBy([(t) => OrderingTerm.desc(t.fecha)]))
        .watch()
        .map((rows) => rows.map(_toEntity).toList());
  }

  Stream<List<TransactionEntity>> watchMesActual(String usuarioId) {
    final ahora  = DateTime.now();
    final inicio = DateTime(ahora.year, ahora.month, 1);
    final fin    = DateTime(ahora.year, ahora.month + 1, 1);

    return (_db.select(_db.transactions)
          ..where((t) =>
              t.usuarioId.equals(usuarioId) &
              t.fecha.isBiggerOrEqualValue(inicio) &
              t.fecha.isSmallerThanValue(fin))
          ..orderBy([(t) => OrderingTerm.desc(t.fecha)]))
        .watch()
        .map((rows) => rows.map(_toEntity).toList());
  }

  Future<void> crearTransaccion(TransactionEntity tx) async {
    await _db.into(_db.transactions).insert(_toCompanion(tx));
  }

  Future<void> eliminarTransaccion(String id) async {
    await (_db.delete(_db.transactions)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  TransactionEntity _toEntity(Transaction row) => TransactionEntity(
        id:             row.id,
        tipo:           row.tipo == 'ingreso'
                            ? TipoTransaccion.ingreso
                            : TipoTransaccion.gasto,
        monto:          row.monto,
        descripcion:    row.descripcion,
        categoria:      row.categoria,
        categoriaEmoji: row.categoriaEmoji,
        fecha:          row.fecha,
        notas:          row.notas,
        imagenPath:     row.imagenPath,
        usuarioId:      row.usuarioId,
        creadaEn:       row.creadaEn,
      );

  TransactionsCompanion _toCompanion(TransactionEntity tx) =>
      TransactionsCompanion(
        id:             Value(tx.id),
        tipo:           Value(tx.esIngreso ? 'ingreso' : 'gasto'),
        monto:          Value(tx.monto),
        descripcion:    Value(tx.descripcion),
        categoria:      Value(tx.categoria),
        categoriaEmoji: Value(tx.categoriaEmoji),
        fecha:          Value(tx.fecha),
        notas:          Value(tx.notas),
        imagenPath:     Value(tx.imagenPath),
        usuarioId:      Value(tx.usuarioId),
        creadaEn:       Value(tx.creadaEn),
      );
}
