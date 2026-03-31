import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_cubit.dart';
import 'auth_state.dart';

/// Pantalla de autenticación — login y registro con email/contraseña
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Controla si mostramos "Iniciar sesión" o "Crear cuenta"
  bool _modoLogin = true;

  // Controladores de texto para los campos del formulario
  final _emailCtrl    = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nombreCtrl   = TextEditingController();

  // Clave para validar el formulario
  final _formKey = GlobalKey<FormState>();

  // Controla si la contraseña se ve o está oculta
  bool _verPassword = false;

  @override
  void dispose() {
    // Liberar memoria cuando se cierra la pantalla
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nombreCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme   = Theme.of(context).textTheme;

    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        // BlocConsumer escucha cambios de estado y reacciona
        listener: (context, state) {
          if (state is AuthError) {
            // Mostrar mensaje de error en un snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: colorScheme.error,
              ),
            );
          }
          if (state is AuthUnauthenticated && !_modoLogin) {
            // Registro exitoso — mostrar mensaje y cambiar a login
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  '¡Cuenta creada! Revisa tu email para confirmarla.',
                ),
                backgroundColor: Colors.green,
              ),
            );
            setState(() => _modoLogin = true);
          }
        },
        builder: (context, state) {
          final cargando = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60),

                    // ── Logo y título ────────────────────────────────────────
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.auto_awesome,
                          size: 40,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'Glint',
                        style: textTheme.headlineLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Tu vida, organizada',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withAlpha(153),
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    // ── Título del formulario ────────────────────────────────
                    Text(
                      _modoLogin ? 'Iniciar sesión' : 'Crear cuenta',
                      style: textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _modoLogin
                          ? 'Bienvenido de vuelta'
                          : 'Empieza tu journey con Glint',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withAlpha(153),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Campo: Nombre (solo en registro) ─────────────────────
                    if (!_modoLogin) ...[
                      TextFormField(
                        controller: _nombreCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        textCapitalization: TextCapitalization.words,
                        validator: (v) {
                          if (!_modoLogin && (v == null || v.trim().isEmpty)) {
                            return 'Ingresa tu nombre';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    // ── Campo: Email ─────────────────────────────────────────
                    TextFormField(
                      controller: _emailCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Ingresa tu email';
                        }
                        if (!v.contains('@')) {
                          return 'El email no es válido';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // ── Campo: Contraseña ────────────────────────────────────
                    TextFormField(
                      controller: _passwordCtrl,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _verPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () =>
                              setState(() => _verPassword = !_verPassword),
                        ),
                      ),
                      obscureText: !_verPassword,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Ingresa tu contraseña';
                        }
                        if (v.length < 6) {
                          return 'Mínimo 6 caracteres';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    // ── Botón principal ──────────────────────────────────────
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: cargando ? null : _submit,
                        child: cargando
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colorScheme.onPrimary,
                                ),
                              )
                            : Text(
                                _modoLogin ? 'Entrar' : 'Crear cuenta',
                                style: const TextStyle(fontSize: 16),
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Cambiar entre login y registro ───────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _modoLogin
                              ? '¿No tienes cuenta?'
                              : '¿Ya tienes cuenta?',
                          style: textTheme.bodyMedium,
                        ),
                        TextButton(
                          onPressed: cargando
                              ? null
                              : () => setState(
                                    () => _modoLogin = !_modoLogin,
                                  ),
                          child: Text(
                            _modoLogin ? 'Crear cuenta' : 'Iniciar sesión',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Valida el formulario y llama al cubit correspondiente
  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<AuthCubit>();

    if (_modoLogin) {
      cubit.signInWithEmail(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );
    } else {
      cubit.signUpWithEmail(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
        nombre: _nombreCtrl.text.trim(),
      );
    }
  }
}
