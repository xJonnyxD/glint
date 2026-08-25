/// Constantes globales de la aplicación Glint
abstract class AppConstants {
  // ── Info de la app ─────────────────────────────────────────────────────────
  static const String appName    = 'Glint';
  static const String appVersion = '1.0.0';
  static const String appLocale  = 'es_SV';

  // ── Supabase ───────────────────────────────────────────────────────────────
  // El backend se inyecta SIEMPRE al compilar. Aquí no hay valor por defecto,
  // y es a propósito:
  //   flutter build apk \
  //     --dart-define=SUPABASE_URL=https://glint.yanes.xyz \
  //     --dart-define=SUPABASE_ANON_KEY=eyJ...
  //
  // Antes estaban aquí la URL y la clave anon de un proyecto Supabase alojado
  // en la nube, distinto del servidor de producción. Cualquier build que se
  // olvidara de los --dart-define arrancaba hablando con ESE backend sin decir
  // nada —los datos del usuario acababan en un proyecto que no es el nuestro—
  // y la clave no había forma de rotarla sin recompilar. Vacío, la falta de
  // configuración se nota al arrancar, que es justo lo que se quiere.
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY');

  /// `true` si la app se compiló con un backend configurado.
  static bool get hayBackend =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  // ── Hive — nombres de boxes ────────────────────────────────────────────────
  static const String hiveBoxSettings    = 'glint_settings';
  static const String hiveBoxSession     = 'glint_session';
  static const String hiveBoxCache       = 'glint_cache';

  // ── Drift — nombre de la base de datos local ───────────────────────────────
  static const String driftDbName = 'glint_local.db';

  // ── Storage — bucket de las fotos de perfil ────────────────────────────────
  // Tiene que coincidir con el bucket que crea deploy/db-init/24-avatares.sql.
  static const String bucketAvatares = 'avatares';

  // ── Sync ───────────────────────────────────────────────────────────────────
  static const Duration syncDebounce   = Duration(seconds: 5);
  static const Duration syncInterval   = Duration(minutes: 15);
  static const int     syncMaxRetries  = 3;

  // ── Paginación ─────────────────────────────────────────────────────────────
  static const int pageSize = 20;

  // ── Finanzas — El Salvador ─────────────────────────────────────────────────
  static const String currencySymbol = '\$';
  static const String currencyCode   = 'USD'; // El Salvador usa USD
  static const double afpRate        = 0.0725; // AFP empleado 7.25%
  static const double isssRate       = 0.03;   // ISSS empleado 3%

  // ── Gamificación ───────────────────────────────────────────────────────────
  static const int xpPerHabitCompleted    = 10;
  static const int xpPerRoutineCompleted  = 25;
  static const int xpPerTaskCompleted     = 5;
  static const int xpStreakBonus          = 15; // bonus por racha de 7 días

  // ── Límites UI ─────────────────────────────────────────────────────────────
  static const int    maxRoutineNameLength   = 50;
  static const int    maxHabitNameLength     = 50;
  static const int    maxNoteLength          = 2000;
  static const int    maxCategoryNameLength  = 30;
  static const double maxBudgetAmount        = 999999.99;

  // ── Timeouts de red ────────────────────────────────────────────────────────
  static const Duration networkTimeout    = Duration(seconds: 30);
  static const Duration cacheMaxAge       = Duration(hours: 24);

  // ── Notificaciones ─────────────────────────────────────────────────────────
  static const int notifChannelRoutines = 1;
  static const int notifChannelHabits   = 2;
  static const int notifChannelAgenda   = 3;
  static const int notifChannelFinance  = 4;
}

/// Rutas nombradas de la app (usadas por GoRouter)
abstract class AppRoutes {
  static const String splash         = '/';
  static const String auth           = '/auth';
  static const String login          = '/auth/login';
  static const String register       = '/auth/register';
  static const String home           = '/home';
  static const String routines       = '/home/routines';
  static const String routineDetail  = '/home/routines/:id';
  static const String habits         = '/home/habits';
  static const String habitDetail    = '/home/habits/:id';
  static const String finance        = '/home/finance';
  static const String financeDetail  = '/home/finance/:id';
  static const String agenda         = '/home/agenda';
  static const String profile        = '/home/profile';
  static const String onboarding       = '/onboarding';
  static const String notes            = '/home/notes';
  static const String settings         = '/settings';
  static const String backup           = '/settings/backup';
  static const String gamification     = '/home/gamification';
  static const String salaryCalculator    = '/salary-calculator';
  static const String financeBudget       = '/home/finance/budget';
  static const String financeSavingsGoals = '/home/finance/savings-goals';
  static const String financeDebts        = '/home/finance/debts';
  static const String financeRecurring    = '/home/finance/recurring';
  static const String financeAnalytics     = '/home/finance/analytics';
  static const String groups              = '/home/groups';
  static const String friends             = '/home/groups/friends';
  static const String dashboard           = '/home/dashboard';

  /// Las siete pestañas de la barra de navegación.
  static const List<String> pestanas = [
    dashboard, routines, habits, finance, agenda, notes, profile,
  ];

  /// ¿[ruta] es una pestaña de la barra de navegación?
  ///
  /// Importa al navegar: a una pestaña se va con `context.go` (se cambia de
  /// sección, no se apila), pero a cualquier otra pantalla hay que ir con
  /// `context.push`, para que quede en la pila y "atrás" tenga a dónde volver.
  /// Usar `go` hacia una pantalla que no es pestaña vacía la pila entera y
  /// deja al botón atrás sin nada que hacer: la app se cierra.
  static bool esPestana(String ruta) => pestanas.contains(ruta);
}
