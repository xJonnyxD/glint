import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glint/shared/database/app_database.dart';

/// El perfil no usa el trigger genérico del resto de tablas: su clave es `id`
/// (no tiene `usuario_id`) y no se borra nunca, así que lleva uno propio y
/// SIN tumba. Estas pruebas fijan ese contrato.
void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<void> insertarPerfil(String id) => db.into(db.profiles).insert(
        ProfilesCompanion.insert(id: id, email: const Value('a@b.c')),
      );

  Future<Map<String, dynamic>> leer(String id) async {
    final r = await db
        .customSelect(
          'SELECT pendiente_sync, actualizado_en FROM profiles WHERE id = ?',
          variables: [Variable<String>(id)],
        )
        .getSingle();
    return r.data;
  }

  test('editar el perfil lo marca pendiente y sube su marca de tiempo',
      () async {
    await insertarPerfil('u1');
    // Simular que ya se sincronizó.
    await db.marcarSyncActivo(true);
    await db.customStatement(
        "UPDATE profiles SET pendiente_sync = 0, actualizado_en = 1000 WHERE id = 'u1'");
    await db.marcarSyncActivo(false);
    expect((await leer('u1'))['pendiente_sync'], 0);

    await (db.update(db.profiles)..where((p) => p.id.equals('u1')))
        .write(const ProfilesCompanion(bio: Value('hola')));

    final fila = await leer('u1');
    expect(fila['pendiente_sync'], 1);
    expect(fila['actualizado_en'], greaterThan(1000));
  });

  test('lo que llega del servidor NO se re-marca (si no, rebotaría)', () async {
    await insertarPerfil('u1');
    await db.marcarSyncActivo(true);
    await db.customStatement(
        "UPDATE profiles SET pendiente_sync = 0, actualizado_en = 1000 WHERE id = 'u1'");
    // Escritura del sync: con el modo activo el trigger no debe saltar.
    await (db.update(db.profiles)..where((p) => p.id.equals('u1')))
        .write(const ProfilesCompanion(bio: Value('viene del servidor')));
    await db.marcarSyncActivo(false);

    expect((await leer('u1'))['pendiente_sync'], 0);
  });

  test('borrar el perfil NO deja tumba (el perfil no se borra)', () async {
    await insertarPerfil('u1');
    await (db.delete(db.profiles)..where((p) => p.id.equals('u1'))).go();

    final tumbas = await db
        .customSelect("SELECT COUNT(*) c FROM sync_tombstones WHERE tabla = 'profiles'")
        .getSingle();
    expect(tumbas.data['c'], 0);
  });

  test('profiles queda fuera de las tablas del motor genérico', () {
    // Si alguien la añadiera, el trigger de tumbas generado allí referenciaría
    // OLD.usuario_id —columna que no existe— y el CREATE TRIGGER fallaría,
    // dejando la base local inservible.
    expect(AppDatabase.tablasSincronizables, isNot(contains('profiles')));
  });
}
