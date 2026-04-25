import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:glint/core/constants/app_constants.dart';
import 'package:glint/features/auth/presentation/auth_cubit.dart';
import 'package:glint/features/auth/presentation/auth_screen.dart';
import 'package:glint/features/auth/presentation/auth_state.dart' show GlintAuthState, AuthInitial, AuthLoading, AuthAuthenticated, AuthUnauthenticated;
import 'package:glint/features/onboarding/onboarding_screen.dart';
import 'package:glint/shared/services/biometric_service.dart';
import 'package:glint/features/dashboard/presentation/dashboard_screen.dart';
import 'package:glint/features/routines/presentation/routines_screen.dart';
import 'package:glint/features/habits/presentation/habits_screen.dart';
import 'package:glint/features/finance/presentation/finance_screen.dart';
import 'package:glint/features/finance/presentation/salary_calculator_screen.dart';
import 'package:glint/features/finance/presentation/budget_screen.dart';
import 'package:glint/features/finance/presentation/savings_goal_screen.dart';
import 'package:glint/features/finance/presentation/debt_screen.dart';
import 'package:glint/features/finance/presentation/recurring_expense_screen.dart';
import 'package:glint/features/agenda/presentation/agenda_screen.dart';
import 'package:glint/features/notes/presentation/notes_screen.dart';
import 'package:glint/features/profile/presentation/profile_screen.dart';
import 'package:glint/features/settings/presentation/settings_screen.dart';
import 'package:glint/features/gamification/presentation/gamification_cubit.dart';
import 'package:glint/features/gamification/presentation/gamification_screen.dart';

/// Router principal de Glint usando GoRouter
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: kDebugMode,
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
          path: AppRoutes.dashboard,
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: AppRoutes.routines,
          builder: (context, state) => const RoutinesScreen(),
        ),
        GoRoute(
          path: AppRoutes.habits,
          builder: (context, state) => const HabitsScreen(),
        ),
        GoRoute(
          path: AppRoutes.finance,
          builder: (context, state) => const FinanceScreen(),
        ),
        GoRoute(
          path: AppRoutes.agenda,
          builder: (context, state) => const AgendaScreen(),
        ),
        GoRoute(
          path: AppRoutes.notes,
          builder: (context, state) => const NotesScreen(),
        ),
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),

    // ── Sub-pantallas de Finanzas (fuera del Shell para tener back nativo) ────
    GoRoute(
      path: AppRoutes.financeBudget,
      builder: (context, state) => const BudgetScreen(),
    ),
    GoRoute(
      path: AppRoutes.financeSavingsGoals,
      builder: (context, state) => const SavingsGoalScreen(),
    ),
    GoRoute(
      path: AppRoutes.financeDebts,
      builder: (context, state) => const DebtScreen(),
    ),
    GoRoute(
      path: AppRoutes.financeRecurring,
      builder: (context, state) => const RecurringExpenseScreen(),
    ),

    // ── Onboarding ────────────────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),

    // ── Calculadora de Salario SV ─────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.salaryCalculator,
      builder: (context, state) => const SalaryCalculatorScreen(),
    ),

    // ── Configuración ─────────────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),

    // ── Gamificación ──────────────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.gamification,
      builder: (context, state) => BlocProvider(
        create: (_) => GamificationCubit(),
        child: const GamificationScreen(),
      ),
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

    // Si está autenticado y está en auth → ir a dashboard
    if (autenticado && enAuth) return AppRoutes.dashboard;

    return null;
  },

  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Ruta no encontrada: ${state.error}'),
    ),
  ),
);

/// Scaffold con NavigationBar (bottom nav) para la sección principal
class HomeShell extends StatefulWidget {
  final Widget child;

  const HomeShell({super.key, required this.child});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  /// Historial de tabs visitados para navegación hacia atrás entre pestañas
  final List<int> _tabHistory = [0];
  /// Registra la última vez que el usuario presionó atrás (para doble-tap salir)
  DateTime? _ultimoBack;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    return BlocListener<AuthCubit, GlintAuthState>(
      // Cuando el usuario cierra sesión, redirigir automáticamente al login
      listener: (context, authState) {
        if (authState is AuthUnauthenticated) {
          context.go(AppRoutes.auth);
        }
      },
      child: PopScope(
        // canPop: false → nosotros manejamos el atrás manualmente
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;

          // 1️⃣ Si hay un modal/diálogo encima, cerrarlo primero
          // rootNavigator: true → solo detecta diálogos/bottom sheets reales,
          // no las rutas internas de GoRouter
          final rootNav = Navigator.of(context, rootNavigator: true);
          if (rootNav.canPop()) {
            rootNav.pop();
            return;
          }

          // 2️⃣ Si hay historial de tabs, volver al tab anterior
          if (_tabHistory.length > 1) {
            setState(() => _tabHistory.removeLast());
            _navigateTo(context, _tabHistory.last);
            return;
          }

          // 3️⃣ Sin historial: doble-tap para salir de la app
          final ahora = DateTime.now();
          if (_ultimoBack != null &&
              ahora.difference(_ultimoBack!) < const Duration(seconds: 2)) {
            SystemNavigator.pop();
          } else {
            _ultimoBack = ahora;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Presiona atrás de nuevo para salir de Glint'),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: Scaffold(
          body: widget.child,
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex(location),
            onDestinationSelected: (index) => _onTap(context, index),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Inicio',
              ),
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
                label: 'Dinero',
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_today_outlined),
                selectedIcon: Icon(Icons.calendar_today),
                label: 'Agenda',
              ),
              NavigationDestination(
                icon: Icon(Icons.sticky_note_2_outlined),
                selectedIcon: Icon(Icons.sticky_note_2),
                label: 'Notas',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _selectedIndex(String location) {
    if (location.startsWith(AppRoutes.dashboard)) return 0;
    if (location.startsWith(AppRoutes.routines))  return 1;
    if (location.startsWith(AppRoutes.habits))    return 2;
    if (location.startsWith(AppRoutes.finance))   return 3;
    if (location.startsWith(AppRoutes.agenda))    return 4;
    if (location.startsWith(AppRoutes.notes))     return 5;
    return 6;
  }

  void _onTap(BuildContext context, int index) {
    final currentIndex = _selectedIndex(
      GoRouterState.of(context).matchedLocation,
    );
    // Solo agregar al historial si cambiamos de tab
    if (index != currentIndex) {
      setState(() {
        // Evitar duplicados consecutivos en historial
        if (_tabHistory.isEmpty || _tabHistory.last != index) {
          _tabHistory.add(index);
        }
      });
    }
    _navigateTo(context, index);
  }

  /// Navega al tab por índice sin agregar al historial
  void _navigateTo(BuildContext context, int index) {
    switch (index) {
      case 0: context.go(AppRoutes.dashboard); break;
      case 1: context.go(AppRoutes.routines);  break;
      case 2: context.go(AppRoutes.habits);    break;
      case 3: context.go(AppRoutes.finance);   break;
      case 4: context.go(AppRoutes.agenda);    break;
      case 5: context.go(AppRoutes.notes);     break;
      case 6: context.go(AppRoutes.profile);   break;
    }
  }
}

/// Pantalla de splash animada — verifica onboarding y sesión antes de redirigir
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _escala;
  late Animation<double> _opacidad;
  late Animation<Offset> _subtitulo;

  @override
  void initState() {
    super.initState();

    // Configurar animaciones
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _escala = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.6, curve: Curves.elasticOut)),
    );

    _opacidad = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.3, 0.7, curve: Curves.easeIn)),
    );

    _subtitulo = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.5, 1.0, curve: Curves.easeOut)),
    );

    _ctrl.forward();

    // Después de la animación, redirigir
    Future.delayed(const Duration(milliseconds: 2200), _redirigir);
  }

  Future<void> _redirigir() async {
    if (!mounted) return;

    // Verificar si ya vio el onboarding
    final onboardingVisto = await yaVioOnboarding();
    if (!mounted) return;

    if (!onboardingVisto) {
      context.go(AppRoutes.onboarding);
      return;
    }

    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      final bioEnabled = await BiometricService.isEnabled();
      final bioAvailable = await BiometricService.isAvailable();
      if (!mounted) return;
      if (bioEnabled && bioAvailable) {
        final autenticado = await BiometricService.authenticate();
        if (!mounted) return;
        if (autenticado) {
          context.go(AppRoutes.dashboard);
        } else {
          context.go(AppRoutes.auth);
        }
      } else {
        context.go(AppRoutes.dashboard);
      }
    } else {
      context.go(AppRoutes.auth);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo animado con escala elástica
            ScaleTransition(
              scale: _escala,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(80),
                      blurRadius: 32,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image.asset(
                    'assets/icons/icon.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // Nombre de la app con fade
            FadeTransition(
              opacity: _opacidad,
              child: Text(
                'Glint',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
              ),
            ),
            const SizedBox(height: 8),

            // Subtítulo con slide desde abajo
            SlideTransition(
              position: _subtitulo,
              child: FadeTransition(
                opacity: _opacidad,
                child: Text(
                  'Tu vida, organizada ✨',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 64),

            // Indicador de carga sutil
            FadeTransition(
              opacity: _opacidad,
              child: SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  color: Colors.white38,
                  strokeWidth: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
