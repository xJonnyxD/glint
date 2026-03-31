import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'shared/di/app_router.dart';
import 'shared/di/injection_container.dart';

Future<void> main() async {
  // Asegura que los bindings de Flutter estén listos antes de cualquier init
  WidgetsFlutterBinding.ensureInitialized();

  // Forzar orientación vertical
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Estilo de la barra de estado (transparente)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Inicializar Hive (key-value local)
  await Hive.initFlutter();

  // Inicializar Supabase.
  // Las keys se inyectan vía --dart-define en build o CI/CD.
  // En desarrollo local, definir en launch.json de VS Code:
  //   "args": ["--dart-define=SUPABASE_URL=...", "--dart-define=SUPABASE_ANON_KEY=..."]
  if (AppConstants.supabaseUrl.isNotEmpty &&
      AppConstants.supabaseAnonKey.isNotEmpty) {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
  }

  // Inicializar inyección de dependencias (GetIt + Injectable)
  await configureDependencies();

  runApp(const GlintApp());
}

/// Widget raíz de la aplicación Glint
class GlintApp extends StatelessWidget {
  const GlintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Temas light y dark — respeta la preferencia del sistema
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,

      // Router declarativo con GoRouter
      routerConfig: appRouter,

      // Localización básica en español salvadoreño
      locale: const Locale('es', 'SV'),
    );
  }
}
