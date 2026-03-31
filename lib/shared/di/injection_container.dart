import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection_container.config.dart';

/// Instancia global del service locator
final GetIt getIt = GetIt.instance;

/// Inicializa todas las dependencias registradas con @injectable
/// Llamar una sola vez desde main.dart antes de runApp()
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async => getIt.init();
