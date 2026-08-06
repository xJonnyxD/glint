import 'dart:typed_data';

/// Visibilidad del perfil: quién puede encontrarte al buscar.
///
/// Se guarda como texto en la BD (hay un CHECK en `19-perfil-social.sql`), así
/// que el nombre del valor y el de la constante deben coincidir.
enum VisibilidadPerfil {
  todos,
  amigos,
  nadie;

  static VisibilidadPerfil desdeTexto(String? v) => switch (v) {
        'todos' => VisibilidadPerfil.todos,
        'nadie' => VisibilidadPerfil.nadie,
        _ => VisibilidadPerfil.amigos,
      };

  String get texto => name;

  String get etiqueta => switch (this) {
        VisibilidadPerfil.todos => 'Cualquiera',
        VisibilidadPerfil.amigos => 'Solo mis amigos',
        VisibilidadPerfil.nadie => 'Nadie',
      };

  String get descripcion => switch (this) {
        VisibilidadPerfil.todos =>
          'Cualquiera puede encontrarte por tu correo o tu código',
        VisibilidadPerfil.amigos =>
          'Solo quienes ya son tus amigos ven tu perfil',
        VisibilidadPerfil.nadie => 'No apareces en las búsquedas',
      };
}

/// El perfil del usuario, tal y como lo maneja la app.
///
/// La fuente de verdad es `public.profiles` en el servidor; esta entidad es su
/// reflejo local. [avatarBytes] es la excepción: vive solo en el dispositivo
/// (ver [ProfileTable]).
class ProfileEntity {
  final String id;
  final String email;

  /// Nombre para mostrar. Es lo que ven los demás en amigos, ranking y grupos.
  final String nombre;
  final String? nombres;
  final String? apellidos;
  final String? bio;
  final DateTime? fechaNacimiento;
  final String? telefono;
  final String? zonaHoraria;
  final VisibilidadPerfil visibilidad;
  final String? avatarUrl;
  final Uint8List? avatarBytes;
  final bool avatarPendiente;
  final DateTime actualizadoEn;

  const ProfileEntity({
    required this.id,
    this.email = '',
    this.nombre = '',
    this.nombres,
    this.apellidos,
    this.bio,
    this.fechaNacimiento,
    this.telefono,
    this.zonaHoraria,
    this.visibilidad = VisibilidadPerfil.amigos,
    this.avatarUrl,
    this.avatarBytes,
    this.avatarPendiente = false,
    required this.actualizadoEn,
  });

  /// Nombre y apellidos unidos, sin espacios sobrantes si falta alguno.
  /// Es lo que se escribe en la columna `nombre` al guardar.
  String get nombreCompleto {
    final n = (nombres ?? '').trim();
    final a = (apellidos ?? '').trim();
    final junto = '$n $a'.trim();
    if (junto.isNotEmpty) return junto;
    // Sin nombres/apellidos, cae al nombre para mostrar; y si tampoco hay, al
    // prefijo del correo, que es lo que hace el trigger de alta del servidor.
    if (nombre.trim().isNotEmpty) return nombre.trim();
    final prefijo = email.split('@').first;
    return prefijo.isEmpty ? 'Usuario' : prefijo;
  }

  /// Iniciales para el avatar cuando no hay foto. Como mucho dos letras.
  ///
  /// Usa `runes` en vez de `[0]` porque un nombre puede empezar por un emoji o
  /// por una letra fuera del plano básico, y cortar por unidades UTF-16 partiría
  /// el carácter por la mitad.
  String get iniciales {
    final partes = nombreCompleto
        .split(RegExp(r'\s+'))
        .where((p) => p.trim().isNotEmpty)
        .toList();
    if (partes.isEmpty) return '?';
    String primeraLetra(String s) => String.fromCharCode(s.runes.first);
    if (partes.length == 1) return primeraLetra(partes.first).toUpperCase();
    return (primeraLetra(partes.first) + primeraLetra(partes[1])).toUpperCase();
  }

  /// Edad en años cumplidos, o `null` si no hay fecha de nacimiento.
  int? get edad {
    final f = fechaNacimiento;
    if (f == null) return null;
    final hoy = DateTime.now();
    var anios = hoy.year - f.year;
    // Si aún no ha llegado el cumpleaños este año, todavía no los ha cumplido.
    final yaCumplio =
        hoy.month > f.month || (hoy.month == f.month && hoy.day >= f.day);
    if (!yaCumplio) anios--;
    return anios < 0 ? null : anios;
  }

  /// Hay una foto que enseñar (local o remota).
  bool get tieneAvatar =>
      avatarBytes != null || (avatarUrl != null && avatarUrl!.isNotEmpty);

  /// Perfil vacío para un usuario recién llegado, antes de la primera
  /// sincronización.
  factory ProfileEntity.vacio(String id, {String email = ''}) => ProfileEntity(
        id: id,
        email: email,
        actualizadoEn: DateTime.fromMillisecondsSinceEpoch(0),
      );

  ProfileEntity copyWith({
    String? id,
    String? email,
    String? nombre,
    String? nombres,
    String? apellidos,
    String? bio,
    DateTime? fechaNacimiento,
    String? telefono,
    String? zonaHoraria,
    VisibilidadPerfil? visibilidad,
    String? avatarUrl,
    Uint8List? avatarBytes,
    bool? avatarPendiente,
    DateTime? actualizadoEn,
    // Los campos anulables necesitan una forma explícita de volver a null:
    // `copyWith(bio: null)` no se distingue de "no lo toques".
    bool limpiarBio = false,
    bool limpiarFechaNacimiento = false,
    bool limpiarTelefono = false,
    bool limpiarAvatarUrl = false,
    bool limpiarAvatarBytes = false,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      nombre: nombre ?? this.nombre,
      nombres: nombres ?? this.nombres,
      apellidos: apellidos ?? this.apellidos,
      bio: limpiarBio ? null : (bio ?? this.bio),
      fechaNacimiento: limpiarFechaNacimiento
          ? null
          : (fechaNacimiento ?? this.fechaNacimiento),
      telefono: limpiarTelefono ? null : (telefono ?? this.telefono),
      zonaHoraria: zonaHoraria ?? this.zonaHoraria,
      visibilidad: visibilidad ?? this.visibilidad,
      avatarUrl: limpiarAvatarUrl ? null : (avatarUrl ?? this.avatarUrl),
      avatarBytes:
          limpiarAvatarBytes ? null : (avatarBytes ?? this.avatarBytes),
      avatarPendiente: avatarPendiente ?? this.avatarPendiente,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    );
  }
}
