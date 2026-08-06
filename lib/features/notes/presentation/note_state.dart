import 'package:glint/features/notes/domain/note_entity.dart';

abstract class NoteState {}

class NoteLoading extends NoteState {}

class NoteLoaded extends NoteState {
  final List<NoteEntity> notas;
  final String busqueda;
  final CategoriaNote? categoriaFiltro;

  NoteLoaded(this.notas, {this.busqueda = '', this.categoriaFiltro});

  List<NoteEntity> get fijadas => notas.where((n) => n.esFijada).toList();
  List<NoteEntity> get noFijadas => notas.where((n) => !n.esFijada).toList();

  /// ¿Hay algún filtro activo (texto o categoría)?
  bool get hayFiltro => busqueda.isNotEmpty || categoriaFiltro != null;

  /// Notas tras aplicar el filtro por categoría y la búsqueda. La búsqueda
  /// cubre título, contenido, etiquetas y los ítems de las listas.
  List<NoteEntity> get filtradas {
    var lista = notas;
    if (categoriaFiltro != null) {
      lista = lista.where((n) => n.categoria == categoriaFiltro).toList();
    }
    if (busqueda.isNotEmpty) {
      final q = busqueda.toLowerCase();
      lista = lista.where((n) {
        if (n.titulo.toLowerCase().contains(q)) return true;
        if (n.contenido.toLowerCase().contains(q)) return true;
        if (n.tags.toLowerCase().contains(q)) return true;
        return n.items.any((it) => it.texto.toLowerCase().contains(q));
      }).toList();
    }
    return lista;
  }

  int get total => notas.length;
}

class NoteError extends NoteState {
  final String mensaje;
  NoteError(this.mensaje);
}
