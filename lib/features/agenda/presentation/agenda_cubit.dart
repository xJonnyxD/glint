import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:glint/features/agenda/data/event_repository.dart';
import 'package:glint/features/agenda/domain/event_entity.dart';
import 'agenda_state.dart';

class AgendaCubit extends Cubit<AgendaState> {
  final EventRepository _repo;
  final String _usuarioId;
  DateTime _diaSeleccionado = DateTime.now();

  AgendaCubit(this._repo, this._usuarioId) : super(AgendaLoading()) {
    cargarEventos();
  }

  void cargarEventos() {
    _repo.watchEventos(_usuarioId).listen(
      (lista) => emit(AgendaLoaded(lista, _diaSeleccionado)),
      onError: (_) => emit(AgendaLoaded([], _diaSeleccionado)),
    );
  }

  void seleccionarDia(DateTime dia) {
    _diaSeleccionado = dia;
    final state = this.state;
    if (state is AgendaLoaded) {
      emit(AgendaLoaded(state.todos, dia));
    }
  }

  Future<void> crearEvento({
    required String titulo,
    String? descripcion,
    required DateTime fecha,
    String? hora,
    bool todoElDia = false,
    TipoEvento tipo = TipoEvento.evento,
    String color = '#6750A4',
  }) async {
    final evento = EventEntity(
      id:          const Uuid().v4(),
      titulo:      titulo,
      descripcion: descripcion,
      fecha:       fecha,
      hora:        hora,
      todoElDia:   todoElDia,
      tipo:        tipo,
      color:       color,
      usuarioId:   _usuarioId,
      creadoEn:    DateTime.now(),
    );
    try {
      await _repo.crearEvento(evento);
    } catch (_) {}
  }

  Future<void> toggleCompletado(EventEntity evento) async {
    try {
      await _repo.toggleCompletado(evento.id, !evento.completado);
    } catch (_) {}
  }

  Future<void> eliminarEvento(String id) async {
    try {
      await _repo.eliminarEvento(id);
    } catch (_) {}
  }
}
