import 'package:glint/features/routines/domain/routine_entity.dart';

/// Estados posibles de la pantalla de Rutinas
abstract class RoutineState {}

/// Cargando rutinas por primera vez
class RoutineLoading extends RoutineState {}

/// Rutinas cargadas y listas para mostrar
class RoutineLoaded extends RoutineState {
  final List<RoutineEntity> rutinas;

  // Rutinas agrupadas por período para mostrar en secciones
  List<RoutineEntity> get manana =>
      rutinas.where((r) => r.periodo == PeriodoDelDia.manana).toList();
  List<RoutineEntity> get mediodia =>
      rutinas.where((r) => r.periodo == PeriodoDelDia.mediodia).toList();
  List<RoutineEntity> get noche =>
      rutinas.where((r) => r.periodo == PeriodoDelDia.noche).toList();

  /// Progreso general del día (0.0 a 1.0)
  double get progresoDia {
    if (rutinas.isEmpty) return 0.0;
    final completadas = rutinas.where((r) => r.completadaHoy).length;
    return completadas / rutinas.length;
  }

  /// Cuántas rutinas completó hoy
  int get completadasHoy => rutinas.where((r) => r.completadaHoy).length;

  RoutineLoaded(this.rutinas);
}

/// Error al cargar o guardar rutinas
class RoutineError extends RoutineState {
  final String mensaje;
  RoutineError(this.mensaje);
}
