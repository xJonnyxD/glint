import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:glint/core/constants/app_constants.dart';
import 'package:glint/features/profile/data/profile_repository.dart';
import 'package:glint/features/profile/domain/profile_entity.dart';
import 'profile_state.dart';

/// Estado del perfil del usuario.
///
/// Lee de la base local (que el sync mantiene al día con el servidor) y
/// escribe también en local: el trigger `glint_touch_profiles` marca la fila
/// como pendiente y `ProfileSyncService` la sube. Así editar el perfil
/// funciona sin red y se propaga en cuanto la haya.
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repo;
  final SupabaseClient _supabase;
  final String _uid;
  final String _email;

  /// Se llama tras guardar para empujar el cambio al servidor sin esperar al
  /// ciclo de 3 minutos. Es un callback para no acoplar el cubit al
  /// SyncManager (y poder testearlo sin red).
  final Future<void> Function(String uid)? _empujarSync;

  StreamSubscription? _sub;

  /// Para no reintentar la subida de la foto en cada emisión del stream, que
  /// salta con cualquier cambio del perfil. Una vez por sesión basta: si sigue
  /// sin haber red, se reintenta al volver a abrir la pantalla.
  bool _reintentoFotoHecho = false;

  ProfileCubit(
    this._repo,
    this._supabase, {
    required String uid,
    required String email,
    Future<void> Function(String uid)? empujarSync,
  })  : _uid = uid,
        _email = email,
        _empujarSync = empujarSync,
        super(const ProfileLoading()) {
    _cargar();
  }

  Future<void> _cargar() async {
    await _repo.asegurarFila(_uid, _email);
    _sub?.cancel();
    _sub = _repo.observar(_uid).listen(
      (perfil) {
        if (perfil == null) return;
        final actual = state;
        emit(actual is ProfileLoaded
            ? actual.copyWith(perfil: perfil)
            : ProfileLoaded(perfil));

        // Si quedó una foto sin subir de una sesión anterior (se eligió sin
        // red, o antes de que Storage existiera), este es el momento de
        // mandarla: ya hay perfil cargado y sesión válida.
        if (perfil.avatarPendiente && !_reintentoFotoHecho) {
          _reintentoFotoHecho = true;
          unawaited(reintentarFotoPendiente());
        }
      },
      onError: (_) {
        // Sin fila local no hay nada que pintar; se reintenta al reabrir.
      },
    );
  }

  /// Guarda los campos que se le pasen; los que no, se dejan como están.
  ///
  /// Para vaciar un campo opcional hay que usar los `limpiar*`, porque pasar
  /// `null` significa "no lo toques".
  Future<void> actualizarCampos({
    String? nombres,
    String? apellidos,
    String? bio,
    DateTime? fechaNacimiento,
    String? telefono,
    String? zonaHoraria,
    VisibilidadPerfil? visibilidad,
    bool limpiarBio = false,
    bool limpiarFechaNacimiento = false,
    bool limpiarTelefono = false,
  }) async {
    final actual = state;
    if (actual is! ProfileLoaded) return;

    emit(actual.copyWith(guardando: true, limpiarError: true));
    try {
      final nuevo = actual.perfil.copyWith(
        nombres: nombres,
        apellidos: apellidos,
        bio: bio,
        fechaNacimiento: fechaNacimiento,
        telefono: telefono,
        zonaHoraria: zonaHoraria,
        visibilidad: visibilidad,
        limpiarBio: limpiarBio,
        limpiarFechaNacimiento: limpiarFechaNacimiento,
        limpiarTelefono: limpiarTelefono,
      );
      await _repo.guardar(nuevo);

      // El nombre se espeja en el metadata de auth solo por compatibilidad:
      // `main.dart:_nombreDe()` lo lee al crear grupos. Es best-effort — si
      // falla no pasa nada, la verdad está en `profiles`.
      if (nuevo.nombreCompleto != actual.perfil.nombreCompleto) {
        unawaited(_espejarNombreEnAuth(nuevo.nombreCompleto));
      }

      // El stream del repositorio ya emite el perfil nuevo; aquí solo se baja
      // la bandera de "guardando".
      final tras = state;
      if (tras is ProfileLoaded) emit(tras.copyWith(guardando: false));

      await _empujar();
    } catch (e) {
      final tras = state;
      if (tras is ProfileLoaded) {
        emit(tras.copyWith(
          guardando: false,
          error: 'No se pudo guardar. Inténtalo de nuevo.',
        ));
      }
      // Se traga a propósito: el cambio ya está en local y subirá luego.
    }
  }

  // ── Foto ─────────────────────────────────────────────────────────────────

  /// Guarda la foto elegida.
  ///
  /// Primero la deja en local y emite: así se ve al instante, sobrevive a un
  /// reinicio y funciona sin red — que es lo que antes no pasaba, porque solo
  /// se guardaba la ruta de un archivo temporal que el sistema podía borrar.
  /// La subida al servidor se intenta después; si falla, queda marcada como
  /// pendiente para reintentarla.
  Future<void> cambiarFoto(Uint8List bytes) async {
    final actual = state;
    if (actual is! ProfileLoaded) return;

    emit(actual.copyWith(subiendoFoto: true, limpiarError: true));
    // Optimista: la foto se ve ya, con o sin red.
    await _repo.guardarAvatar(
      _uid,
      bytes: bytes,
      url: actual.perfil.avatarUrl,
      pendiente: true,
    );

    try {
      final url = await _subirAvatar(bytes);
      await _repo.guardarAvatar(_uid, bytes: bytes, url: url, pendiente: false);
      await _empujar();
      final tras = state;
      if (tras is ProfileLoaded) emit(tras.copyWith(subiendoFoto: false));
    } catch (_) {
      // Sin red o sin Storage: la foto se queda en el dispositivo y marcada
      // como pendiente. No es un error que deba alarmar al usuario.
      final tras = state;
      if (tras is ProfileLoaded) emit(tras.copyWith(subiendoFoto: false));
    }
  }

  Future<void> eliminarFoto() async {
    final actual = state;
    if (actual is! ProfileLoaded) return;
    await _repo.guardarAvatar(_uid, bytes: null, url: null, pendiente: false);
    try {
      await _borrarAvatarRemoto();
    } catch (_) {
      // Si no se pudo borrar del servidor, al menos ya no se muestra.
    }
    await _empujar();
  }

  /// Ruta del avatar dentro del bucket. La carpeta es el UUID del usuario
  /// porque la política de `storage.objects` decide el dueño por ahí: solo se
  /// puede escribir bajo `avatares/<uid propio>/`.
  String get _rutaAvatar => '$_uid/avatar.jpg';

  /// Sube el avatar y devuelve su URL pública.
  ///
  /// El nombre del archivo es siempre el mismo y se sube con `upsert`, así no
  /// se acumulan fotos viejas que nadie borra. Pero eso deja la URL idéntica
  /// tras cambiar la foto, y el navegador y Cloudflare seguirían sirviendo la
  /// anterior —el mismo problema que ya hubo con el APK y con los iconos—, así
  /// que se le cuelga un `?v=<epoch>` que cambia en cada subida.
  Future<String> _subirAvatar(Uint8List bytes) async {
    final almacen = _supabase.storage.from(AppConstants.bucketAvatares);
    await almacen.uploadBinary(
      _rutaAvatar,
      bytes,
      fileOptions: const FileOptions(
        contentType: 'image/jpeg',
        upsert: true,
        // Un año: la URL ya lleva su propia versión, así que el archivo de una
        // versión concreta se puede cachear sin miedo.
        cacheControl: '31536000',
      ),
    );
    final url = almacen.getPublicUrl(_rutaAvatar);
    return '$url?v=${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> _borrarAvatarRemoto() async {
    await _supabase.storage.from(AppConstants.bucketAvatares).remove([_rutaAvatar]);
  }

  /// Reintenta subir la foto que quedó marcada como pendiente.
  ///
  /// Hace falta porque [cambiarFoto] es optimista: guarda en local y sigue
  /// aunque la subida falle (sin red, servidor caído). Sin este reintento la
  /// foto se quedaría en el dispositivo para siempre y nadie más la vería —que
  /// es exactamente lo que pasaba mientras Storage no existía.
  Future<void> reintentarFotoPendiente() async {
    final actual = state;
    if (actual is! ProfileLoaded) return;
    if (!actual.perfil.avatarPendiente) return;

    final bytes = actual.perfil.avatarBytes;
    if (bytes == null || bytes.isEmpty) {
      // Marcada como pendiente pero sin bytes que subir: no hay nada que
      // reintentar, y dejarla así haría que se intentara en cada arranque.
      await _repo.guardarAvatar(_uid, bytes: null, url: null, pendiente: false);
      return;
    }

    try {
      final url = await _subirAvatar(bytes);
      await _repo.guardarAvatar(_uid, bytes: bytes, url: url, pendiente: false);
      await _empujar();
    } catch (_) {
      // Sigue sin poder subirse; se reintentará la próxima vez.
    }
  }

  Future<void> _espejarNombreEnAuth(String nombre) async {
    try {
      await _supabase.auth.updateUser(UserAttributes(data: {'nombre': nombre}));
    } catch (_) {
      // Silencioso: es un espejo, no la fuente de verdad.
    }
  }

  Future<void> _empujar() async {
    final empujar = _empujarSync;
    if (empujar == null) return;
    try {
      await empujar(_uid);
    } catch (_) {
      // Sin red: el ciclo periódico lo recogerá.
    }
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
