import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:glint/features/routines/data/routine_repository.dart';
import 'package:glint/features/routines/domain/routine_entity.dart';
import 'routine_state.dart';

/// RoutineCubit — maneja toda la lógica de rutinas
class RoutineCubit extends Cubit<RoutineState> {
  final RoutineRepository _repo;
  final String _usuarioId;

  RoutineCubit(this._repo, this._usuarioId) : super(RoutineLoading()) {
    cargarRutinas();
  }

  /// Carga las rutinas del usuario y se mantiene escuchando cambios
  void cargarRutinas() {
    _repo.watchRutinas(_usuarioId).listen(
      (rutinas) => emit(RoutineLoaded(rutinas)),
      onError: (e) => emit(RoutineError('No se pudieron cargar las rutinas.')),
    );
  }

  /// Crea una rutina nueva
  Future<void> crearRutina({
    required String nombre,
    required String icono,
    required PeriodoDelDia periodo,
    required String hora,
  }) async {
    final rutina = RoutineEntity(
      id:            const Uuid().v4(),
      nombre:        nombre,
      icono:         icono,
      periodo:       periodo,
      hora:          hora,
      completadaHoy: false,
      rachaActual:   0,
      orden:         DateTime.now().millisecondsSinceEpoch,
      usuarioId:     _usuarioId,
      creadaEn:      DateTime.now(),
    );
    await _repo.crearRutina(rutina);
  }

  /// Marca/desmarca una rutina como completada
  Future<void> toggleCompletar(RoutineEntity rutina) async {
    final nuevaRacha = !rutina.completadaHoy
        ? rutina.rachaActual + 1  // completando → suma racha
        : rutina.rachaActual;     // des-completando → mantiene racha

    await _repo.toggleCompletar(rutina.id, !rutina.completadaHoy);
    if (!rutina.completadaHoy) {
      await _repo.actualizarRacha(rutina.id, nuevaRacha);
    }
  }

  /// Elimina una rutina
  Future<void> eliminarRutina(String id) async {
    await _repo.eliminarRutina(id);
  }
}
