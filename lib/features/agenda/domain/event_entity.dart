/// Tipo de item en la agenda
enum TipoEvento { evento, tarea }

/// Entidad de evento/tarea en la agenda
class EventEntity {
  final String id;
  final String titulo;
  final String? descripcion;
  final DateTime fecha;
  final String? hora;       // 'HH:mm' o null si es todo el día
  /// Cuánto dura, en minutos. Solo tiene sentido si [hora] no es nula.
  final int duracionMinutos;
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
    this.duracionMinutos = 60,
    this.todoElDia = false,
    this.completado = false,
    this.color = '#6750A4',
    this.tipo = TipoEvento.evento,
    required this.usuarioId,
    required this.creadoEn,
  });

  bool get esTarea  => tipo == TipoEvento.tarea;
  bool get esEvento => tipo == TipoEvento.evento;

  // ── Posición en la rejilla horaria ────────────────────────────────────────
  // La rejilla mide en minutos desde medianoche; estos ayudantes evitan que
  // cada vista tenga que volver a interpretar el 'HH:mm'.

  /// Minutos transcurridos desde medianoche, o `null` si es de todo el día o
  /// la hora está mal escrita.
  int? get minutoInicio {
    if (todoElDia) return null;
    final h = hora;
    if (h == null) return null;
    final partes = h.split(':');
    if (partes.length != 2) return null;
    final hh = int.tryParse(partes[0]);
    final mm = int.tryParse(partes[1]);
    if (hh == null || mm == null) return null;
    if (hh < 0 || hh > 23 || mm < 0 || mm > 59) return null;
    return hh * 60 + mm;
  }

  /// Minuto en que termina. Se recorta a medianoche: un evento que se pasa de
  /// las 24:00 se dibuja hasta el final del día en vez de desbordar la rejilla.
  int? get minutoFin {
    final inicio = minutoInicio;
    if (inicio == null) return null;
    final dur = duracionMinutos <= 0 ? 60 : duracionMinutos;
    return (inicio + dur).clamp(inicio + 1, 24 * 60);
  }

  /// `true` si este evento y [otro] comparten algún minuto. Dos eventos que se
  /// tocan por el extremo (uno acaba a las 10:00 y el otro empieza a las 10:00)
  /// NO se solapan, así que no se reparten el ancho.
  bool seSolapaCon(EventEntity otro) {
    final a1 = minutoInicio, a2 = minutoFin;
    final b1 = otro.minutoInicio, b2 = otro.minutoFin;
    if (a1 == null || a2 == null || b1 == null || b2 == null) return false;
    return a1 < b2 && b1 < a2;
  }

  /// Texto del rango, p. ej. `9:00 – 10:30`, para las tarjetas y el detalle.
  String? get rangoHorario {
    final inicio = minutoInicio, fin = minutoFin;
    if (inicio == null || fin == null) return null;
    String fmt(int m) =>
        '${(m ~/ 60) % 24}:${(m % 60).toString().padLeft(2, '0')}';
    return '${fmt(inicio)} – ${fmt(fin)}';
  }

  EventEntity copyWith({
    String? id,
    String? titulo,
    String? descripcion,
    DateTime? fecha,
    String? hora,
    int? duracionMinutos,
    bool? todoElDia,
    bool? completado,
    String? color,
    TipoEvento? tipo,
    String? usuarioId,
    DateTime? creadoEn,
  }) {
    return EventEntity(
      id:              id ?? this.id,
      titulo:          titulo ?? this.titulo,
      descripcion:     descripcion ?? this.descripcion,
      fecha:           fecha ?? this.fecha,
      hora:            hora ?? this.hora,
      duracionMinutos: duracionMinutos ?? this.duracionMinutos,
      todoElDia:       todoElDia ?? this.todoElDia,
      completado:      completado ?? this.completado,
      color:           color ?? this.color,
      tipo:            tipo ?? this.tipo,
      usuarioId:       usuarioId ?? this.usuarioId,
      creadoEn:        creadoEn ?? this.creadoEn,
    );
  }
}
