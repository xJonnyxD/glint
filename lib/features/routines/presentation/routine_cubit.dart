import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:glint/features/routines/data/routine_repository.dart';
import 'package:glint/features/routines/domain/routine_entity.dart';
import 'package:glint/shared/services/notification_service.dart';
import 'routine_state.dart';

/// RoutineCubit — maneja toda la lógica de rutinas
class RoutineCubit extends Cubit<RoutineState> {
  final RoutineRepository _repo;
  final String _usuarioId;
  bool _notifsProgramadas = false;

  RoutineCubit(this._repo, this._usuarioId) : super(RoutineLoading()) {
    cargarRutinas();
  }

  void cargarRutinas() {
    _repo.watchRutinas(_usuarioId).listen(
      (rutinas) {
        emit(RoutineLoaded(rutinas));
        // Reprogramar notificación con el conteo real (solo la primera vez)
        if (!_notifsProgramadas) {
          _notifsProgramadas = true;
          NotificationService.reprogramarAlIniciar(
            totalRutinas: rutinas.where((r) => !r.completadaHoy).length,
            totalHabitos: 0, // HabitCubit maneja los hábitos
          );
        }
      },
      onError: (e) => emit(RoutineError('No se pudieron cargar las rutinas.')),
    );
  }

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

  Future<void> toggleCompletar(RoutineEntity rutina) async {
    final nuevaRacha = !rutina.completadaHoy
        ? rutina.rachaActual + 1
        : rutina.rachaActual;

    await _repo.toggleCompletar(rutina.id, !rutina.completadaHoy);
    if (!rutina.completadaHoy) {
      await _repo.actualizarRacha(rutina.id, nuevaRacha);
    }
  }

  Future<void> editarRutina({
    required String id,
    required String nombre,
    required String icono,
    required PeriodoDelDia periodo,
    required String hora,
  }) async {
    await _repo.editarRutina(
      id:      id,
      nombre:  nombre,
      icono:   icono,
      periodo: periodo,
      hora:    hora,
    );
  }

  Future<void> eliminarRutina(String id) async {
    await _repo.eliminarRutina(id);
  }
}
