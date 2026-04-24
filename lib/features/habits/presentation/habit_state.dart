import 'package:glint/features/habits/domain/habit_entity.dart';

/// Estados posibles de la pantalla de Hábitos
abstract class HabitState {}

/// Cargando hábitos por primera vez
class HabitLoading extends HabitState {}

/// Hábitos cargados y listos para mostrar
class HabitLoaded extends HabitState {
  final List<HabitEntity> habitos;

  HabitLoaded(this.habitos);

  /// Hábitos agrupados por categoría (solo categorías que tienen al menos un hábito)
  Map<CategoriaHabito, List<HabitEntity>> get porCategoria {
    final mapa = <CategoriaHabito, List<HabitEntity>>{};
    for (final h in habitos) {
      mapa.putIfAbsent(h.categoria, () => []).add(h);
    }
    return mapa;
  }

  /// Cuántos hábitos completó hoy
  int get completadosHoy => habitos.where((h) => h.completadoHoy).length;

  /// Total de hábitos
  int get total => habitos.length;

  /// Progreso del día (0.0 a 1.0)
  double get progresoDia {
    if (habitos.isEmpty) return 0.0;
    return completadosHoy / total;
  }

  /// Racha máxima entre todos los hábitos
  int get mejorRacha {
    if (habitos.isEmpty) return 0;
    return habitos
        .map((h) => h.rachaMaxima)
        .reduce((a, b) => a > b ? a : b);
  }

  /// Total de veces completados en toda la historia
  int get totalHistorico =>
      habitos.fold(0, (sum, h) => sum + h.totalCompletados);
}

/// Error al cargar o guardar hábitos
class HabitError extends HabitState {
  final String mensaje;
  HabitError(this.mensaje);
}
