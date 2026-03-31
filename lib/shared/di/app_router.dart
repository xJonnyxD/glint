import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:glint/core/constants/app_constants.dart';
import 'package:glint/features/auth/presentation/auth_cubit.dart';
import 'package:glint/features/auth/presentation/auth_screen.dart';
import 'package:glint/features/auth/presentation/auth_state.dart';
import 'package:glint/shared/widgets/placeholder_screen.dart';

/// Router principal de Glint usando GoRouter
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  routes: [
    // ── Splash ───────────────────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),

    // ── Auth ─────────────────────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.auth,
      builder: (context, state) => const AuthScreen(),
    ),

    // ── Home con Shell (bottom nav) ───────────────────────────────────────────
    ShellRoute(
      builder: (context, state, child) => HomeShell(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.routines,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Rutinas'),
        ),
        GoRoute(
          path: AppRoutes.habits,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Hábitos'),
        ),
        GoRoute(
          path: AppRoutes.finance,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Finanzas'),
        ),
        GoRoute(
          path: AppRoutes.agenda,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Agenda'),
        ),
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Perfil'),
        ),
      ],
    ),

    // ── Configuración ─────────────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) =>
          const PlaceholderScreen(title: 'Configuración'),
    ),
  ],

  // Redirección global basada en el estado de autenticación
  redirect: (context, state) {
    final authState = context.read<AuthCubit>().state;
    final enSplash  = state.matchedLocation == AppRoutes.splash;
    final enAuth    = state.matchedLocation.startsWith(AppRoutes.auth);

    // Mientras carga o es estado inicial, no redirigir (splash se encarga)
    if (authState is AuthInitial || authState is AuthLoading) return null;

    final autenticado = authState is AuthAuthenticated;

    // Si no está autenticado y no está en auth ni en splash → ir a login
    if (!autenticado && !enAuth && !enSplash) return AppRoutes.auth;

    // Si está autenticado y está en auth → ir a home
    if (autenticado && enAuth) return AppRoutes.routines;

    return null;
  },

  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Ruta no encontrada: ${state.error}'),
    ),
  ),
);

/// Scaffold con NavigationBar (bottom nav) para la sección principal
class HomeShell extends StatelessWidget {
  final Widget child;

  const HomeShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex(location),
        onDestinationSelected: (index) => _onTap(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.wb_sunny_outlined),
            selectedIcon: Icon(Icons.wb_sunny),
            label: 'Rutinas',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Hábitos',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Finanzas',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Agenda',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  int _selectedIndex(String location) {
    if (location.startsWith(AppRoutes.routines)) return 0;
    if (location.startsWith(AppRoutes.habits))   return 1;
    if (location.startsWith(AppRoutes.finance))  return 2;
    if (location.startsWith(AppRoutes.agenda))   return 3;
    return 4;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0: context.go(AppRoutes.routines); break;
      case 1: context.go(AppRoutes.habits);   break;
      case 2: context.go(AppRoutes.finance);  break;
      case 3: context.go(AppRoutes.agenda);   break;
      case 4: context.go(AppRoutes.profile);  break;
    }
  }
}

/// Pantalla de splash — verifica sesión y redirige
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Esperar a que el AuthCubit determine el estado de sesión
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      final authState = context.read<AuthCubit>().state;
      if (authState is AuthAuthenticated) {
        context.go(AppRoutes.routines);
      } else {
        context.go(AppRoutes.auth);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.auto_awesome,
                size: 48,
                color: colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Glint',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tu vida, organizada',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withAlpha(153),
                  ),
            ),
            const SizedBox(height: 48),
            CircularProgressIndicator(
              color: colorScheme.primary,
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}
