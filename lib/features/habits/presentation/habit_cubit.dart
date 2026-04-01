import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:glint/features/habits/data/habit_repository.dart';
import 'package:glint/features/habits/domain/habit_entity.dart';
import 'habit_state.dart';

/// HabitCubit — maneja toda la lógica de hábitos
class HabitCubit extends Cubit<HabitState> {
  final HabitRepository _repo;
  final String _usuarioId;

  HabitCubit(this._repo, this._usuarioId) : super(HabitLoading()) {
    cargarHabitos();
  }

  /// Carga los hábitos del usuario y se mantiene escuchando cambios en tiempo real
  void cargarHabitos() {
    _repo
        .watchHabitos(_usuarioId)
        .listen(
          (habitos) => emit(HabitLoaded(habitos)),
          // Si hay error (ej: en web), muestra lista vacía en lugar de crashear
          onError: (_) => emit(HabitLoaded([])),
        );
  }

  /// Crea un hábito nuevo con los datos del formulario
  Future<void> crearHabito({
    required String nombre,
    required String icono,
    required CategoriaHabito categoria,
    required FrecuenciaHabito frecuencia,
    int metaSemanal = 7,
  }) async {
    try {
      final habito = HabitEntity(
        id: const Uuid().v4(),
        nombre: nombre,
        icono: icono,
        categoria: categoria,
        frecuencia: frecuencia,
        metaSemanal: metaSemanal,
        completadoHoy: false,
        rachaActual: 0,
        rachaMaxima: 0,
        totalCompletados: 0,
        color: categoria.colorHex, // color basado en la categoría
        usuarioId: _usuarioId,
        creadoEn: DateTime.now(),
      );
      await _repo.crearHabito(habito);
    } catch (e) {
      // No emitir error para no interrumpir el stream
    }
  }

  /// Marca o desmarca un hábito como completado hoy
  Future<void> toggleCompletar(HabitEntity habito) async {
    try {
      await _repo.toggleCompletar(habito, !habito.completadoHoy);
    } catch (e) {
      // No emitir error para no interrumpir el stream
    }
  }

  /// Elimina un hábito permanentemente
  Future<void> eliminarHabito(String id) async {
    try {
      await _repo.eliminarHabito(id);
    } catch (e) {
      // No emitir error para no interrumpir el stream
    }
  }
}
