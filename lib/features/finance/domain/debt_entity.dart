/// Tipo de deuda: yo le debo a alguien, o alguien me debe a mí
enum TipoDeuda { leDebo, meDebeN }

/// Entidad de deuda personal
class DebtEntity {
  final String id;
  final String nombre;   // nombre de la persona
  final String concepto; // por qué es la deuda
  final double monto;
  final TipoDeuda tipo;
  final bool pagado;
  final DateTime fecha;
  final String usuarioId;
  final DateTime creadoEn;

  const DebtEntity({
    required this.id,
    required this.nombre,
    required this.concepto,
    required this.monto,
    required this.tipo,
    required this.pagado,
    required this.fecha,
    required this.usuarioId,
    required this.creadoEn,
  });

  DebtEntity copyWith({
    String? id,
    String? nombre,
    String? concepto,
    double? monto,
    TipoDeuda? tipo,
    bool? pagado,
    DateTime? fecha,
    String? usuarioId,
    DateTime? creadoEn,
  }) {
    return DebtEntity(
      id:        id        ?? this.id,
      nombre:    nombre    ?? this.nombre,
      concepto:  concepto  ?? this.concepto,
      monto:     monto     ?? this.monto,
      tipo:      tipo      ?? this.tipo,
      pagado:    pagado    ?? this.pagado,
      fecha:     fecha     ?? this.fecha,
      usuarioId: usuarioId ?? this.usuarioId,
      creadoEn:  creadoEn  ?? this.creadoEn,
    );
  }
}

extension TipoDeudaX on TipoDeuda {
  /// Etiqueta legible
  String get etiqueta => this == TipoDeuda.leDebo ? 'Le debo' : 'Me deben';

  /// Emoji representativo
  String get emoji => this == TipoDeuda.leDebo ? '📤' : '📥';
}
