import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:glint/core/constants/app_constants.dart';
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
  bool _modoReset = false; // modo recuperar contraseña

  // Controladores de texto para los campos del formulario
  final _emailCtrl     = TextEditingController();
  final _passwordCtrl  = TextEditingController();
  final _nombresCtrl   = TextEditingController(); // Nombres (registro)
  final _apellidosCtrl = TextEditingController(); // Apellidos (registro)
  final _telefonoCtrl  = TextEditingController(); // Teléfono (registro)

  // Fecha de nacimiento seleccionada (registro)
  DateTime? _fechaNacimiento;

  // Clave para validar el formulario
  final _formKey = GlobalKey<FormState>();

  // Controla si la contraseña se ve o está oculta
  bool _verPassword = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nombresCtrl.dispose();
    _apellidosCtrl.dispose();
    _telefonoCtrl.dispose();
    super.dispose();
  }

  /// Abre el selector de fecha de nacimiento
  Future<void> _seleccionarFechaNacimiento() async {
    final hoy = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaNacimiento ?? DateTime(hoy.year - 18, hoy.month, hoy.day),
      firstDate: DateTime(1920),
      lastDate: DateTime(hoy.year - 10, hoy.month, hoy.day),
      helpText: 'Fecha de nacimiento',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
    );
    if (picked != null) {
      setState(() => _fechaNacimiento = picked);
    }
  }

  String _formatFecha(DateTime fecha) {
    final meses = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
    ];
    return '${fecha.day} de ${meses[fecha.month - 1]} de ${fecha.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme   = Theme.of(context).textTheme;

    return Scaffold(
      body: BlocConsumer<AuthCubit, GlintAuthState>(
        // BlocConsumer escucha cambios de estado y reacciona
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Login exitoso — navegar al home
            context.go(AppRoutes.routines);
            return;
          }
          if (state is AuthError) {
            // Mostrar mensaje de error en un snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: colorScheme.error,
              ),
            );
          }
          if (state is AuthUnauthenticated && !_modoLogin && !_modoReset) {
            // Registro exitoso → volver a login
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('¡Cuenta creada! Revisa tu email para confirmarla.'),
                backgroundColor: Colors.green,
              ),
            );
            setState(() => _modoLogin = true);
          }
          if (state is AuthUnauthenticated && _modoReset) {
            // Reset exitoso → mostrar confirmación
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ Revisa tu email para restablecer tu contraseña.'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 4),
              ),
            );
            setState(() { _modoReset = false; _modoLogin = true; });
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
                      _modoReset
                          ? 'Recuperar contraseña'
                          : (_modoLogin ? 'Iniciar sesión' : 'Crear cuenta'),
                      style: textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _modoReset
                          ? 'Te enviaremos un enlace para restablecer tu contraseña'
                          : (_modoLogin
                              ? 'Bienvenido de vuelta'
                              : 'Empieza tu journey con Glint'),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withAlpha(153),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Campos solo en registro ──────────────────────────────
                    if (!_modoLogin && !_modoReset) ...[
                      // Nombres
                      TextFormField(
                        controller: _nombresCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Nombres',
                          hintText: 'ej: Juan Carlos',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        textCapitalization: TextCapitalization.words,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Ingresa tus nombres'
                            : null,
                      ),
                      const SizedBox(height: 14),

                      // Apellidos
                      TextFormField(
                        controller: _apellidosCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Apellidos',
                          hintText: 'ej: Martínez López',
                          prefixIcon: Icon(Icons.badge_outlined),
                        ),
                        textCapitalization: TextCapitalization.words,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Ingresa tus apellidos'
                            : null,
                      ),
                      const SizedBox(height: 14),

                      // Teléfono
                      TextFormField(
                        controller: _telefonoCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Teléfono',
                          hintText: 'ej: 7777-1234',
                          prefixIcon: Icon(Icons.phone_outlined),
                          prefixText: '+503 ',
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Ingresa tu número de teléfono';
                          }
                          final digits = v.replaceAll(RegExp(r'\D'), '');
                          if (digits.length < 7) {
                            return 'Número de teléfono inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Fecha de nacimiento
                      GestureDetector(
                        onTap: _seleccionarFechaNacimiento,
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Fecha de nacimiento',
                              hintText: 'Toca para seleccionar',
                              prefixIcon: const Icon(Icons.cake_outlined),
                              suffixIcon: const Icon(Icons.calendar_today_outlined),
                              filled: true,
                            ),
                            controller: TextEditingController(
                              text: _fechaNacimiento != null
                                  ? _formatFecha(_fechaNacimiento!)
                                  : '',
                            ),
                            validator: (_) => _fechaNacimiento == null
                                ? 'Selecciona tu fecha de nacimiento'
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
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

                    // ── Campo: Contraseña (oculto en modo reset) ─────────────
                    if (!_modoReset) ...[
                      const SizedBox(height: 16),
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
                          if (_modoReset) return null; // no validar en reset
                          if (v == null || v.isEmpty) {
                            return 'Ingresa tu contraseña';
                          }
                          if (v.length < 6) {
                            return 'Mínimo 6 caracteres';
                          }
                          return null;
                        },
                      ),
                    ],

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
                                _modoReset
                                    ? 'Enviar instrucciones'
                                    : (_modoLogin ? 'Entrar' : 'Crear cuenta'),
                                style: const TextStyle(fontSize: 16),
                              ),
                      ),
                    ),

                    // ── Botón OAuth Google — solo en login ───────────────────
                    if (_modoLogin && !_modoReset) ...[
                      const SizedBox(height: 16),
                      const Row(children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'o continúa con',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                        Expanded(child: Divider()),
                      ]),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: const Text(
                            'G',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.red,
                            ),
                          ),
                          label: const Text('Continuar con Google'),
                          onPressed: cargando
                              ? null
                              : () => context.read<AuthCubit>().signInWithGoogle(),
                        ),
                      ),
                    ],

                    // ── Olvidé mi contraseña (solo en login) ─────────────────
                    if (_modoLogin && !_modoReset)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: cargando
                              ? null
                              : () => setState(() => _modoReset = true),
                          child: const Text('¿Olvidaste tu contraseña?'),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // ── Cambiar entre login y registro ───────────────────────
                    if (!_modoReset)
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

                    // ── Volver al login desde reset ──────────────────────────
                    if (_modoReset)
                      Center(
                        child: TextButton.icon(
                          onPressed: cargando
                              ? null
                              : () => setState(() => _modoReset = false),
                          icon: const Icon(Icons.arrow_back, size: 16),
                          label: const Text('Volver al inicio de sesión'),
                        ),
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

    if (_modoReset) {
      cubit.resetPassword(email: _emailCtrl.text.trim());
      return;
    }

    if (_modoLogin) {
      cubit.signInWithEmail(
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
      );
    } else {
      cubit.signUpWithEmail(
        email:           _emailCtrl.text.trim(),
        password:        _passwordCtrl.text,
        nombres:         _nombresCtrl.text.trim(),
        apellidos:       _apellidosCtrl.text.trim(),
        telefono:        _telefonoCtrl.text.trim(),
        fechaNacimiento: _fechaNacimiento,
      );
    }
  }
}
