import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glint/shared/database/app_database.dart';
import 'package:glint/shared/services/backup_service.dart';

/// Verifica que la copia de seguridad es de verdad restaurable: exportar,
/// borrar todo, restaurar y comprobar que los datos vuelven idénticos.
void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<int> contarNotas() async =>
      (await db.select(db.notes).get()).length;

  test('exportar → borrar → restaurar recupera los datos', () async {
    // Datos de ejemplo en varias tablas
    await db.into(db.notes).insert(NotesCompanion.insert(
        id: 'n1', titulo: 'Idea importante', usuarioId: 'u1',
        contenido: const Value('cuerpo')));
    await db.into(db.transactions).insert(TransactionsCompanion.insert(
        id: 't1', tipo: 'gasto', monto: 9.99, descripcion: 'Café',
        categoria: 'comida', categoriaEmoji: '☕',
        fecha: DateTime(2026, 7, 24), usuarioId: 'u1',
        creadaEn: DateTime(2026, 7, 24)));

    final json = await BackupService.generarJson(db, 'u1');
    expect(json.contains('Idea importante'), isTrue);
    expect(json.contains('pendiente_sync'), isFalse,
        reason: 'las marcas internas no viajan en la copia');

    // Simular pérdida de datos
    await db.customStatement('DELETE FROM notes');
    await db.customStatement('DELETE FROM transactions');
    expect(await contarNotas(), 0);

    // Restaurar
    final total = await BackupService.restaurarDesdeJson(db, json);
    expect(total, 2);

    final notas = await db.select(db.notes).get();
    expect(notas, hasLength(1));
    expect(notas.first.titulo, 'Idea importante');
    expect(notas.first.contenido, 'cuerpo');
    // Restaurado queda pendiente de subir al servidor
    expect(notas.first.pendienteSync, isTrue);

    final tx = await db.select(db.transactions).get();
    expect(tx.single.monto, 9.99);
    expect(tx.single.fecha, DateTime(2026, 7, 24));
  });

  test('un archivo que no es de Glint da error claro', () async {
    expect(
      () => BackupService.restaurarDesdeJson(db, '{"otra":"cosa"}'),
      throwsA(isA<FormatException>()),
    );
    expect(
      () => BackupService.restaurarDesdeJson(db, 'no es json'),
      throwsA(isA<FormatException>()),
    );
  });

  test('restaurar no marca como pendientes las filas de otra cuenta', () async {
    // Dos cuentas han iniciado sesión en este mismo dispositivo.
    await db.into(db.notes).insert(NotesCompanion.insert(
        id: 'n1', titulo: 'De u1', usuarioId: 'u1'));
    await db.into(db.notes).insert(NotesCompanion.insert(
        id: 'n2', titulo: 'De u2', usuarioId: 'u2'));

    // La nota de u2 ya está subida: no queda pendiente. Se marca igual que lo
    // hace el motor de sync, con los triggers suprimidos.
    await db.marcarSyncActivo(true);
    await db.customStatement(
        'UPDATE notes SET pendiente_sync = 0 WHERE id = ?', ['n2']);
    await db.marcarSyncActivo(false);

    final json = await BackupService.generarJson(db, 'u1');
    expect(json.contains('De u2'), isFalse, reason: 'la copia es solo de u1');

    await db.customStatement('DELETE FROM notes WHERE id = ?', ['n1']);
    expect(await BackupService.restaurarDesdeJson(db, json), 1);

    Future<Note> nota(String id) =>
        (db.select(db.notes)..where((n) => n.id.equals(id))).getSingle();

    expect((await nota('n1')).pendienteSync, isTrue,
        reason: 'lo restaurado sí tiene que volver a subir');
    expect((await nota('n2')).pendienteSync, isFalse,
        reason: 'restaurar la copia de u1 no debe tocar las filas de u2');
  });
}
