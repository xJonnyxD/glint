/// Un miembro de un grupo.
///
/// Si [userId] es null, es un miembro "virtual": una persona sin cuenta en
/// Glint que igual participa en los gastos (como en Settle Up).
///
/// Espeja la tabla `grupo_miembros` de Supabase.
class MemberEntity {
  final String id;
  final String grupoId;
  final String? userId; // null → miembro virtual
  final String nombre;
  final String? avatarUrl;
  final double peso; // peso de reparto (por defecto 1)
  final String rol;  // 'dueno' | 'miembro'
  final bool activo;

  const MemberEntity({
    required this.id,
    required this.grupoId,
    required this.userId,
    required this.nombre,
    required this.avatarUrl,
    required this.peso,
    required this.rol,
    required this.activo,
  });

  /// ¿Es una persona sin cuenta en Glint?
  bool get esVirtual => userId == null;

  MemberEntity copyWith({
    String? id,
    String? grupoId,
    String? userId,
    String? nombre,
    String? avatarUrl,
    double? peso,
    String? rol,
    bool? activo,
  }) {
    return MemberEntity(
      id:        id        ?? this.id,
      grupoId:   grupoId   ?? this.grupoId,
      userId:    userId    ?? this.userId,
      nombre:    nombre    ?? this.nombre,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      peso:      peso      ?? this.peso,
      rol:       rol       ?? this.rol,
      activo:    activo    ?? this.activo,
    );
  }
}
