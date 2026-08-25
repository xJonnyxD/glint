import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/feedback/haptica.dart';
import 'core/theme/app_theme.dart';
import 'shared/widgets/celebracion.dart';
import 'core/theme/theme_cubit.dart';
import 'features/auth/presentation/auth_cubit.dart';
import 'features/auth/presentation/auth_state.dart';
import 'features/routines/data/routine_repository.dart';
import 'features/routines/presentation/routine_cubit.dart';
import 'features/finance/data/transaction_repository.dart';
import 'features/finance/presentation/finance_cubit.dart';
import 'features/agenda/data/event_repository.dart';
import 'features/agenda/presentation/agenda_cubit.dart';
import 'features/habits/data/habit_repository.dart';
import 'features/habits/presentation/habit_cubit.dart';
import 'features/notes/data/note_repository.dart';
import 'features/notes/presentation/note_cubit.dart';
import 'features/profile/data/profile_repository.dart';
import 'features/profile/presentation/profile_cubit.dart';
import 'features/finance/data/budget_repository.dart';
import 'features/finance/presentation/budget_cubit.dart';
import 'features/finance/data/savings_goal_repository.dart';
import 'features/finance/presentation/savings_goal_cubit.dart';
import 'features/finance/data/debt_repository.dart';
import 'features/finance/presentation/debt_cubit.dart';
import 'features/finance/data/recurring_expense_repository.dart';
import 'features/finance/presentation/recurring_expense_cubit.dart';
import 'features/gamification/presentation/gamification_cubit.dart';
import 'features/groups/data/group_repository.dart';
import 'features/groups/presentation/groups_cubit.dart';
import 'shared/database/app_database.dart';
import 'shared/di/app_router.dart';
import 'shared/di/injection_container.dart';
import 'shared/services/notification_service.dart';
import 'shared/services/notification_handler.dart';
import 'shared/services/sync_manager.dart';
import 'shared/widgets/app_responsiva.dart';
import 'shared/widgets/offline_banner.dart';

/// Nombre a mostrar del usuario: el de sus metadatos si existe; si no, la parte
/// local del correo. Se usa como nombre del creador al crear un grupo.
String _nombreDe(User user) {
  final meta = user.userMetadata?['nombre'] as String?;
  if (meta != null && meta.trim().isNotEmpty) return meta.trim();
  final email = user.email;
  if (email != null && email.contains('@')) return email.split('@').first;
  return 'Yo';
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar locale de español para table_calendar e intl
  await initializeDateFormatting('es_SV', null);
  await initializeDateFormatting('es', null);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await Hive.initFlutter();

  // Sin backend la app NO arranca en modo local, aunque lo pareciera: unas
  // líneas más abajo SyncManager, AuthCubit y media docena de pantallas piden
  // `Supabase.instance` y reventarían con un "not initialized" que no dice
  // de dónde viene. Mejor parar aquí explicando qué falta.
  if (!AppConstants.hayBackend) {
    throw StateError(
      'Glint se compiló sin backend. Recompila pasando las dos claves:\n'
      '  --dart-define=SUPABASE_URL=https://glint.yanes.xyz\n'
      '  --dart-define=SUPABASE_ANON_KEY=<clave anon del servidor>',
    );
  }
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );

  await configureDependencies();

  // Inicializar sistema de notificaciones locales
  await NotificationService.initialize();
  await NotificationHandler.initialize();

  // Preferencia de háptica (no-op en web); cacheada para no leerla en cada toque.
  await Haptica.cargar();

  // Base de datos local Drift (singleton para toda la app)
  final appDatabase = AppDatabase();

  // Abrir la conexión en paralelo con el arranque de la UI, sin bloquearla:
  // así la primera consulta tras iniciar sesión no paga el costo de abrir
  // SQLite (en web, además, descargar e inicializar el WASM).
  unawaited(
    appDatabase
        .customSelect('SELECT 1')
        .get()
        .then(
          (_) {},
          onError: (Object e) =>
              debugPrint('Glint: no se pudo abrir la BD — $e'),
        ),
  );

  // Inicializar SyncManager para sincronización con Supabase
  SyncManager.initialize(supabase: Supabase.instance.client, db: appDatabase);

  runApp(GlintApp(appDatabase: appDatabase));
}

/// Widget raíz de la aplicación Glint
class GlintApp extends StatefulWidget {
  final AppDatabase appDatabase;
  const GlintApp({super.key, required this.appDatabase});

  @override
  State<GlintApp> createState() => _GlintAppState();
}

class _GlintAppState extends State<GlintApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Al volver a la app, sincronizar ya para ver de inmediato lo que se
    // cambió en otro dispositivo (además del sondeo periódico).
    if (state == AppLifecycleState.resumed) {
      try {
        SyncManager.instance.sincronizarAhora();
      } catch (_) {
        // Puede no estar inicializado todavía.
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(Supabase.instance.client),
        ),
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeSettings>(
        // Ojo: aquí NO va ningún PopScope. Al envolver la MaterialApp entera se
        // interceptaban TODOS los "atrás" antes de que el router pudiera
        // retroceder, y la app se cerraba desde cualquier pantalla. El
        // doble-toque para salir vive en HomeShell, que sabe si queda pila o
        // historial de pestañas al que volver.
        builder: (context, themeState) => MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.buildLight(themeState.color),
            darkTheme: AppTheme.buildDark(themeState.color),
            themeMode: themeState.modo,
            routerConfig: appRouter,
            locale: const Locale('es', 'SV'),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('es', 'SV'),
              Locale('es'),
              Locale('en'),
            ],
            // Usamos builder para agregar RoutineCubit cuando el usuario está autenticado
            builder: (context, child) {
              return CelebracionHost(
                child: AppResponsiva(
                  child: OfflineBanner(
                  child: BlocConsumer<AuthCubit, GlintAuthState>(
                    listener: (context, authState) {
                      if (authState is AuthAuthenticated) {
                        NotificationService.solicitarPermisoAlIniciar();
                      }
                    },
                    builder: (context, authState) {
                      if (authState is AuthAuthenticated) {
                        return MultiBlocProvider(
                          providers: [
                            BlocProvider<RoutineCubit>(
                              create: (_) => RoutineCubit(
                                RoutineRepository(widget.appDatabase),
                                authState.user.id,
                              ),
                            ),
                            BlocProvider<FinanceCubit>(
                              create: (_) => FinanceCubit(
                                TransactionRepository(widget.appDatabase),
                                authState.user.id,
                              ),
                            ),
                            BlocProvider<AgendaCubit>(
                              create: (_) => AgendaCubit(
                                EventRepository(widget.appDatabase),
                                authState.user.id,
                              ),
                            ),
                            BlocProvider<HabitCubit>(
                              create: (_) => HabitCubit(
                                HabitRepository(widget.appDatabase),
                                authState.user.id,
                              ),
                            ),
                            BlocProvider<NoteCubit>(
                              create: (_) => NoteCubit(
                                NoteRepository(widget.appDatabase),
                                authState.user.id,
                              ),
                            ),
                            BlocProvider<ProfileCubit>(
                              create: (_) => ProfileCubit(
                                ProfileRepository(widget.appDatabase),
                                Supabase.instance.client,
                                uid: authState.user.id,
                                email: authState.user.email ?? '',
                                // Empuja el cambio al servidor nada más
                                // guardarlo, sin esperar al ciclo de 3 minutos.
                                empujarSync: (uid) => SyncManager.instance
                                    .sincronizarPerfilAhora(uid),
                              ),
                            ),
                            BlocProvider<BudgetCubit>(
                              create: (_) => BudgetCubit(
                                BudgetRepository(widget.appDatabase),
                                authState.user.id,
                              ),
                            ),
                            BlocProvider<SavingsGoalCubit>(
                              create: (_) => SavingsGoalCubit(
                                SavingsGoalRepository(widget.appDatabase),
                                authState.user.id,
                              ),
                            ),
                            BlocProvider<DebtCubit>(
                              create: (_) => DebtCubit(
                                DebtRepository(widget.appDatabase),
                                authState.user.id,
                              ),
                            ),
                            BlocProvider<RecurringExpenseCubit>(
                              create: (_) => RecurringExpenseCubit(
                                RecurringExpenseRepository(widget.appDatabase),
                                authState.user.id,
                              ),
                            ),
                            BlocProvider<GamificationCubit>(
                              create: (_) => GamificationCubit(),
                            ),
                            BlocProvider<GroupsCubit>(
                              create: (_) => GroupsCubit(
                                GroupRepository(Supabase.instance.client),
                                authState.user.id,
                                _nombreDe(authState.user),
                              ),
                            ),
                          ],
                          child: child!,
                        );
                      }
                      return child!;
                    },
                  ),
                ),
              ),
            );
            },
        ),
      ),
    );
  }
}
