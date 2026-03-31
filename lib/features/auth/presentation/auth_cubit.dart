import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auth_state.dart';

/// AuthCubit — maneja toda la lógica de autenticación.
/// Se comunica con Supabase y actualiza el estado de la app.
class AuthCubit extends Cubit<AuthState> {
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
        data: {'nombre': nombre}, // guardamos el nombre del usuario
      );
      if (response.user != null) {
        // Supabase envía un email de confirmación por defecto
        emit(AuthUnauthenticated());
        // Nota: el estado vuelve a unauthenticated porque el email
        // aún no fue confirmado. El usuario debe revisar su correo.
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
    if (mensaje.contains('Invalid login credentials')) {
      return 'Email o contraseña incorrectos.';
    }
    if (mensaje.contains('Email not confirmed')) {
      return 'Debes confirmar tu email. Revisa tu bandeja de entrada.';
    }
    if (mensaje.contains('User already registered')) {
      return 'Ya existe una cuenta con ese email.';
    }
    if (mensaje.contains('Password should be at least')) {
      return 'La contraseña debe tener al menos 6 caracteres.';
    }
    if (mensaje.contains('Unable to validate email')) {
      return 'El email no es válido.';
    }
    return 'Ocurrió un error. Intenta de nuevo.';
  }
}
