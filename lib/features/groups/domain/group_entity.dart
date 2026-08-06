/// Un grupo de gastos compartidos (un viaje, un piso, una pareja…).
///
/// Espeja la tabla `grupos` de Supabase (ver deploy/db-init/06-grupos.sql).
class GroupEntity {
  final String id;
  final String nombre;
  final String moneda; // ISO, ej. 'USD'
  final String color;  // hex, ej. '#6750A4'
  final String emoji;
  final String creadoPor; // uuid del usuario que lo creó
  final DateTime creadoEn;

  const GroupEntity({
    required this.id,
    required this.nombre,
    required this.moneda,
    required this.color,
    required this.emoji,
    required this.creadoPor,
    required this.creadoEn,
  });

  GroupEntity copyWith({
    String? id,
    String? nombre,
    String? moneda,
    String? color,
    String? emoji,
    String? creadoPor,
    DateTime? creadoEn,
  }) {
    return GroupEntity(
      id:        id        ?? this.id,
      nombre:    nombre    ?? this.nombre,
      moneda:    moneda    ?? this.moneda,
      color:     color     ?? this.color,
      emoji:     emoji     ?? this.emoji,
      creadoPor: creadoPor ?? this.creadoPor,
      creadoEn:  creadoEn  ?? this.creadoEn,
    );
  }
}
