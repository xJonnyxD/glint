import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glint/shared/database/app_database.dart';

/// Verifica en una BD real (en memoria) que los triggers de sync hacen su
/// trabajo: marcar filas como pendientes al cambiarlas y dejar tumbas al
/// borrarlas, salvo cuando el motor de sync está aplicando datos remotos.
void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<void> insertarNota(String id) => db.into(db.notes).insert(
        NotesCompanion.insert(id: id, titulo: 'Nota', usuarioId: 'u1'),
      );

  Future<Map<String, dynamic>> leerNota(String id) async {
    final r = await db
        .customSelect('SELECT pendiente_sync, actualizado_en FROM notes WHERE id = ?',
            variables: [Variable<String>(id)])
        .getSingle();
    return r.data;
  }

  test('una nota nueva nace pendiente de subir', () async {
    await insertarNota('n1');
    expect((await leerNota('n1'))['pendiente_sync'], 1);
  });

  test('editar una nota la vuelve a marcar pendiente y sube su marca de tiempo',
      () async {
    await insertarNota('n1');
    // Simular que ya se sincronizó: limpiar el flag directamente en modo sync
    await db.marcarSyncActivo(true);
    await db.customStatement(
        "UPDATE notes SET pendiente_sync = 0, actualizado_en = 1000 WHERE id = 'n1'");
    await db.marcarSyncActivo(false);
    expect((await leerNota('n1'))['pendiente_sync'], 0);

    // Ahora una edición del usuario
    await (db.update(db.notes)..where((t) => t.id.equals('n1')))
        .write(const NotesCompanion(titulo: Value('editada')));

    final row = await leerNota('n1');
    expect(row['pendiente_sync'], 1, reason: 'la edición marca pendiente');
    expect(row['actualizado_en'], greaterThan(1000),
        reason: 'la edición sube la marca de tiempo');
  });

  test('borrar una nota deja una tumba', () async {
    await insertarNota('n1');
    await (db.delete(db.notes)..where((t) => t.id.equals('n1'))).go();

    final tumbas = await db.select(db.syncTombstones).get();
    expect(tumbas, hasLength(1));
    expect(tumbas.first.filaId, 'n1');
    expect(tumbas.first.tabla, 'notes');
    expect(tumbas.first.usuarioId, 'u1');
  });

  test('en modo sync, aplicar datos remotos NO re-marca ni deja tumba',
      () async {
    await insertarNota('n1');

    await db.marcarSyncActivo(true);
    // El motor "baja" una edición remota y limpia el flag…
    await db.customStatement(
        "UPDATE notes SET titulo = 'remota', pendiente_sync = 0 WHERE id = 'n1'");
    // …y "baja" un borrado remoto
    await db.customStatement("DELETE FROM notes WHERE id = 'n1'");
    await db.marcarSyncActivo(false);

    // No debe quedar ninguna tumba (el borrado vino de fuera, no se re-propaga)
    expect(await db.select(db.syncTombstones).get(), isEmpty);
  });
}
