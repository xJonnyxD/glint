import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glint/shared/database/app_database.dart';

/// Verifica el bug que hacía que "los datos de la web no cargaran en el móvil":
/// un `.watch()` (lo que observan las pantallas) NO se refresca cuando la
/// sincronización escribe con SQL crudo, a menos que se avise con
/// `notifyUpdates`. Este test reproduce ese aviso.
void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase.forTesting(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('notifyUpdates hace que un stream reciba una escritura por SQL crudo',
      () async {
    // Un stream sobre notes, como el que observa la pantalla.
    final emisiones = <int>[];
    final sub = db.select(db.notes).watch().listen((filas) {
      emisiones.add(filas.length);
    });
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(emisiones.last, 0, reason: 'arranca vacío');

    // Insertar con SQL crudo (como hace el motor de sync al bajar del server).
    await db.customStatement(
      "INSERT INTO notes (id, titulo, usuario_id, actualizado_en, pendiente_sync) "
      "VALUES ('n1', 'del server', 'u1', 0, 0)",
    );
    await Future<void>.delayed(const Duration(milliseconds: 20));
    // Sin notificar, el stream NO se enteró (esto es exactamente el bug).
    expect(emisiones.last, 0,
        reason: 'sin notifyUpdates el stream no ve la escritura cruda');

    // El motor ahora avisa: el stream debe refrescarse y ver la nota.
    db.notifyUpdates({TableUpdate('notes', kind: UpdateKind.insert)});
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(emisiones.last, 1,
        reason: 'tras notifyUpdates la pantalla ya ve el dato sincronizado');

    await sub.cancel();
  });
}
