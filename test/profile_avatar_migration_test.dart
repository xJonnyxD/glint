import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glint/shared/database/app_database.dart';
import 'package:sqlite3/sqlite3.dart' as raw;

/// La foto de perfil (Storage) añadió tres columnas a `profiles`
/// —`avatar_url`, `avatar_bytes`, `avatar_pendiente`—. Ponerlas solo en la
/// definición de la tabla NO basta: quien ya tenía la tabla (creada en la v11)
/// no vuelve a pasar por su `createTable` al actualizar. Sin la migración a la
/// v14 esas columnas faltarían y la app crashearía con "no such column:
/// avatar_bytes" en cuanto el usuario cambiara la foto.
///
/// Estas pruebas fijan que la migración las repone y que es idempotente.
void main() {
  late Directory dir;
  late File archivo;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('glint_mig_avatar');
    archivo = File('${dir.path}/glint.db');
  });

  tearDown(() {
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });

  /// Crea a mano una base como la que tenía un dispositivo antes de la foto de
  /// perfil: `profiles` SIN las columnas del avatar, marcada en la v13.
  void sembrarV13SinAvatar() {
    final db = raw.sqlite3.open(archivo.path);
    db.execute('''
      CREATE TABLE profiles (
        id TEXT NOT NULL PRIMARY KEY,
        email TEXT NOT NULL DEFAULT '',
        nombre TEXT NOT NULL DEFAULT '',
        actualizado_en INTEGER NOT NULL DEFAULT 0,
        pendiente_sync INTEGER NOT NULL DEFAULT 1
      );
    ''');
    db.execute("INSERT INTO profiles (id, email) VALUES ('u1', 'a@b.c');");
    db.execute('PRAGMA user_version = 13;');
    db.dispose();
  }

  Future<Set<String>> columnasDe(AppDatabase db, String tabla) async {
    final filas = await db
        .customSelect("SELECT name FROM pragma_table_info('$tabla')")
        .get();
    return filas.map((f) => f.data['name'] as String).toSet();
  }

  test('migrar de la v13 sin avatar repone las columnas', () async {
    sembrarV13SinAvatar();

    final db = AppDatabase.forTesting(NativeDatabase(archivo));
    addTearDown(db.close);

    // El primer acceso dispara la migración v13 → v14.
    final cols = await columnasDe(db, 'profiles');
    expect(cols, containsAll(['avatar_url', 'avatar_bytes', 'avatar_pendiente']));

    // Y lo que crasheaba —escribir avatar_bytes— ahora funciona.
    await db.customStatement(
      "UPDATE profiles SET avatar_bytes = X'010203', avatar_pendiente = 1 "
      "WHERE id = 'u1'",
    );
    final fila = await db
        .customSelect(
          'SELECT avatar_pendiente FROM profiles WHERE id = ?',
          variables: [Variable<String>('u1')],
        )
        .getSingle();
    expect(fila.data['avatar_pendiente'], 1);
  });

  test('una base nueva (v14 de cero) ya trae las columnas', () async {
    final db = AppDatabase.forTesting(NativeDatabase(archivo));
    addTearDown(db.close);

    final cols = await columnasDe(db, 'profiles');
    expect(cols, containsAll(['avatar_url', 'avatar_bytes', 'avatar_pendiente']));
  });

  test('la migración es idempotente si las columnas ya existían', () async {
    // Simula el caso raro pero posible: la tabla se creó (v11) con las columnas
    // del avatar ya presentes, pero el dispositivo sigue marcado en la v13. La
    // migración debe saltarlas en vez de romper con "duplicate column name".
    final semilla = raw.sqlite3.open(archivo.path);
    semilla.execute('''
      CREATE TABLE profiles (
        id TEXT NOT NULL PRIMARY KEY,
        email TEXT NOT NULL DEFAULT '',
        nombre TEXT NOT NULL DEFAULT '',
        avatar_url TEXT,
        avatar_bytes BLOB,
        avatar_pendiente INTEGER NOT NULL DEFAULT 0
                          CHECK ("avatar_pendiente" IN (0, 1)),
        actualizado_en INTEGER NOT NULL DEFAULT 0,
        pendiente_sync INTEGER NOT NULL DEFAULT 1
      );
    ''');
    semilla.execute('PRAGMA user_version = 13;');
    semilla.dispose();

    final db = AppDatabase.forTesting(NativeDatabase(archivo));
    addTearDown(db.close);

    // No debe lanzar al abrir/migrar.
    final cols = await columnasDe(db, 'profiles');
    expect(cols, containsAll(['avatar_url', 'avatar_bytes', 'avatar_pendiente']));
  });
}
