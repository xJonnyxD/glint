import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:glint/features/agenda/data/event_repository.dart';
import 'package:glint/features/agenda/domain/event_entity.dart';
import 'package:glint/shared/services/notification_service.dart';
import 'agenda_state.dart';

class AgendaCubit extends Cubit<AgendaState> {
  final EventRepository _repo;
  final String _usuarioId;
  DateTime _diaSeleccionado = DateTime.now();
  bool _notifsProgramadas = false;

  AgendaCubit(this._repo, this._usuarioId) : super(AgendaLoading()) {
    cargarEventos();
  }

  void cargarEventos() {
    _repo.watchEventos(_usuarioId).listen(
      (lista) {
        emit(AgendaLoaded(lista, _diaSeleccionado));
        if (!_notifsProgramadas) {
          _notifsProgramadas = true;
          reprogramarNotificacionesFuturas();
        }
      },
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
    await _repo.crearEvento(evento);

    // Programar notificación 30 min antes si tiene hora y no es todo el día
    if (!todoElDia && hora != null && hora.isNotEmpty) {
      final partes = hora.split(':');
      final hh = int.tryParse(partes[0]) ?? 0;
      final mm = int.tryParse(partes.length > 1 ? partes[1] : '0') ?? 0;
      final fechaEvento = DateTime(
        fecha.year, fecha.month, fecha.day, hh, mm,
      );
      await NotificationService.programarNotificacionEvento(
        id:          _idNotifEvento(evento.id),
        titulo:      titulo,
        fechaEvento: fechaEvento,
        descripcion: descripcion,
      );
    }
  }

  Future<void> toggleCompletado(EventEntity evento) async {
    await _repo.toggleCompletado(evento.id, !evento.completado);
  }

  Future<void> eliminarEvento(String id) async {
    await _repo.eliminarEvento(id);
    // Cancelar notificación asociada al evento
    await NotificationService.cancelarNotificacionEvento(_idNotifEvento(id));
  }

  /// Reprograma las notificaciones de todos los eventos futuros.
  /// Llamar al iniciar la app para restaurar notificaciones borradas por el sistema.
  Future<void> reprogramarNotificacionesFuturas() async {
    final state = this.state;
    if (state is! AgendaLoaded) return;

    final ahora = DateTime.now();
    for (final evento in state.todos) {
      if (evento.todoElDia || evento.hora == null) continue;
      final partes = evento.hora!.split(':');
      final hh = int.tryParse(partes[0]) ?? 0;
      final mm = int.tryParse(partes.length > 1 ? partes[1] : '0') ?? 0;
      final fechaEvento = DateTime(
        evento.fecha.year, evento.fecha.month, evento.fecha.day, hh, mm,
      );
      // Solo programar eventos futuros (con al menos 31 min de margen)
      if (fechaEvento.isAfter(ahora.add(const Duration(minutes: 31)))) {
        await NotificationService.programarNotificacionEvento(
          id:          _idNotifEvento(evento.id),
          titulo:      evento.titulo,
          fechaEvento: fechaEvento,
          descripcion: evento.descripcion,
        );
      }
    }
  }

  /// Convierte un UUID de evento a un entero para usarlo como ID de notificación.
  int _idNotifEvento(String uuid) =>
      uuid.hashCode.abs() % 80000 + 10000;
}
