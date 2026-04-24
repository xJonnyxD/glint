import 'package:glint/features/notes/domain/note_entity.dart';

abstract class NoteState {}

class NoteLoading extends NoteState {}

class NoteLoaded extends NoteState {
  final List<NoteEntity> notas;
  final String busqueda;

  NoteLoaded(this.notas, {this.busqueda = ''});

  List<NoteEntity> get fijadas => notas.where((n) => n.esFijada).toList();
  List<NoteEntity> get noFijadas => notas.where((n) => !n.esFijada).toList();

  List<NoteEntity> get filtradas {
    if (busqueda.isEmpty) return notas;
    final q = busqueda.toLowerCase();
    return notas
        .where((n) =>
            n.titulo.toLowerCase().contains(q) ||
            n.contenido.toLowerCase().contains(q))
        .toList();
  }

  int get total => notas.length;
}

class NoteError extends NoteState {
  final String mensaje;
  NoteError(this.mensaje);
}
