import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:glint/core/theme/theme_cubit.dart';
import 'package:glint/features/auth/presentation/auth_cubit.dart';
import 'package:glint/features/auth/presentation/auth_state.dart';
import 'package:glint/features/profile/data/profile_settings.dart';
import 'package:glint/shared/services/biometric_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _fotoPath;
  String _estado = '✨ Viviendo al máximo';
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final foto   = await ProfileSettings.getFoto();
    final estado = await ProfileSettings.getEstado();
    if (mounted) {
      setState(() {
        _fotoPath = foto;
        _estado   = estado;
        _cargando = false;
      });
    }
  }

  Future<void> _cambiarFoto() async {
    final opcion = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Tomar foto'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Elegir de galería'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            if (_fotoPath != null)
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Eliminar foto'),
                onTap: () => Navigator.pop(ctx, null),
              ),
          ],
        ),
      ),
    );

    if (opcion == null && _fotoPath != null) {
      await ProfileSettings.setFoto('');
      setState(() => _fotoPath = null);
      return;
    }
    if (opcion == null) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: opcion,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (picked != null) {
      await ProfileSettings.setFoto(picked.path);
      setState(() => _fotoPath = picked.path);
    }
  }

  Future<void> _editarEstado() async {
    final ctrl = TextEditingController(text: _estado);
    final nuevo = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tu estado'),
        content: TextField(
          controller: ctrl,
          maxLength: 80,
          decoration: const InputDecoration(
            hintText: '¿Qué estás pensando hoy?',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (nuevo != null && nuevo.isNotEmpty) {
      await ProfileSettings.setEstado(nuevo);
      setState(() => _estado = nuevo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final authState   = context.watch<AuthCubit>().state;
    final themeState  = context.watch<ThemeCubit>().state;

    final email     = authState is AuthAuthenticated ? authState.user.email ?? '' : '';
    final meta      = authState is AuthAuthenticated ? (authState.user.userMetadata ?? {}) : <String, dynamic>{};
    final nombres   = meta['nombres']   as String? ?? '';
    final apellidos = meta['apellidos'] as String? ?? '';
    final telefono  = meta['telefono']  as String? ?? '';
    final fechaNac  = meta['fecha_nacimiento'] as String? ?? '';
    final nombre = meta['nombre'] as String?
        ?? (nombres.isNotEmpty ? '$nombres $apellidos'.trim() : 'Usuario');
    final iniciales = nombre.trim().split(' ').map((p) => p.isNotEmpty ? p[0] : '').take(2).join().toUpperCase();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                // ── Header con foto ────────────────────────────────────────
                SliverAppBar(
                  expandedHeight: 260,
                  pinned: true,
                  backgroundColor: colorScheme.primary,
                  title: const Text('Mi Perfil',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  flexibleSpace: FlexibleSpaceBar(
                    background: _HeaderPerfil(
                      nombre: nombre,
                      email: email,
                      iniciales: iniciales,
                      fotoPath: _fotoPath,
                      estado: _estado,
                      onCambiarFoto: _cambiarFoto,
                      onEditarEstado: _editarEstado,
                    ),
                  ),
                ),

                SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 16),

                    // ── SECCIÓN: PERSONALIZACIÓN ───────────────────────────
                    _SectionHeader(title: 'Personalización'),

                    // Tema claro / oscuro / sistema
                    _TemaSelector(modoActual: themeState.modo),
                    const SizedBox(height: 8),

                    // Color de acento
                    _ColorAcentoSelector(colorActual: themeState.colorAcento),
                    const SizedBox(height: 24),

                    // ── SECCIÓN: CUENTA ────────────────────────────────────
                    _SectionHeader(title: 'Cuenta'),
                    _ProfileTile(
                      icon: Icons.person_outline,
                      title: 'Nombres',
                      subtitle: nombres.isNotEmpty ? nombres : nombre,
                      onTap: () => _editarCampo(
                        context,
                        campo: 'nombres',
                        titulo: 'Editar nombres',
                        valorActual: nombres.isNotEmpty ? nombres : nombre,
                        metaKey: 'nombres',
                      ),
                    ),
                    if (apellidos.isNotEmpty)
                      _ProfileTile(
                        icon: Icons.badge_outlined,
                        title: 'Apellidos',
                        subtitle: apellidos,
                        onTap: () => _editarCampo(
                          context,
                          campo: 'apellidos',
                          titulo: 'Editar apellidos',
                          valorActual: apellidos,
                          metaKey: 'apellidos',
                        ),
                      ),
                    _ProfileTile(
                      icon: Icons.email_outlined,
                      title: 'Email',
                      subtitle: email,
                    ),
                    if (telefono.isNotEmpty)
                      _ProfileTile(
                        icon: Icons.phone_outlined,
                        title: 'Teléfono',
                        subtitle: '+503 $telefono',
                        onTap: () => _editarCampo(
                          context,
                          campo: 'telefono',
                          titulo: 'Editar teléfono',
                          valorActual: telefono,
                          metaKey: 'telefono',
                          teclado: TextInputType.phone,
                        ),
                      ),
                    if (fechaNac.isNotEmpty)
                      _ProfileTile(
                        icon: Icons.cake_outlined,
                        title: 'Fecha de nacimiento',
                        subtitle: fechaNac,
                      ),
                    const SizedBox(height: 24),

                    // ── SECCIÓN: SEGURIDAD ────────────────────────────────
                    _SectionHeader(title: 'Seguridad'),
                    _BiometricTile(),
                    const SizedBox(height: 24),

                    // ── SECCIÓN: APP ───────────────────────────────────────
                    _SectionHeader(title: 'Aplicación'),
                    _ProfileTile(
                      icon: Icons.info_outline,
                      title: 'Versión',
                      subtitle: '1.0.0 — Glint MVP',
                    ),
                    _ProfileTile(
                      icon: Icons.storage_outlined,
                      title: 'Datos',
                      subtitle: 'Almacenados localmente en tu dispositivo',
                    ),
                    const SizedBox(height: 32),

                    // ── Botón cerrar sesión ────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colorScheme.error,
                          side: BorderSide(color: colorScheme.error),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        icon: const Icon(Icons.logout),
                        label: const Text('Cerrar sesión',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        onPressed: () => _confirmarCerrarSesion(context),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ]),
                ),
              ],
            ),
    );
  }

  /// Abre un diálogo para editar un campo del perfil y lo actualiza en Supabase
  Future<void> _editarCampo(
    BuildContext context, {
    required String campo,
    required String titulo,
    required String valorActual,
    required String metaKey,
    TextInputType teclado = TextInputType.text,
  }) async {
    // Capturar referencias al contexto ANTES del primer await
    final authCubit    = context.read<AuthCubit>();
    final messenger    = ScaffoldMessenger.of(context);
    final colorError   = Theme.of(context).colorScheme.error;

    final ctrl = TextEditingController(text: valorActual);
    final nuevo = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(titulo),
        content: TextField(
          controller: ctrl,
          keyboardType: teclado,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Nuevo $campo',
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (nuevo == null || nuevo.isEmpty || nuevo == valorActual) return;
    if (!mounted) return;

    try {
      // Actualizar metadatos en Supabase
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(data: {metaKey: nuevo}),
      );
      // Refrescar el estado del cubit
      await authCubit.refreshUser();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('✅ Perfil actualizado'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: const Text('❌ Error al actualizar. Intenta de nuevo.'),
          backgroundColor: colorError,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _confirmarCerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Seguro que deseas cerrar sesión?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthCubit>().signOut();
            },
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
}

// ── Header con foto de perfil ─────────────────────────────────────────────────

class _HeaderPerfil extends StatelessWidget {
  final String nombre;
  final String email;
  final String iniciales;
  final String? fotoPath;
  final String estado;
  final VoidCallback onCambiarFoto;
  final VoidCallback onEditarEstado;

  const _HeaderPerfil({
    required this.nombre,
    required this.email,
    required this.iniciales,
    required this.fotoPath,
    required this.estado,
    required this.onCambiarFoto,
    required this.onEditarEstado,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.primary, colorScheme.primary.withAlpha(200)],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            // Foto de perfil con botón de edición
            GestureDetector(
              onTap: onCambiarFoto,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundColor: Colors.white24,
                    backgroundImage: fotoPath != null && fotoPath!.isNotEmpty
                        ? FileImage(File(fotoPath!))
                        : null,
                    child: fotoPath == null || fotoPath!.isEmpty
                        ? Text(
                            iniciales,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.camera_alt,
                          size: 16, color: colorScheme.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Nombre
            Text(nombre,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),

            // Email
            Text(email,
                style: const TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 10),

            // Estado / pensamiento — toca para editar
            GestureDetector(
              onTap: onEditarEstado,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(30),
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: Colors.white.withAlpha(60)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(estado,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 13)),
                    const SizedBox(width: 6),
                    const Icon(Icons.edit, size: 12, color: Colors.white70),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Selector de tema ──────────────────────────────────────────────────────────

class _TemaSelector extends StatelessWidget {
  final ThemeMode modoActual;
  const _TemaSelector({required this.modoActual});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.brightness_6_outlined,
                      color: colorScheme.primary, size: 20),
                  const SizedBox(width: 8),
                  Text('Tema',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 12),
              SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(
                      value: ThemeMode.light,
                      label: Text('Claro'),
                      icon: Icon(Icons.light_mode_outlined)),
                  ButtonSegment(
                      value: ThemeMode.system,
                      label: Text('Auto'),
                      icon: Icon(Icons.brightness_auto_outlined)),
                  ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text('Oscuro'),
                      icon: Icon(Icons.dark_mode_outlined)),
                ],
                selected: {modoActual},
                onSelectionChanged: (sel) =>
                    context.read<ThemeCubit>().cambiarModo(sel.first),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Selector de color de acento ───────────────────────────────────────────────

class _ColorAcentoSelector extends StatelessWidget {
  final String colorActual;
  const _ColorAcentoSelector({required this.colorActual});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.palette_outlined,
                      color: colorScheme.primary, size: 20),
                  const SizedBox(width: 8),
                  Text('Color de la app',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: coloresAcento.map((c) {
                  final hex      = c['hex']!;
                  final nombre   = c['nombre']!;
                  final color    = _hexToColor(hex);
                  final selected = hex == colorActual;
                  return GestureDetector(
                    onTap: () =>
                        context.read<ThemeCubit>().cambiarColor(hex),
                    child: Tooltip(
                      message: nombre,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected
                                ? colorScheme.onSurface
                                : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                      color: color.withAlpha(120),
                                      blurRadius: 8)
                                ]
                              : [],
                        ),
                        child: selected
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 18)
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _hexToColor(String hex) {
    try {
      return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
    } catch (_) {
      return const Color(0xFF6750A4);
    }
  }
}

// ── Tiles de perfil ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 0, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Card(
        child: ListTile(
          leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
          title: Text(title),
          subtitle: Text(subtitle),
          trailing: onTap != null
              ? Icon(Icons.edit_outlined,
                  size: 18,
                  color: Theme.of(context).colorScheme.onSurfaceVariant)
              : null,
          onTap: onTap,
        ),
      ),
    );
  }
}

// ── Tile de biometría ─────────────────────────────────────────────────────────

class _BiometricTile extends StatefulWidget {
  @override
  State<_BiometricTile> createState() => _BiometricTileState();
}

class _BiometricTileState extends State<_BiometricTile> {
  bool _disponible = false;
  bool _habilitado = false;
  bool _cargando   = true;

  @override
  void initState() {
    super.initState();
    _cargarEstado();
  }

  Future<void> _cargarEstado() async {
    final disponible = await BiometricService.isAvailable();
    final habilitado = await BiometricService.isEnabled();
    if (mounted) {
      setState(() {
        _disponible = disponible;
        _habilitado = habilitado;
        _cargando   = false;
      });
    }
  }

  Future<void> _toggleBiometrico(bool nuevoValor) async {
    if (nuevoValor) {
      // Al activar, pedir autenticación biométrica primero
      final autenticado = await BiometricService.authenticate();
      if (!autenticado) return;
    }
    await BiometricService.setEnabled(nuevoValor);
    if (mounted) setState(() => _habilitado = nuevoValor);
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Card(
          child: ListTile(
            leading: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            title: Text('Biometría'),
            subtitle: Text('Verificando disponibilidad...'),
          ),
        ),
      );
    }

    if (!_disponible) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Card(
        child: SwitchListTile(
          secondary: Icon(
            Icons.fingerprint,
            color: _habilitado ? colorScheme.primary : colorScheme.onSurface.withAlpha(150),
          ),
          title: const Text('Desbloqueo biométrico'),
          subtitle: Text(
            _habilitado
                ? 'Activo — usa huella o Face ID para entrar'
                : 'Inactivo — usa contraseña al abrir la app',
          ),
          value: _habilitado,
          onChanged: _toggleBiometrico,
        ),
      ),
    );
  }
}
