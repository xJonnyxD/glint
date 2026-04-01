/// Constantes globales de la aplicación Glint
abstract class AppConstants {
  // ── Info de la app ─────────────────────────────────────────────────────────
  static const String appName    = 'Glint';
  static const String appVersion = '1.0.0';
  static const String appLocale  = 'es_SV';

  // ── Supabase (reemplazar con tus keys reales en .env) ─────────────────────
  // IMPORTANTE: Nunca hardcodear keys en producción.
  // Usar flutter_dotenv o --dart-define para inyectarlas.
  static const String supabaseUrl     = 'https://glenycnniedmxwadilfd.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdsZW55Y25uaWVkbXh3YWRpbGZkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ5NzI3NjEsImV4cCI6MjA5MDU0ODc2MX0.opOPvu8LHlUhy09l_M_UpunGJdXOsdaFPFerPWTkWFs';

  // ── Hive — nombres de boxes ────────────────────────────────────────────────
  static const String hiveBoxSettings    = 'glint_settings';
  static const String hiveBoxSession     = 'glint_session';
  static const String hiveBoxCache       = 'glint_cache';

  // ── Drift — nombre de la base de datos local ───────────────────────────────
  static const String driftDbName = 'glint_local.db';

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
  static const String dashboard           = '/home/dashboard';
}
