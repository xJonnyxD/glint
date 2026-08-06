import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:glint/shared/database/app_database.dart';
import 'package:glint/features/notes/domain/note_entity.dart';

class NoteRepository {
  final AppDatabase _db;
  NoteRepository(this._db);

  Stream<List<NoteEntity>> watchNotas(String usuarioId) {
    return (_db.select(_db.notes)
          ..where((n) => n.usuarioId.equals(usuarioId))
          ..orderBy([
            (n) => OrderingTerm(expression: n.esFijada, mode: OrderingMode.desc),
            (n) => OrderingTerm(expression: n.actualizadaEn, mode: OrderingMode.desc),
          ]))
        .watch()
        .map((rows) => rows.map(_rowToEntity).toList());
  }

  Future<void> crearNota(NoteEntity nota) async {
    await _db.into(_db.notes).insert(_entityToCompanion(nota));
  }

  Future<void> actualizarNota(NoteEntity nota) async {
    await (_db.update(_db.notes)..where((n) => n.id.equals(nota.id)))
        .write(_entityToCompanion(nota));
  }

  Future<void> toggleFijada(String id, bool fijada) async {
    await (_db.update(_db.notes)..where((n) => n.id.equals(id)))
        .write(NotesCompanion(esFijada: Value(fijada)));
  }

  Future<void> eliminarNota(String id) async {
    await (_db.delete(_db.notes)..where((n) => n.id.equals(id))).go();
  }

  NoteEntity _rowToEntity(Note row) {
    List<ChecklistItem> items = [];
    try {
      final lista = jsonDecode(row.itemsJson) as List<dynamic>;
      items = lista.map((m) => ChecklistItem.fromMap(m as Map<String, dynamic>)).toList();
    } catch (_) {}
    return NoteEntity(
      id: row.id,
      titulo: row.titulo,
      contenido: row.contenido,
      categoria: CategoriaNote.values[row.categoria],
      color: row.color,
      esFijada: row.esFijada,
      esChecklist: row.esChecklist,
      items: items,
      usuarioId: row.usuarioId,
      creadaEn: row.creadaEn,
      actualizadaEn: row.actualizadaEn,
      tags: row.tags,
    );
  }

  NotesCompanion _entityToCompanion(NoteEntity e) {
    return NotesCompanion(
      id: Value(e.id),
      titulo: Value(e.titulo),
      contenido: Value(e.contenido),
      categoria: Value(e.categoria.index),
      color: Value(e.color),
      esFijada: Value(e.esFijada),
      esChecklist: Value(e.esChecklist),
      itemsJson: Value(jsonEncode(e.items.map((i) => i.toMap()).toList())),
      usuarioId: Value(e.usuarioId),
      creadaEn: Value(e.creadaEn),
      actualizadaEn: Value(e.actualizadaEn),
      tags: Value(e.tags),
    );
  }
}
