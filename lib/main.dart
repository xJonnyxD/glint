import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
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
import 'shared/database/app_database.dart';
import 'shared/di/app_router.dart';
import 'shared/di/injection_container.dart';
import 'shared/services/notification_service.dart';

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

  if (AppConstants.supabaseUrl.isNotEmpty &&
      AppConstants.supabaseAnonKey.isNotEmpty) {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
  }

  await configureDependencies();

  // Inicializar sistema de notificaciones locales
  await NotificationService.initialize();

  // Base de datos local Drift (singleton para toda la app)
  final appDatabase = AppDatabase();

  runApp(GlintApp(appDatabase: appDatabase));
}

/// Widget raíz de la aplicación Glint
class GlintApp extends StatelessWidget {
  final AppDatabase appDatabase;
  const GlintApp({super.key, required this.appDatabase});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(Supabase.instance.client),
        ),
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,
        routerConfig: appRouter,
        locale: const Locale('es', 'SV'),
        // Usamos builder para agregar RoutineCubit cuando el usuario está autenticado
        builder: (context, child) {
          return BlocBuilder<AuthCubit, GlintAuthState>(
            builder: (context, authState) {
              if (authState is AuthAuthenticated) {
                return MultiBlocProvider(
                  providers: [
                    BlocProvider<RoutineCubit>(
                      create: (_) => RoutineCubit(
                        RoutineRepository(appDatabase),
                        authState.user.id,
                      ),
                    ),
                    BlocProvider<FinanceCubit>(
                      create: (_) => FinanceCubit(
                        TransactionRepository(appDatabase),
                        authState.user.id,
                      ),
                    ),
                    BlocProvider<AgendaCubit>(
                      create: (_) => AgendaCubit(
                        EventRepository(appDatabase),
                        authState.user.id,
                      ),
                    ),
                    BlocProvider<HabitCubit>(
                      create: (_) => HabitCubit(
                        HabitRepository(appDatabase),
                        authState.user.id,
                      ),
                    ),
                    BlocProvider<NoteCubit>(
                      create: (_) => NoteCubit(
                        NoteRepository(appDatabase),
                        authState.user.id,
                      ),
                    ),
                  ],
                  child: child!,
                );
              }
              return child!;
            },
          );
        },
      ),
    );
  }
}
