import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:glint/shared/services/achievement_service.dart';
import 'package:glint/features/finance/presentation/privacidad_saldo.dart';
import 'package:glint/shared/services/presence_service.dart';
import 'package:glint/shared/services/sync_manager.dart';
import 'package:glint/shared/services/xp_service.dart';
import 'auth_state.dart';

/// AuthCubit — maneja toda la lógica de autenticación.
/// Se comunica con Supabase y actualiza el estado de la app.
class AuthCubit extends Cubit<GlintAuthState> {
  final SupabaseClient _supabase;
  StreamSubscription? _authSubscription;

  AuthCubit(this._supabase) : super(AuthInitial()) {
    // Al crear el cubit, verificar si ya hay sesión activa
    _checkSession();
    // Y quedarse escuchando: es lo que hace que al volver de Google —o de un
    // enlace de correo— la app entre sola, sin tener que cerrarla y reabrirla.
    _escucharSesion();
  }

  /// Punto central: cada vez que cambia el estado de auth se ajustan los
  /// servicios por usuario (XP, logros, presencia) y ARRANCA la sincronización.
  ///
  /// Hacerlo aquí y no solo en el login es la diferencia entre que sincronice
  /// o no: el caso más común es abrir la app con la sesión ya guardada, que
  /// pasa por aquí (sesión restaurada, refresco de token) pero no por el login.
  @override
  void onChange(Change<GlintAuthState> change) {
    super.onChange(change);
    final next = change.nextState;
    if (next is AuthAuthenticated) {
      XpService.setUsuario(next.user.id);
      AchievementService.setUsuario(next.user.id);
      PresenceService.iniciar(_supabase);
      // Si este usuario dejó sus importes ocultos, que sigan ocultos al volver.
      unawaited(PrivacidadSaldo.instancia.cargarPara(next.user.id));
      try {
        SyncManager.instance.sincronizarAlInicio(next.user.id);
      } catch (_) {
        // Puede no estar inicializado en tests.
      }
    } else if (next is AuthUnauthenticated) {
      XpService.setUsuario(null);
      AchievementService.setUsuario(null);
      PresenceService.detener();
      try {
        SyncManager.instance.detener();
      } catch (_) {
        // Puede no estar inicializado en tests.
      }
    }
  }

  /// Verifica si el usuario ya tiene sesión guardada del día anterior
  void _checkSession() {
    final session = _supabase.auth.currentSession;
    if (session != null) {
      emit(AuthAuthenticated(session.user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  /// Iniciar sesión con email y contraseña
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading()); // mostrar spinner
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        // La sincronización arranca en onChange al emitir AuthAuthenticated.
        emit(AuthAuthenticated(response.user!));
      } else {
        emit(AuthError('No se pudo iniciar sesión. Intenta de nuevo.'));
      }
    } on AuthException catch (e) {
      // Errores específicos de autenticación (contraseña incorrecta, etc.)
      emit(AuthError(_traducirError(e.message)));
    } catch (e) {
      emit(AuthError('Error de conexión. Verifica tu internet.'));
    }
  }

  /// Crear cuenta nueva con email y contraseña
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String nombres,
    required String apellidos,
    required String telefono,
    DateTime? fechaNacimiento,
  }) async {
    emit(AuthLoading());
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'nombre': '$nombres $apellidos'.trim(),
          'nombres': nombres,
          'apellidos': apellidos,
          'telefono': telefono,
          if (fechaNacimiento != null)
            'fecha_nacimiento': fechaNacimiento.toIso8601String().split('T').first,
        },
      );
      if (response.session != null && response.user != null) {
        // Supabase no requiere confirmación → sesión activa directamente.
        // La sincronización arranca en onChange.
        emit(AuthAuthenticated(response.user!));
      } else if (response.user != null) {
        // Supabase requiere confirmar email → emitir "no autenticado"
        // para que la pantalla muestre el mensaje de éxito en verde
        emit(AuthUnauthenticated());
      } else {
        emit(AuthError('No se pudo crear la cuenta. Intenta de nuevo.'));
      }
    } on AuthException catch (e) {
      emit(AuthError(_traducirError(e.message)));
    } catch (e) {
      emit(AuthError('Error de conexión. Verifica tu internet.'));
    }
  }

  /// Cerrar sesión
  Future<void> signOut() async {
    // NO emitir AuthLoading aquí — eso destruye todos los cubits del árbol
    // antes de navegar, lo que deja las pantallas "congeladas".
    // En su lugar, cerrar sesión y emitir directamente el estado final.
    try {
      await _supabase.auth.signOut();
    } catch (_) {
      // Si falla el cierre remoto, cerramos localmente de todas formas
    }
    emit(AuthUnauthenticated());
  }

  /// Refresca los datos del usuario desde Supabase (útil tras editar perfil)
  Future<void> refreshUser() async {
    try {
      await _supabase.auth.refreshSession();
      final user = _supabase.auth.currentUser;
      if (user != null) emit(AuthAuthenticated(user));
    } catch (_) {
      // Si falla el refresh, no cambiar el estado actual
    }
  }

  /// Enviar email de recuperación de contraseña
  Future<void> resetPassword({required String email}) async {
    emit(AuthLoading());
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      // Emitimos un estado de "no autenticado" para que el listener
      // muestre el mensaje de éxito en la pantalla
      emit(AuthUnauthenticated());
    } on AuthException catch (e) {
      emit(AuthError(_traducirError(e.message)));
    } catch (e) {
      emit(AuthError('Error de conexión. Verifica tu internet.'));
    }
  }

  /// A dónde vuelve Google tras autenticar. En móvil es el esquema propio de la
  /// app (deep link); en web tiene que ser una URL http(s) del propio sitio,
  /// porque el navegador no sabe abrir `sv.glint.app://`. Ambos valores están en
  /// GOTRUE_URI_ALLOW_LIST del servidor.
  static String get _redirectOAuth =>
      kIsWeb ? 'https://glint.yanes.xyz/app/' : 'sv.glint.app://login-callback/';

  /// Inicia sesión con Google via Supabase OAuth.
  ///
  /// `signInWithOAuth` solo ABRE el navegador y vuelve enseguida: no espera a
  /// que la persona termine. Quien avisa de que entró es [_escucharSesion].
  ///
  /// Por eso aquí NO se puede dejar el estado en "cargando": si el usuario
  /// cancelaba en Google y volvía atrás, la pantalla se quedaba bloqueada para
  /// siempre y el botón "Entrar" ya no respondía. Se vuelve a
  /// [AuthUnauthenticated] en cuanto el navegador está lanzado.
  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: _redirectOAuth,
      );
      // Formulario otra vez utilizable mientras la persona decide fuera de la
      // app. Si vuelve con sesión, el listener emitirá AuthAuthenticated.
      if (state is AuthLoading) emit(AuthUnauthenticated());
    } on AuthException catch (e) {
      emit(AuthError(_traducirError(e.message)));
    } catch (_) {
      emit(AuthError('No se pudo conectar con Google'));
    }
  }

  /// Escucha los cambios de sesión de Supabase.
  ///
  /// Es lo que hace que al volver de Google la app entre sola. Antes este
  /// método existía pero **no lo llamaba nadie**: la vuelta del navegador no
  /// despertaba nada y la app seguía como si no hubieras entrado, hasta que la
  /// cerrabas del todo y al abrirla `_checkSession` encontraba la sesión ya
  /// guardada.
  void _escucharSesion() {
    _authSubscription?.cancel();
    _authSubscription = _supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      final evento = data.event;

      // La recuperación de contraseña también trae sesión, pero ahí no hay que
      // mandar a nadie al panel: eso lo gobierna la pantalla de reset.
      if (evento == AuthChangeEvent.passwordRecovery) return;

      if (session != null) {
        // onChange se encarga de arrancar el sync y los servicios por usuario.
        if (state is! AuthAuthenticated) {
          emit(AuthAuthenticated(session.user));
        }
      } else if (evento == AuthChangeEvent.signedOut) {
        emit(AuthUnauthenticated());
      }
    });
  }

  /// Compatibilidad: ya se escucha desde el constructor.
  @Deprecated('La escucha se activa sola al crear el AuthCubit')
  void listenToAuthChanges() => _escucharSesion();

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  /// Traduce los mensajes de error de inglés a español
  String _traducirError(String mensaje) {
    final m = mensaje.toLowerCase();
    if (m.contains('invalid login credentials') ||
        m.contains('invalid email or password') ||
        m.contains('wrong password')) {
      return 'Email o contraseña incorrectos.';
    }
    if (m.contains('email not confirmed') ||
        m.contains('not confirmed')) {
      return 'Debes confirmar tu email. Revisa tu bandeja de entrada y la carpeta de spam.';
    }
    if (m.contains('user already registered') ||
        m.contains('already been registered') ||
        m.contains('already exists')) {
      return 'Ya existe una cuenta con ese email. Intenta iniciar sesión.';
    }
    if (m.contains('password should be at least') ||
        m.contains('password is too short')) {
      return 'La contraseña debe tener al menos 6 caracteres.';
    }
    if (m.contains('unable to validate email') ||
        m.contains('invalid email')) {
      return 'El email ingresado no es válido.';
    }
    if (m.contains('network') ||
        m.contains('connection') ||
        m.contains('timeout') ||
        m.contains('socket')) {
      return 'Sin conexión a internet. Verifica tu red e intenta de nuevo.';
    }
    if (m.contains('too many requests') || m.contains('rate limit')) {
      return 'Demasiados intentos. Espera un momento e intenta de nuevo.';
    }
    if (m.contains('user not found') || m.contains('no user')) {
      return 'No existe una cuenta con ese email.';
    }
    // Fallback: mostrar el mensaje original traducido lo mejor posible
    return 'Error: $mensaje';
  }
}
