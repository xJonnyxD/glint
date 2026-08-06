import 'dart:convert';

import 'package:drift/drift.dart';

import 'package:glint/features/notes/domain/note_entity.dart';
import 'package:glint/shared/database/app_database.dart';

/// Lo que el usuario tenía escrito en el editor de notas.
class BorradorNota {
  final String titulo;
  final String contenido;
  final String tags;
  final List<ChecklistItem> items;
  final CategoriaNote categoria;
  final String color;
  final bool esFijada;
  final bool esChecklist;

  const BorradorNota({
    this.titulo = '',
    this.contenido = '',
    this.tags = '',
    this.items = const [],
    this.categoria = CategoriaNote.personal,
    this.color = '#FFF9C4',
    this.esFijada = false,
    this.esChecklist = false,
  });

  /// No hay nada que merezca la pena conservar: ni título, ni texto, ni
  /// elementos con contenido.
  bool get vacio =>
      titulo.trim().isEmpty &&
      contenido.trim().isEmpty &&
      items.every((i) => i.texto.trim().isEmpty);
}

/// Guarda y recupera lo que se está escribiendo en el editor de notas.
///
/// El editor llama a [guardar] mientras se escribe (con retardo) y al pasar la
/// app a segundo plano; [leer] restaura ese contenido al reabrir. En cuanto la
/// nota se guarda de verdad —o el usuario descarta los cambios— el borrador se
/// borra con [descartar].
class NoteDraftRepository {
  final AppDatabase _db;
  NoteDraftRepository(this._db);

  /// Clave del borrador de una nota nueva (solo puede haber uno a la vez).
  static const claveNueva = 'nueva';

  Future<BorradorNota?> leer(String usuarioId, String clave) async {
    final fila = await (_db.select(_db.noteDrafts)
          ..where((d) => d.usuarioId.equals(usuarioId) & d.id.equals(clave)))
        .getSingleOrNull();
    if (fila == null) return null;

    return BorradorNota(
      titulo: fila.titulo,
      contenido: fila.contenido,
      tags: fila.tags,
      items: _itemsDesdeJson(fila.itemsJson),
      categoria: CategoriaNote.values[
          fila.categoria.clamp(0, CategoriaNote.values.length - 1)],
      color: fila.color,
      esFijada: fila.esFijada,
      esChecklist: fila.esChecklist,
    );
  }

  Future<void> guardar(
    String usuarioId,
    String clave,
    BorradorNota borrador,
  ) async {
    // Un borrador sin nada que guardar es ruido: mejor quitarlo que dejar una
    // fila vacía que luego "restaure" texto en blanco.
    if (borrador.vacio) {
      await descartar(usuarioId, clave);
      return;
    }

    await _db.into(_db.noteDrafts).insertOnConflictUpdate(
          NoteDraftsCompanion.insert(
            id: clave,
            usuarioId: usuarioId,
            titulo: Value(borrador.titulo),
            contenido: Value(borrador.contenido),
            tags: Value(borrador.tags),
            itemsJson: Value(_itemsAJson(borrador.items)),
            categoria: Value(borrador.categoria.index),
            color: Value(borrador.color),
            esFijada: Value(borrador.esFijada),
            esChecklist: Value(borrador.esChecklist),
            actualizadoEn: Value(DateTime.now()),
          ),
        );
  }

  Future<void> descartar(String usuarioId, String clave) async {
    await (_db.delete(_db.noteDrafts)
          ..where((d) => d.usuarioId.equals(usuarioId) & d.id.equals(clave)))
        .go();
  }

  // El formato es el mismo que usa `notes.itemsJson`, para poder pasar de
  // borrador a nota sin traducir nada.
  static String _itemsAJson(List<ChecklistItem> items) => jsonEncode([
        for (final i in items)
          {'texto': i.texto, 'completado': i.completado},
      ]);

  static List<ChecklistItem> _itemsDesdeJson(String raw) {
    if (raw.isEmpty) return const [];
    try {
      final lista = jsonDecode(raw) as List;
      return [
        for (final e in lista)
          ChecklistItem(
            texto: (e as Map)['texto'] as String? ?? '',
            completado: e['completado'] as bool? ?? false,
          ),
      ];
    } catch (_) {
      // Un borrador ilegible no debe impedir abrir la nota.
      return const [];
    }
  }
}
