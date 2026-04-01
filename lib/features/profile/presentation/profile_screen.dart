import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glint/features/auth/presentation/auth_cubit.dart';
import 'package:glint/features/auth/presentation/auth_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final authState = context.watch<AuthCubit>().state;

    final email = authState is AuthAuthenticated
        ? authState.user.email ?? ''
        : '';
    final nombre = authState is AuthAuthenticated
        ? (authState.user.userMetadata?['nombre'] as String? ?? 'Usuario')
        : 'Usuario';
    final iniciales = nombre.isNotEmpty
        ? nombre.trim().split(' ').map((p) => p[0]).take(2).join().toUpperCase()
        : 'U';

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Avatar + nombre
          Center(
            child: Column(
              children: [
                const SizedBox(height: 16),
                CircleAvatar(
                  radius: 48,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Text(
                    iniciales,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  nombre,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withAlpha(153),
                      ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),

          // Sección cuenta
          _SectionHeader(title: 'Cuenta'),
          _ProfileTile(
            icon: Icons.person_outline,
            title: 'Nombre',
            subtitle: nombre,
          ),
          _ProfileTile(
            icon: Icons.email_outlined,
            title: 'Email',
            subtitle: email,
          ),

          const SizedBox(height: 24),

          // Sección app
          _SectionHeader(title: 'Aplicación'),
          _ProfileTile(
            icon: Icons.info_outline,
            title: 'Versión',
            subtitle: '1.0.0',
          ),
          _ProfileTile(
            icon: Icons.dark_mode_outlined,
            title: 'Tema',
            subtitle: 'Sistema (automático)',
          ),

          const SizedBox(height: 32),

          // Botón cerrar sesión
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: colorScheme.error,
              side: BorderSide(color: colorScheme.error),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            icon: const Icon(Icons.logout),
            label: const Text('Cerrar sesión'),
            onPressed: () => _confirmarCerrarSesion(context),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
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
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthCubit>().signOut();
            },
            child: Text(
              'Cerrar sesión',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 0, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
