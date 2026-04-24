import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:glint/features/notes/data/note_repository.dart';
import 'package:glint/features/notes/domain/note_entity.dart';
import 'package:glint/shared/services/xp_service.dart';
import 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  final NoteRepository _repo;
  final String _usuarioId;
  String _busqueda = '';

  NoteCubit(this._repo, this._usuarioId) : super(NoteLoading()) {
    cargarNotas();
  }

  void cargarNotas() {
    _repo.watchNotas(_usuarioId).listen(
      (notas) => emit(NoteLoaded(notas, busqueda: _busqueda)),
      onError: (_) => emit(NoteLoaded([])),
    );
  }

  void buscar(String texto) {
    _busqueda = texto;
    final state = this.state;
    if (state is NoteLoaded) emit(NoteLoaded(state.notas, busqueda: texto));
  }

  Future<void> crearNota({
    required String titulo,
    required String contenido,
    required CategoriaNote categoria,
    required String color,
    required bool esChecklist,
    List<ChecklistItem> items = const [],
  }) async {
    final ahora = DateTime.now();
    final nota = NoteEntity(
      id: const Uuid().v4(),
      titulo: titulo,
      contenido: contenido,
      categoria: categoria,
      color: color,
      esFijada: false,
      esChecklist: esChecklist,
      items: items,
      usuarioId: _usuarioId,
      creadaEn: ahora,
      actualizadaEn: ahora,
    );
    await _repo.crearNota(nota);
    await XpService.agregarXP(5, motivo: 'Nota creada: $titulo');
  }

  Future<void> actualizarNota(NoteEntity nota) async {
    await _repo.actualizarNota(nota.copyWith(actualizadaEn: DateTime.now()));
  }

  Future<void> toggleFijada(NoteEntity nota) async {
    await _repo.toggleFijada(nota.id, !nota.esFijada);
  }

  Future<void> eliminarNota(String id) async {
    await _repo.eliminarNota(id);
  }
}
