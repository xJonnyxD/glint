import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glint/features/notes/data/note_draft_repository.dart';
import 'package:glint/features/notes/domain/note_entity.dart';
import 'package:glint/shared/database/app_database.dart';

/// Borradores del editor de notas: lo que evita que se pierda lo escrito al
/// minimizar la app o salir sin guardar.
void main() {
  late AppDatabase db;
  late NoteDraftRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = NoteDraftRepository(db);
  });
  tearDown(() => db.close());

  test('lo escrito se recupera tal cual', () async {
    await repo.guardar('u1', 'nota-1', const BorradorNota(
      titulo: 'Lista de la compra',
      contenido: 'Pan, leche\ny café',
      tags: 'casa,super',
      categoria: CategoriaNote.compras,
      color: '#FFCDD2',
    ));

    final b = await repo.leer('u1', 'nota-1');
    expect(b, isNotNull);
    expect(b!.titulo, 'Lista de la compra');
    expect(b.contenido, 'Pan, leche\ny café', reason: 'los saltos de línea también');
    expect(b.tags, 'casa,super');
    expect(b.categoria, CategoriaNote.compras);
    expect(b.color, '#FFCDD2');
  });

  test('los elementos de una lista de tareas sobreviven, con su estado', () async {
    await repo.guardar('u1', 'nueva', const BorradorNota(
      titulo: 'Tareas',
      esChecklist: true,
      items: [
        ChecklistItem(texto: 'Comprar pan', completado: true),
        ChecklistItem(texto: 'Llamar al banco', completado: false),
      ],
    ));

    final b = await repo.leer('u1', 'nueva');
    expect(b!.items, hasLength(2));
    expect(b.items[0].texto, 'Comprar pan');
    expect(b.items[0].completado, isTrue);
    expect(b.items[1].completado, isFalse);
    expect(b.esChecklist, isTrue);
  });

  test('guardar de nuevo reemplaza el borrador, no lo duplica', () async {
    await repo.guardar('u1', 'nota-1', const BorradorNota(titulo: 'Primera'));
    await repo.guardar('u1', 'nota-1', const BorradorNota(titulo: 'Segunda'));

    expect((await repo.leer('u1', 'nota-1'))!.titulo, 'Segunda');
    final filas = await db.select(db.noteDrafts).get();
    expect(filas, hasLength(1));
  });

  test('un borrador vacío no se guarda (no debe "restaurar" texto en blanco)',
      () async {
    await repo.guardar('u1', 'nota-1', const BorradorNota(
      titulo: '   ',
      contenido: '',
      items: [ChecklistItem(texto: '  ', completado: false)],
    ));
    expect(await repo.leer('u1', 'nota-1'), isNull);
  });

  test('al descartar, deja de existir', () async {
    await repo.guardar('u1', 'nota-1', const BorradorNota(titulo: 'algo'));
    await repo.descartar('u1', 'nota-1');
    expect(await repo.leer('u1', 'nota-1'), isNull);
  });

  test('el borrador de un usuario no se le aparece a otro', () async {
    await repo.guardar('u1', 'nueva', const BorradorNota(titulo: 'de u1'));
    expect(await repo.leer('u2', 'nueva'), isNull);
    expect((await repo.leer('u1', 'nueva'))!.titulo, 'de u1');
  });

  test('cada nota tiene su propio borrador', () async {
    await repo.guardar('u1', 'nota-1', const BorradorNota(titulo: 'uno'));
    await repo.guardar('u1', 'nota-2', const BorradorNota(titulo: 'dos'));

    expect((await repo.leer('u1', 'nota-1'))!.titulo, 'uno');
    expect((await repo.leer('u1', 'nota-2'))!.titulo, 'dos');
  });

  test('los borradores NO se sincronizan con el servidor', () {
    // Un texto a medias no tiene nada que hacer en los otros dispositivos, y
    // además la tabla no tiene las columnas que el motor de sync espera.
    expect(AppDatabase.tablasSincronizables, isNot(contains('note_drafts')));
  });

  test('un borrador con JSON corrupto no impide abrir la nota', () async {
    await db.customStatement(
      "INSERT INTO note_drafts (id, usuario_id, titulo, contenido, tags, "
      "items_json, categoria, color, es_fijada, es_checklist, actualizado_en) "
      "VALUES ('rota', 'u1', 'T', '', '', 'esto no es json', 0, '#FFF', 0, 0, 0)",
    );
    final b = await repo.leer('u1', 'rota');
    expect(b, isNotNull);
    expect(b!.titulo, 'T');
    expect(b.items, isEmpty);
  });
}
