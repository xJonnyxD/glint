import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:glint/features/habits/data/habit_repository.dart';
import 'package:glint/features/habits/domain/habit_entity.dart';
import 'package:glint/shared/services/xp_service.dart';
import 'habit_state.dart';

/// HabitCubit — maneja toda la lógica de hábitos
class HabitCubit extends Cubit<HabitState> {
  final HabitRepository _repo;
  final String _usuarioId;
  StreamSubscription? _sub;

  HabitCubit(this._repo, this._usuarioId) : super(HabitLoading()) {
    cargarHabitos();
  }

  /// Expone el repositorio para que la UI pueda consultar completaciones históricas
  HabitRepository get repo => _repo;
  String get usuarioId => _usuarioId;

  void cargarHabitos() {
    _sub?.cancel();
    _sub = _repo.watchHabitos(_usuarioId).listen(
      (habitos) => emit(HabitLoaded(habitos)),
      onError: (_) => emit(HabitLoaded([])),
    );
  }

  Future<void> crearHabito({
    required String nombre,
    required String icono,
    required CategoriaHabito categoria,
    required FrecuenciaHabito frecuencia,
    int metaSemanal = 7,
  }) async {
    final habito = HabitEntity(
      id:              const Uuid().v4(),
      nombre:          nombre,
      icono:           icono,
      categoria:       categoria,
      frecuencia:      frecuencia,
      metaSemanal:     metaSemanal,
      completadoHoy:   false,
      rachaActual:     0,
      rachaMaxima:     0,
      totalCompletados: 0,
      color:           categoria.colorHex,
      usuarioId:       _usuarioId,
      creadoEn:        DateTime.now(),
    );
    await _repo.crearHabito(habito);
  }

  /// Marca o desmarca un hábito. Registra la completación en el historial.
  Future<void> toggleCompletar(HabitEntity habito) async {
    final completando = !habito.completadoHoy;
    await _repo.toggleCompletar(habito, completando);
    if (completando) {
      await XpService.agregarXP(10, motivo: 'Hábito completado: ${habito.nombre}');
    }
  }

  Future<void> editarHabito({
    required String id,
    required String nombre,
    required String icono,
    required CategoriaHabito categoria,
    required FrecuenciaHabito frecuencia,
    required int metaSemanal,
  }) async {
    await _repo.editarHabito(
      id:          id,
      nombre:      nombre,
      icono:       icono,
      categoria:   categoria,
      frecuencia:  frecuencia,
      metaSemanal: metaSemanal,
    );
  }

  Future<void> eliminarHabito(String id) async {
    await _repo.eliminarHabito(id);
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
