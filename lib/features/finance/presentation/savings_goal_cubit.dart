import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:glint/features/finance/data/savings_goal_repository.dart';
import 'package:glint/features/finance/domain/savings_goal_entity.dart';

// ── Estados ───────────────────────────────────────────────────────────────────

abstract class SavingsGoalState {}

class SavingsGoalLoading extends SavingsGoalState {}

class SavingsGoalLoaded extends SavingsGoalState {
  final List<SavingsGoalEntity> metas;
  SavingsGoalLoaded(this.metas);
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class SavingsGoalCubit extends Cubit<SavingsGoalState> {
  final SavingsGoalRepository _repo;
  final String _usuarioId;

  SavingsGoalCubit(this._repo, this._usuarioId) : super(SavingsGoalLoading()) {
    cargar();
  }

  void cargar() {
    _repo.watchMetas(_usuarioId).listen(
      (lista) => emit(SavingsGoalLoaded(lista)),
      onError: (_) => emit(SavingsGoalLoaded([])),
    );
  }

  Future<void> crearMeta(
    String nombre,
    String emoji,
    double montoMeta,
    String color, {
    DateTime? fechaMeta,
  }) async {
    final ahora = DateTime.now();
    final meta = SavingsGoalEntity(
      id: const Uuid().v4(),
      nombre: nombre,
      emoji: emoji,
      montoMeta: montoMeta,
      montoActual: 0,
      fechaMeta: fechaMeta,
      color: color,
      usuarioId: _usuarioId,
      creadoEn: ahora,
    );
    try {
      await _repo.crearMeta(meta);
    } catch (_) {}
  }

  Future<void> agregarAhorro(String id, double monto) async {
    try {
      await _repo.agregarAhorro(id, monto);
    } catch (_) {}
  }

  Future<void> eliminar(String id) async {
    try {
      await _repo.eliminarMeta(id);
    } catch (_) {}
  }
}
