import 'dart:async';
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
  StreamSubscription? _sub;

  AgendaCubit(this._repo, this._usuarioId) : super(AgendaLoading()) {
    cargarEventos();
  }

  void cargarEventos() {
    _sub?.cancel();
    _sub = _repo.watchEventos(_usuarioId).listen(
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

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }

  /// Deja una fecha en la medianoche LOCAL de ese mismo día.
  ///
  /// Hace falta porque `table_calendar` construye todos sus días con
  /// `DateTime.utc(...)` (ver `utils.dart:46` del paquete). Al tocar el 10 en
  /// el calendario devolvía `2026-08-10 00:00Z`, que en El Salvador (UTC−6) es
  /// **el 9 a las 18:00**: el evento se guardaba y se mostraba un día antes.
  ///
  /// Tomar solo año/mes/día y reconstruir en local corrige tanto ese caso como
  /// el del calendario semanal, que arrastraba la hora actual y hacía que un
  /// evento "del día 10" naciera a las 15:44.
  static DateTime soloDiaLocal(DateTime d) =>
      DateTime(d.year, d.month, d.day);

  void seleccionarDia(DateTime dia) {
    final normalizado = soloDiaLocal(dia);
    _diaSeleccionado = normalizado;
    final state = this.state;
    if (state is AgendaLoaded) {
      emit(AgendaLoaded(state.todos, normalizado));
    }
  }

  Future<void> crearEvento({
    required String titulo,
    String? descripcion,
    required DateTime fecha,
    String? hora,
    int duracionMinutos = 60,
    bool todoElDia = false,
    TipoEvento tipo = TipoEvento.evento,
    String color = '#6750A4',
  }) async {
    // La hora del evento vive en `hora` (texto); `fecha` guarda solo el día, y
    // siempre en local. Si llegara en UTC (como la da table_calendar) el evento
    // aparecería el día anterior.
    final dia = soloDiaLocal(fecha);
    final evento = EventEntity(
      id:          const Uuid().v4(),
      titulo:      titulo,
      descripcion: descripcion,
      fecha:       dia,
      hora:        hora,
      duracionMinutos: duracionMinutos,
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
      final fechaEvento = DateTime(dia.year, dia.month, dia.day, hh, mm);
      await NotificationService.programarNotificacionEvento(
        id:          _idNotifEvento(evento.id),
        titulo:      titulo,
        fechaEvento: fechaEvento,
        descripcion: descripcion,
      );
    }
  }

  Future<void> editarEvento({
    required EventEntity original,
    required String titulo,
    String? descripcion,
    required DateTime fecha,
    String? hora,
    int duracionMinutos = 60,
    bool todoElDia = false,
    TipoEvento tipo = TipoEvento.evento,
    String color = '#6750A4',
  }) async {
    final dia = soloDiaLocal(fecha);
    final actualizado = EventEntity(
      id:          original.id,
      titulo:      titulo,
      descripcion: descripcion,
      fecha:       dia,
      hora:        todoElDia ? null : hora,
      duracionMinutos: duracionMinutos,
      todoElDia:   todoElDia,
      completado:  original.completado,
      color:       color,
      tipo:        tipo,
      usuarioId:   original.usuarioId,
      creadoEn:    original.creadoEn,
    );
    await _repo.actualizarEvento(actualizado);

    // Reprogramar la notificación: cancelar la anterior y crear la nueva.
    await NotificationService.cancelarNotificacionEvento(_idNotifEvento(original.id));
    if (!todoElDia && hora != null && hora.isNotEmpty) {
      final partes = hora.split(':');
      final hh = int.tryParse(partes[0]) ?? 0;
      final mm = int.tryParse(partes.length > 1 ? partes[1] : '0') ?? 0;
      final fechaEvento = DateTime(dia.year, dia.month, dia.day, hh, mm);
      await NotificationService.programarNotificacionEvento(
        id:          _idNotifEvento(original.id),
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
