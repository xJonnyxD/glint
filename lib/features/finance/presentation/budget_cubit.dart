import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:glint/features/finance/data/budget_repository.dart';
import 'package:glint/features/finance/domain/budget_entity.dart';

// ── Estados ───────────────────────────────────────────────────────────────────

abstract class BudgetState {}

class BudgetLoading extends BudgetState {}

class BudgetLoaded extends BudgetState {
  final List<BudgetEntity> budgets;
  final int mes;
  final int anio;
  BudgetLoaded(this.budgets, this.mes, this.anio);
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class BudgetCubit extends Cubit<BudgetState> {
  final BudgetRepository _repo;
  final String _usuarioId;

  BudgetCubit(this._repo, this._usuarioId) : super(BudgetLoading()) {
    cargar();
  }

  void cargar() {
    final ahora = DateTime.now();
    _repo.watchBudgets(_usuarioId, ahora.month, ahora.year).listen(
      (lista) => emit(BudgetLoaded(lista, ahora.month, ahora.year)),
      onError: (_) => emit(BudgetLoaded([], ahora.month, ahora.year)),
    );
  }

  Future<void> crearPresupuesto(String categoria, double limite) async {
    final ahora = DateTime.now();
    final budget = BudgetEntity(
      id: const Uuid().v4(),
      categoria: categoria,
      limite: limite,
      mes: ahora.month,
      anio: ahora.year,
      usuarioId: _usuarioId,
      creadoEn: ahora,
    );
    try {
      await _repo.crearBudget(budget);
    } catch (_) {}
  }

  Future<void> actualizarLimite(String id, double nuevoLimite) async {
    try {
      await _repo.actualizarLimite(id, nuevoLimite);
    } catch (_) {}
  }

  Future<void> eliminar(String id) async {
    try {
      await _repo.eliminarBudget(id);
    } catch (_) {}
  }
}
