import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:glint/core/constants/app_constants.dart';
import 'package:glint/features/auth/presentation/auth_cubit.dart';
import 'package:glint/features/auth/presentation/auth_screen.dart';
import 'package:glint/features/auth/presentation/auth_state.dart' show AuthInitial, AuthLoading, AuthAuthenticated;
import 'package:glint/features/onboarding/onboarding_screen.dart';
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
      ],
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
            label: 'Finanzas',
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
      context.go(AppRoutes.dashboard);
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
