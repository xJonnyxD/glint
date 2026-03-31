import 'package:supabase_flutter/supabase_flutter.dart';

/// Los posibles estados del módulo de autenticación.
/// La app siempre está en uno de estos 4 estados.
// Renombrado a GlintAuthState para evitar conflicto con AuthState de Supabase
abstract class GlintAuthState {}

/// Estado inicial — verificando si hay sesión guardada
class AuthInitial extends GlintAuthState {}

/// Cargando — esperando respuesta del servidor
class AuthLoading extends GlintAuthState {}

/// Autenticado — hay un usuario con sesión activa
class AuthAuthenticated extends GlintAuthState {
  final User user; // datos del usuario (email, id, etc.)
  AuthAuthenticated(this.user);
}

/// No autenticado — no hay sesión, mostrar pantalla de login
class AuthUnauthenticated extends GlintAuthState {}

/// Error — algo salió mal (contraseña incorrecta, sin internet, etc.)
class AuthError extends GlintAuthState {
  final String message; // mensaje de error en español
  AuthError(this.message);
}
