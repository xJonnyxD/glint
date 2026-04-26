import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:glint/features/finance/data/recurring_expense_repository.dart';
import 'package:glint/features/finance/domain/recurring_expense_entity.dart';

// ── Estados ───────────────────────────────────────────────────────────────────

abstract class RecurringExpenseState {}

class RecurringExpenseLoading extends RecurringExpenseState {}

class RecurringExpenseLoaded extends RecurringExpenseState {
  final List<RecurringExpenseEntity> gastos;
  RecurringExpenseLoaded(this.gastos);

  /// Total mensual estimado de todos los gastos activos
  double get totalMensual {
    return gastos.where((g) => g.activo).fold(0.0, (sum, g) {
      switch (g.frecuencia) {
        case FrecuenciaRecurrente.diario:
          return sum + g.monto * 30;
        case FrecuenciaRecurrente.semanal:
          return sum + g.monto * 4.33;
        case FrecuenciaRecurrente.mensual:
          return sum + g.monto;
        case FrecuenciaRecurrente.anual:
          return sum + g.monto / 12;
      }
    });
  }
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class RecurringExpenseCubit extends Cubit<RecurringExpenseState> {
  final RecurringExpenseRepository _repo;
  final String _usuarioId;
  StreamSubscription? _sub;

  RecurringExpenseCubit(this._repo, this._usuarioId)
      : super(RecurringExpenseLoading()) {
    cargar();
  }

  void cargar() {
    _sub?.cancel();
    _sub = _repo.watchRecurrentes(_usuarioId).listen(
      (lista) => emit(RecurringExpenseLoaded(lista)),
      onError: (_) => emit(RecurringExpenseLoaded([])),
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }

  Future<void> crearGasto(
    String nombre,
    String categoria,
    String categoriaEmoji,
    double monto,
    FrecuenciaRecurrente frecuencia,
    int diaDelMes,
  ) async {
    final ahora = DateTime.now();
    final gasto = RecurringExpenseEntity(
      id: const Uuid().v4(),
      nombre: nombre,
      categoria: categoria,
      categoriaEmoji: categoriaEmoji,
      monto: monto,
      frecuencia: frecuencia,
      diaDelMes: diaDelMes,
      activo: true,
      usuarioId: _usuarioId,
      creadoEn: ahora,
    );
    await _repo.crearRecurrente(gasto);
  }

  Future<void> toggleActivo(String id, bool activo) async {
    await _repo.toggleActivo(id, activo);
  }

  Future<void> eliminar(String id) async {
    await _repo.eliminarRecurrente(id);
  }
}
