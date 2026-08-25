import 'package:flutter/material.dart';
import 'package:glint/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:glint/core/icons/app_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:glint/core/theme/theme_cubit.dart';
import 'package:glint/features/auth/presentation/auth_cubit.dart';
import 'package:glint/features/auth/presentation/auth_state.dart';
import 'package:glint/core/constants/app_constants.dart';
import 'package:glint/features/gamification/presentation/gamification_cubit.dart';
import 'package:glint/features/habits/presentation/habit_cubit.dart';
import 'package:glint/features/habits/presentation/habit_state.dart';
import 'package:glint/features/finance/presentation/finance_cubit.dart';
import 'package:glint/features/finance/presentation/finance_state.dart';
import 'package:glint/features/routines/presentation/routine_cubit.dart';
import 'package:glint/features/routines/presentation/routine_state.dart';
import 'package:glint/features/profile/domain/profile_entity.dart';
import 'package:glint/features/profile/presentation/profile_cubit.dart';
import 'package:glint/features/profile/presentation/profile_state.dart';
import 'package:glint/shared/services/biometric_service.dart';
import 'package:glint/shared/widgets/avatar_glint.dart';
import 'package:glint/shared/widgets/skeleton_lista.dart';

/// Opción del menú de la foto de perfil. Es un enum (y no `ImageSource?`) para
/// poder distinguir "eliminar" de "cerrar el menú": antes ambos devolvían
/// `null`, así que descartar el menú tocando fuera borraba la foto sin querer.
enum _AccionFoto { camara, galeria, eliminar }

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _cambiarFoto(ProfileEntity perfil) async {
    final accion = await showModalBottomSheet<_AccionFoto>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Tomar foto'),
              onTap: () => Navigator.pop(ctx, _AccionFoto.camara),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Elegir de galería'),
              onTap: () => Navigator.pop(ctx, _AccionFoto.galeria),
            ),
            if (perfil.tieneAvatar)
              ListTile(
                leading: Icon(Icons.delete_outline,
                    color: Theme.of(ctx).colorScheme.error),
                title: Text('Eliminar foto',
                    style: TextStyle(color: Theme.of(ctx).colorScheme.error)),
                onTap: () => Navigator.pop(ctx, _AccionFoto.eliminar),
              ),
          ],
        ),
      ),
    );
    // Cerrar el menú (tocar fuera o atrás) devuelve null y NO hace nada: tocar
    // la foto no debe borrarla, solo cambiarla o —si se elige— eliminarla.
    if (!mounted || accion == null) return;

    if (accion == _AccionFoto.eliminar) {
      await context.read<ProfileCubit>().eliminarFoto();
      return;
    }

    final picked = await ImagePicker().pickImage(
      source:
          accion == _AccionFoto.camara ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;

    // readAsBytes (y no `picked.path`) es lo que hace que esto funcione
    // también en el navegador: allí no hay sistema de archivos que valga.
    final bytes = await picked.readAsBytes();
    if (!mounted) return;
    await context.read<ProfileCubit>().cambiarFoto(bytes);
  }

  Future<void> _editarBio(ProfileEntity perfil) async {
    final ctrl = TextEditingController(text: perfil.bio ?? '');
    final nuevo = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tu estado'),
        content: TextField(
          controller: ctrl,
          maxLength: 200,
          maxLines: 3,
          minLines: 1,
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
    if (nuevo == null || !mounted) return;
    await context.read<ProfileCubit>().actualizarCampos(
          bio: nuevo.isEmpty ? null : nuevo,
          limpiarBio: nuevo.isEmpty,
        );
  }

  Future<void> _editarFechaNacimiento(ProfileEntity perfil) async {
    final hoy = DateTime.now();
    final elegida = await showDatePicker(
      context: context,
      initialDate: perfil.fechaNacimiento ?? DateTime(hoy.year - 25),
      firstDate: DateTime(1900, 1, 2),
      // No se puede haber nacido mañana. En la BD el CHECK solo acota el rango
      // (Postgres no admite current_date en un constraint), así que el límite
      // real de "no futura" se pone aquí.
      lastDate: hoy,
      helpText: 'Tu fecha de nacimiento',
    );
    if (elegida == null || !mounted) return;
    await context.read<ProfileCubit>().actualizarCampos(
          fechaNacimiento: elegida,
        );
  }

  /// Diálogo genérico para editar un campo de texto del perfil.
  Future<void> _editarTexto(
    ProfileEntity perfil, {
    required String titulo,
    required String valorActual,
    required Future<void> Function(String) alGuardar,
    TextInputType? teclado,
  }) async {
    final ctrl = TextEditingController(text: valorActual);
    final nuevo = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(titulo),
        content: TextField(
          controller: ctrl,
          keyboardType: teclado,
          autofocus: true,
          maxLength: 80,
          decoration: const InputDecoration(border: OutlineInputBorder()),
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
    if (nuevo == null || !mounted) return;
    await alGuardar(nuevo);
  }

  static String _formatearFecha(DateTime f) =>
      '${f.day.toString().padLeft(2, '0')}/'
      '${f.month.toString().padLeft(2, '0')}/${f.year}';

  Future<void> _editarVisibilidad(ProfileEntity perfil) async {
    final elegida = await showModalBottomSheet<VisibilidadPerfil>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text('¿Quién puede encontrarte?',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            ),
            for (final v in VisibilidadPerfil.values)
              ListTile(
                leading: Icon(
                  v == perfil.visibilidad
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: v == perfil.visibilidad
                      ? Theme.of(ctx).colorScheme.primary
                      : null,
                ),
                title: Text(v.etiqueta),
                subtitle: Text(v.descripcion),
                onTap: () => Navigator.pop(ctx, v),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (elegida == null || !mounted) return;
    await context.read<ProfileCubit>().actualizarCampos(visibilidad: elegida);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final authState   = context.watch<AuthCubit>().state;
    final themeState  = context.watch<ThemeCubit>().state;

    final emailAuth =
        authState is AuthAuthenticated ? authState.user.email ?? '' : '';

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, profileState) {
        if (profileState is! ProfileLoaded) {
          return const Scaffold(body: SkeletonLista());
        }
        final perfil = profileState.perfil;
        final email = perfil.email.isNotEmpty ? perfil.email : emailAuth;

        return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
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
                      perfil: perfil,
                      email: email,
                      subiendoFoto: profileState.subiendoFoto,
                      onCambiarFoto: () => _cambiarFoto(perfil),
                      onEditarEstado: () => _editarBio(perfil),
                    ),
                  ),
                ),

                SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 16),

                    // ── SECCIÓN: ESTADÍSTICAS PERSONALES ──────────────────
                    _SectionHeader(title: 'Mi resumen'),
                    _EstadisticasPersonales(),
                    const SizedBox(height: 24),

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
                    // Todos los campos son editables aunque estén vacíos: antes
                    // un campo sin valor ni siquiera se mostraba, así que no
                    // había forma de rellenarlo.
                    _ProfileTile(
                      icon: Icons.person_outline,
                      title: 'Nombres',
                      subtitle: perfil.nombres ?? 'Sin definir',
                      onTap: () => _editarTexto(
                        perfil,
                        titulo: 'Editar nombres',
                        valorActual: perfil.nombres ?? '',
                        alGuardar: (v) => context
                            .read<ProfileCubit>()
                            .actualizarCampos(nombres: v),
                      ),
                    ),
                    _ProfileTile(
                      icon: Icons.badge_outlined,
                      title: 'Apellidos',
                      subtitle: perfil.apellidos ?? 'Sin definir',
                      onTap: () => _editarTexto(
                        perfil,
                        titulo: 'Editar apellidos',
                        valorActual: perfil.apellidos ?? '',
                        alGuardar: (v) => context
                            .read<ProfileCubit>()
                            .actualizarCampos(apellidos: v),
                      ),
                    ),
                    _ProfileTile(
                      icon: Icons.email_outlined,
                      title: 'Email',
                      subtitle: email,
                    ),
                    _ProfileTile(
                      icon: Icons.phone_outlined,
                      title: 'Teléfono',
                      subtitle: perfil.telefono ?? 'Sin definir',
                      onTap: () => _editarTexto(
                        perfil,
                        titulo: 'Editar teléfono',
                        valorActual: perfil.telefono ?? '',
                        teclado: TextInputType.phone,
                        alGuardar: (v) => context
                            .read<ProfileCubit>()
                            .actualizarCampos(
                              telefono: v.isEmpty ? null : v,
                              limpiarTelefono: v.isEmpty,
                            ),
                      ),
                    ),
                    _ProfileTile(
                      icon: Icons.cake_outlined,
                      title: 'Fecha de nacimiento',
                      subtitle: perfil.fechaNacimiento == null
                          ? 'Sin definir'
                          : _formatearFecha(perfil.fechaNacimiento!) +
                              (perfil.edad != null
                                  ? '  ·  ${perfil.edad} años'
                                  : ''),
                      onTap: () => _editarFechaNacimiento(perfil),
                    ),
                    _ProfileTile(
                      icon: Icons.visibility_outlined,
                      title: 'Quién puede encontrarme',
                      subtitle: perfil.visibilidad.etiqueta,
                      onTap: () => _editarVisibilidad(perfil),
                    ),
                    const SizedBox(height: 24),

                    // ── SECCIÓN: SEGURIDAD ────────────────────────────────
                    _SectionHeader(title: 'Seguridad'),
                    _BiometricTile(),
                    const SizedBox(height: 24),

                    // ── SECCIÓN: GAMIFICACIÓN ─────────────────────────────
                    _SectionHeader(title: 'Gamificación'),
                    Builder(builder: (context) {
                      try {
                        return BlocBuilder<GamificationCubit, GamificationState>(
                          builder: (context, gamState) => Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                            child: Card(
                              child: ListTile(
                                leading: Icon(gamState.iconoNivel, size: 28),
                                title: Text(gamState.nivel,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                subtitle: Text(
                                    '${gamState.xpTotal} XP acumulados'),
                                trailing: FilledButton.tonal(
                                  onPressed: () =>
                                      context.push(AppRoutes.gamification),
                                  child: const Text('Ver logros'),
                                ),
                              ),
                            ),
                          ),
                        );
                      } catch (_) {
                        return const SizedBox.shrink();
                      }
                    }),
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
      },
    );
  }

  /// Abre un diálogo para editar un campo del perfil y lo actualiza en Supabase
  // ignore: unused_element
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
          content: Text('Perfil actualizado'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: const Text('Error al actualizar. Intenta de nuevo.'),
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
  final ProfileEntity perfil;
  final String email;
  final bool subiendoFoto;
  final VoidCallback onCambiarFoto;
  final VoidCallback onEditarEstado;

  const _HeaderPerfil({
    required this.perfil,
    required this.email,
    required this.subiendoFoto,
    required this.onCambiarFoto,
    required this.onEditarEstado,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.cabeceraDe(colorScheme.primary),
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
                  AvatarGlint(
                    radio: 52,
                    bytesLocales: perfil.avatarBytes,
                    url: perfil.avatarUrl,
                    nombre: perfil.nombreCompleto,
                    seed: perfil.id,
                    colorFondo: Colors.white24,
                    colorTexto: Colors.white,
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
                      child: subiendoFoto
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.primary,
                              ),
                            )
                          : Icon(Icons.camera_alt,
                              size: 16, color: colorScheme.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Nombre
            Text(perfil.nombreCompleto,
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
                    Text(
                        (perfil.bio ?? '').trim().isEmpty
                            ? 'Añade tu estado'
                            : perfil.bio!,
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

// ── Estadísticas personales ───────────────────────────────────────────────────

class _EstadisticasPersonales extends StatelessWidget {
  const _EstadisticasPersonales();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: BlocBuilder<HabitCubit, HabitState>(
                  builder: (context, state) {
                    final racha = state is HabitLoaded && state.habitos.isNotEmpty
                        ? state.habitos.map((h) => h.rachaActual).reduce((a, b) => a > b ? a : b)
                        : 0;
                    return _StatCard(
                      icono: AppIcons.streak,
                      valor: '$racha',
                      label: 'Mejor racha',
                      color: Colors.orange.shade600,
                      bgColor: Colors.orange.shade50,
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BlocBuilder<HabitCubit, HabitState>(
                  builder: (context, state) {
                    final total = state is HabitLoaded
                        ? state.habitos.fold<int>(0, (s, h) => s + h.totalCompletados)
                        : 0;
                    return _StatCard(
                      icono: AppIcons.check,
                      valor: '$total',
                      label: 'Hábitos hechos',
                      color: Colors.green.shade600,
                      bgColor: Colors.green.shade50,
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: BlocBuilder<FinanceCubit, FinanceState>(
                  builder: (context, state) {
                    final balance = state is FinanceLoaded ? state.balance : 0.0;
                    final positivo = balance >= 0;
                    return _StatCard(
                      icono: positivo ? AppIcons.money : AppIcons.warning,
                      valor: '\$${balance.abs().toStringAsFixed(0)}',
                      label: positivo ? 'Balance mes' : 'Déficit mes',
                      color: positivo ? Colors.teal.shade600 : Colors.red.shade600,
                      bgColor: positivo ? Colors.teal.shade50 : Colors.red.shade50,
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: BlocBuilder<RoutineCubit, RoutineState>(
                  builder: (context, state) {
                    final completadas = state is RoutineLoaded
                        ? state.completadasHoy
                        : 0;
                    final total = state is RoutineLoaded
                        ? state.rutinas.length
                        : 0;
                    return _StatCard(
                      icono: AppIcons.routines,
                      valor: '$completadas/$total',
                      label: 'Rutinas hoy',
                      color: colorScheme.primary,
                      bgColor: colorScheme.primaryContainer.withValues(alpha: 0.4),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icono;
  final String valor;
  final String label;
  final Color color;
  final Color bgColor;

  const _StatCard({
    required this.icono,
    required this.valor,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icono, size: 26, color: color),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                valor,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: color.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
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
      // Al activar, comprobar que de verdad funciona en este dispositivo: no
      // tiene sentido dejarlo activado para descubrir al reiniciar que no va.
      final resultado = await BiometricService.autenticar(
        motivo: 'Confirma tu identidad para activar el desbloqueo',
      );
      if (resultado != ResultadoBiometrico.exito) {
        if (mounted) {
          final mensaje = resultado.mensaje;
          if (mensaje != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(mensaje),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          // Devolver el interruptor a su sitio.
          setState(() => _habilitado = false);
        }
        return;
      }
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
