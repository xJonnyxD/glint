import 'package:supabase_flutter/supabase_flutter.dart';

/// Los posibles estados del módulo de autenticación.
/// La app siempre está en uno de estos 4 estados.
abstract class AuthState {}

/// Estado inicial — verificando si hay sesión guardada
class AuthInitial extends AuthState {}

/// Cargando — esperando respuesta del servidor
class AuthLoading extends AuthState {}

/// Autenticado — hay un usuario con sesión activa
class AuthAuthenticated extends AuthState {
  final User user; // datos del usuario (email, id, etc.)
  AuthAuthenticated(this.user);
}

/// No autenticado — no hay sesión, mostrar pantalla de login
class AuthUnauthenticated extends AuthState {}

/// Error — algo salió mal (contraseña incorrecta, sin internet, etc.)
class AuthError extends AuthState {
  final String message; // mensaje de error en español
  AuthError(this.message);
}
