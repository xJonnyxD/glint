import 'package:get_it/get_it.dart';

/// Instancia global del service locator
final GetIt getIt = GetIt.instance;

/// Inicializa dependencias de la app
Future<void> configureDependencies() async {
  // Actualmente todos los servicios se crean directamente en main.dart
  // usando MultiBlocProvider. Este método existe para compatibilidad futura.
}
