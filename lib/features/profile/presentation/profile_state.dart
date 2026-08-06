import 'package:glint/features/profile/domain/profile_entity.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final ProfileEntity perfil;

  /// Hay un guardado en curso (para deshabilitar botones y mostrar progreso).
  final bool guardando;

  /// La foto se está subiendo al servidor.
  final bool subiendoFoto;

  /// Mensaje de error de la última operación, ya traducido para el usuario.
  /// Se limpia solo en la siguiente operación con éxito.
  final String? error;

  const ProfileLoaded(
    this.perfil, {
    this.guardando = false,
    this.subiendoFoto = false,
    this.error,
  });

  ProfileLoaded copyWith({
    ProfileEntity? perfil,
    bool? guardando,
    bool? subiendoFoto,
    String? error,
    bool limpiarError = false,
  }) =>
      ProfileLoaded(
        perfil ?? this.perfil,
        guardando: guardando ?? this.guardando,
        subiendoFoto: subiendoFoto ?? this.subiendoFoto,
        error: limpiarError ? null : (error ?? this.error),
      );
}
