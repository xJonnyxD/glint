import 'package:glint/features/agenda/domain/event_entity.dart';

abstract class AgendaState {}

class AgendaLoading extends AgendaState {}

class AgendaLoaded extends AgendaState {
  final List<EventEntity> todos;       // todos los eventos
  final DateTime diaSeleccionado;

  AgendaLoaded(this.todos, this.diaSeleccionado);

  /// Eventos del día seleccionado
  List<EventEntity> get eventosDelDia => todos
      .where((e) =>
          e.fecha.year  == diaSeleccionado.year &&
          e.fecha.month == diaSeleccionado.month &&
          e.fecha.day   == diaSeleccionado.day)
      .toList();

  /// Días que tienen al menos un evento (para marcar en el calendario)
  Set<DateTime> get diasConEventos => todos
      .map((e) => DateTime(e.fecha.year, e.fecha.month, e.fecha.day))
      .toSet();
}

class AgendaError extends AgendaState {
  final String mensaje;
  AgendaError(this.mensaje);
}
