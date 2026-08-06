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
}
