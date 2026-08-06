import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:glint/core/constants/app_constants.dart';
import 'package:glint/features/auth/presentation/auth_cubit.dart';
import 'package:glint/core/icons/app_icons.dart';
import 'package:glint/core/motion/route_transitions.dart';
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
import 'package:glint/features/finance/presentation/finance_analytics_screen.dart';
import 'package:glint/features/groups/presentation/groups_screen.dart';
import 'package:glint/features/groups/presentation/friends_screen.dart';
import 'package:glint/features/agenda/presentation/agenda_screen.dart';
import 'package:glint/features/notes/presentation/notes_screen.dart';
import 'package:glint/features/profile/presentation/profile_screen.dart';
import 'package:glint/features/settings/presentation/settings_screen.dart';
import 'package:glint/features/gamification/presentation/gamification_cubit.dart';
import 'package:glint/features/gamification/presentation/gamification_screen.dart';
import 'package:glint/shared/services/notification_handler.dart';

/// Router principal de Glint usando GoRouter
final GoRouter appRouter = GoRouter(
  navigatorKey: NotificationHandler.navigatorKey,
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
      pageBuilder: (context, state) => fadeScalePage(state, const AuthScreen()),
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
      pageBuilder: (context, state) => fadeScalePage(state, const BudgetScreen()),
    ),
    GoRoute(
      path: AppRoutes.financeSavingsGoals,
      pageBuilder: (context, state) => fadeScalePage(state, const SavingsGoalScreen()),
    ),
    GoRoute(
      path: AppRoutes.financeDebts,
      pageBuilder: (context, state) => fadeScalePage(state, const DebtScreen()),
    ),
    GoRoute(
      path: AppRoutes.financeRecurring,
      pageBuilder: (context, state) => fadeScalePage(state, const RecurringExpenseScreen()),
    ),
    GoRoute(
      path: AppRoutes.financeAnalytics,
      pageBuilder: (context, state) => fadeScalePage(state, const FinanceAnalyticsScreen()),
    ),

    // ── Gastos compartidos (grupos estilo Settle Up) ─────────────────────────
    GoRoute(
      path: AppRoutes.groups,
      pageBuilder: (context, state) => fadeScalePage(state, const GroupsScreen()),
    ),
    GoRoute(
      path: AppRoutes.friends,
      pageBuilder: (context, state) => fadeScalePage(state, const FriendsScreen()),
    ),

    // ── Onboarding ────────────────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.onboarding,
      pageBuilder: (context, state) => fadeScalePage(state, const OnboardingScreen()),
    ),

    // ── Calculadora de Salario SV ─────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.salaryCalculator,
      pageBuilder: (context, state) => fadeScalePage(state, const SalaryCalculatorScreen()),
    ),

    // ── Configuración ─────────────────────────────────────────────────────────
    GoRoute(
      path: AppRoutes.settings,
      pageBuilder: (context, state) => fadeScalePage(state, const SettingsScreen()),
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
  /// Historial de pestañas visitadas, para que "atrás" vuelva a la anterior.
  final List<int> _tabHistory = [0];

  /// Registra la última vez que el usuario presionó atrás (para doble-tap salir)
  DateTime? _ultimoBack;

  /// Apunta la pestaña actual si es distinta de la última registrada.
  ///
  /// Se hace aquí, y no solo en [_onTap], porque a una pestaña se puede llegar
  /// de muchas formas: la barra de navegación, un `context.go` desde el
  /// dashboard, un enlace profundo o una redirección. Registrarlo solo en el
  /// `onTap` de la barra dejaba el historial vacío en todos los demás casos, y
  /// entonces "atrás" caía directamente en "pulsa otra vez para salir" —
  /// que es justo el fallo de que la app se cerrara en vez de retroceder.
  ///
  /// No lleva `setState`: solo anota por dónde se ha pasado, no cambia lo que
  /// se pinta (y llamarlo durante el build sería un error).
  void _registrarTab(int indice) {
    if (_tabHistory.isEmpty || _tabHistory.last != indice) {
      _tabHistory.add(indice);
      // El historial no necesita ser infinito; con las últimas visitas basta
      // y así no crece sin control en sesiones largas.
      if (_tabHistory.length > 20) _tabHistory.removeAt(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    _registrarTab(_selectedIndex(location));

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
        child: _construirScaffold(context, location),
      ),
    );
  }

  /// Destinos de navegación, en el mismo orden que [_selectedIndex]/[_onTap].
  static const List<({IconData icono, String etiqueta})> _destinos = [
    (icono: AppIcons.home,     etiqueta: 'Inicio'),
    (icono: AppIcons.routines, etiqueta: 'Rutinas'),
    (icono: AppIcons.habits,   etiqueta: 'Hábitos'),
    (icono: AppIcons.finance,  etiqueta: 'Dinero'),
    (icono: AppIcons.agenda,   etiqueta: 'Agenda'),
    (icono: AppIcons.notes,    etiqueta: 'Notas'),
    (icono: AppIcons.profile,  etiqueta: 'Perfil'),
  ];

  /// Barra inferior en móvil; NavigationRail lateral en pantallas anchas
  /// (extendido con etiquetas en escritorio, compacto en tablet).
  Widget _construirScaffold(BuildContext context, String location) {
    final idx = _selectedIndex(location);
    final ancho = MediaQuery.sizeOf(context).width;
    final usarRail = ancho >= 720;

    if (!usarRail) {
      return Scaffold(
        body: widget.child,
        bottomNavigationBar: NavigationBar(
          selectedIndex: idx,
          onDestinationSelected: (i) => _onTap(context, i),
          destinations: [
            for (final d in _destinos)
              NavigationDestination(
                icon: Icon(d.icono),
                selectedIcon: Icon(d.icono, fill: 1),
                label: d.etiqueta,
              ),
          ],
        ),
      );
    }

    final extendido = ancho >= 1000;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: idx,
            onDestinationSelected: (i) => _onTap(context, i),
            extended: extendido,
            labelType: extendido ? null : NavigationRailLabelType.all,
            backgroundColor: colorScheme.surface,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset('assets/icons/icon.png', width: 36, height: 36),
              ),
            ),
            destinations: [
              for (final d in _destinos)
                NavigationRailDestination(
                  icon: Icon(d.icono),
                  selectedIcon: Icon(d.icono, fill: 1),
                  label: Text(d.etiqueta),
                ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: widget.child),
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
    // El historial lo apunta [_registrarTab] en el build siguiente, que capta
    // por igual este toque y cualquier otra forma de llegar a la pestaña.
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

    final authState = context.read<AuthCubit>().state;
    final tieneSesion = authState is AuthAuthenticated;

    // El onboarding es para quien llega por primera vez. Se comprueba la sesión
    // ANTES: a quien ya tiene cuenta no hay que explicarle la app otra vez
    // —pasaba al reinstalar o al borrar los datos, porque la marca de "ya lo
    // vio" se guarda en el dispositivo y la sesión se restaura del servidor—.
    if (!tieneSesion) {
      final onboardingVisto = await yaVioOnboarding();
      if (!mounted) return;
      if (!onboardingVisto) {
        context.go(AppRoutes.onboarding);
        return;
      }
      context.go(AppRoutes.auth);
      return;
    }

    // Con sesión: darlo por visto, para que no reaparezca más adelante.
    unawaited(marcarOnboardingVisto());

    final bioEnabled = await BiometricService.isEnabled();
    if (!mounted) return;
    if (!bioEnabled) {
      context.go(AppRoutes.dashboard);
      return;
    }

    await _pedirDesbloqueo();
  }

  /// Pide el desbloqueo antes de mostrar nada, y reintenta mientras haga falta.
  ///
  /// Lo que NO hace: mandar al login. La sesión sigue siendo válida — el
  /// desbloqueo es una capa de privacidad, no una expulsión. Antes, cancelar
  /// el diálogo te echaba a la pantalla de acceso y perdías la sesión.
  Future<void> _pedirDesbloqueo() async {
    while (mounted) {
      final resultado = await BiometricService.autenticar();
      if (!mounted) return;

      // Éxito, o un dispositivo que sencillamente no puede hacerlo: se entra.
      if (resultado.debePermitirEntrar) {
        final aviso = resultado.mensaje;
        context.go(AppRoutes.dashboard);
        if (aviso != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(aviso), behavior: SnackBarBehavior.floating),
          );
        }
        return;
      }

      // Canceló o falló: se le explica y se le deja decidir. Sin salida
      // silenciosa a la pantalla de acceso.
      final reintentar = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Text('Glint está bloqueado'),
          content: Text(resultado.mensaje ??
              'Desbloquea con tu huella, rostro o PIN para continuar.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cerrar sesión'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
      if (!mounted) return;

      if (reintentar != true) {
        // Solo si el usuario lo pide expresamente.
        await context.read<AuthCubit>().signOut();
        if (mounted) context.go(AppRoutes.auth);
        return;
      }
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
                      // Malva y no negra: sobre el lavanda del fondo, una
                      // sombra neutra ensucia el logo en vez de elevarlo.
                      color: const Color(0xFF2A1A5E).withValues(alpha: 0.45),
                      blurRadius: 36,
                      offset: const Offset(0, 12),
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
                  'Tu vida, organizada',
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
