import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
    required String nombre,
  }) async {
    emit(AuthLoading());
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'nombre': nombre},
      );
      if (response.session != null && response.user != null) {
        // Si Supabase no requiere confirmación de email → sesión activa directo
        emit(AuthAuthenticated(response.user!));
      } else if (response.user != null) {
        // Supabase requiere confirmar email → avisar al usuario
        emit(AuthError(
          'Cuenta creada. Revisa tu correo $email y confirma tu cuenta antes de iniciar sesión.',
        ));
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
    emit(AuthLoading());
    try {
      await _supabase.auth.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      // Si falla el cierre remoto, cerramos localmente de todas formas
      emit(AuthUnauthenticated());
    }
  }

  /// Escuchar cambios de sesión en tiempo real
  /// (útil cuando el usuario confirma su email y vuelve a la app)
  void listenToAuthChanges() {
    _supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        emit(AuthAuthenticated(session.user));
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
