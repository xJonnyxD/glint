import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:glint/core/constants/app_constants.dart';

// Pantallas temporales (se reemplazarán módulo a módulo)
import 'package:glint/shared/widgets/placeholder_screen.dart';

/// Router principal de Glint usando GoRouter
/// Shell route para la navegación principal con bottom nav
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
      builder: (context, state) =>
          const PlaceholderScreen(title: 'Autenticación'),
      routes: [
        GoRoute(
          path: 'login',
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Iniciar sesión'),
        ),
        GoRoute(
          path: 'register',
          builder: (context, state) =>
              const PlaceholderScreen(title: 'Crear cuenta'),
        ),
      ],
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

    // ── Configuración (fuera del shell) ───────────────────────────────────────
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) =>
          const PlaceholderScreen(title: 'Configuración'),
    ),
  ],

  // Redirección global: si no hay sesión activa, ir a auth
  redirect: (context, state) {
    // TODO: Verificar sesión de Supabase aquí
    // final isLoggedIn = Supabase.instance.client.auth.currentUser != null;
    // if (!isLoggedIn && !state.matchedLocation.startsWith('/auth')) {
    //   return AppRoutes.auth;
    // }
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
    return 4; // perfil
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

/// Pantalla de splash temporal
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navegar al home tras 2 segundos (luego se reemplaza con lógica real)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) context.go(AppRoutes.routines);
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
            // Logo placeholder — reemplazar con logo real
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
