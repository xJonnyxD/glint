import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:glint/shared/services/sync_manager.dart';
import 'auth_state.dart';

/// AuthCubit — maneja toda la lógica de autenticación.
/// Se comunica con Supabase y actualiza el estado de la app.
class AuthCubit extends Cubit<GlintAuthState> {
  final SupabaseClient _supabase;

  AuthCubit(this._supabase) : super(AuthInitial()) {
    // Al crear el cubit, verificar si ya hay sesión activa
    _checkSession();
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
        emit(AuthAuthenticated(response.user!));
        // Iniciar sincronización en background (sin esperar)
        SyncManager.instance.sincronizarAlInicio(response.user!.id);
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
        // Supabase no requiere confirmación → sesión activa directamente
        emit(AuthAuthenticated(response.user!));
        // Iniciar sincronización en background
        SyncManager.instance.sincronizarAlInicio(response.user!.id);
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

  /// Inicia sesión con Google via Supabase OAuth
  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'sv.glint.app://login-callback/',
      );
      // La sesión se maneja en listenToAuthChanges()
    } on AuthException catch (e) {
      emit(AuthError(_traducirError(e.message)));
    } catch (_) {
      emit(AuthError('No se pudo conectar con Google'));
    }
  }


  /// Escuchar cambios de sesión en tiempo real
  /// (útil cuando el usuario confirma su email y vuelve a la app)
  void listenToAuthChanges() {
    _supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        emit(AuthAuthenticated(session.user));
        // Sincronizar datos cuando cambia la sesión
        SyncManager.instance.sincronizarAlInicio(session.user.id);
      } else {
        emit(AuthUnauthenticated());
      }
    });
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
