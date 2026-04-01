/// Tipo de item en la agenda
enum TipoEvento { evento, tarea }

/// Entidad de evento/tarea en la agenda
class EventEntity {
  final String id;
  final String titulo;
  final String? descripcion;
  final DateTime fecha;
  final String? hora;       // 'HH:mm' o null si es todo el día
  final bool todoElDia;
  final bool completado;
  final String color;       // hex color
  final TipoEvento tipo;
  final String usuarioId;
  final DateTime creadoEn;

  const EventEntity({
    required this.id,
    required this.titulo,
    this.descripcion,
    required this.fecha,
    this.hora,
    this.todoElDia = false,
    this.completado = false,
    this.color = '#6750A4',
    this.tipo = TipoEvento.evento,
    required this.usuarioId,
    required this.creadoEn,
  });

  bool get esTarea  => tipo == TipoEvento.tarea;
  bool get esEvento => tipo == TipoEvento.evento;
}
