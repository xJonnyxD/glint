import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:glint/features/finance/data/debt_repository.dart';
import 'package:glint/features/finance/domain/debt_entity.dart';

// ── Estados ───────────────────────────────────────────────────────────────────

abstract class DebtState {}

class DebtLoading extends DebtState {}

class DebtLoaded extends DebtState {
  final List<DebtEntity> deudas;
  DebtLoaded(this.deudas);

  double get totalLeDebo => deudas
      .where((d) => d.tipo == TipoDeuda.leDebo && !d.pagado)
      .fold(0.0, (sum, d) => sum + d.monto);

  double get totalMeDebeN => deudas
      .where((d) => d.tipo == TipoDeuda.meDebeN && !d.pagado)
      .fold(0.0, (sum, d) => sum + d.monto);
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class DebtCubit extends Cubit<DebtState> {
  final DebtRepository _repo;
  final String _usuarioId;

  DebtCubit(this._repo, this._usuarioId) : super(DebtLoading()) {
    cargar();
  }

  void cargar() {
    _repo.watchDeudas(_usuarioId).listen(
      (lista) => emit(DebtLoaded(lista)),
      onError: (_) => emit(DebtLoaded([])),
    );
  }

  Future<void> crearDeuda(
    String nombre,
    String concepto,
    double monto,
    TipoDeuda tipo,
    DateTime fecha,
  ) async {
    final ahora = DateTime.now();
    final deuda = DebtEntity(
      id: const Uuid().v4(),
      nombre: nombre,
      concepto: concepto,
      monto: monto,
      tipo: tipo,
      pagado: false,
      fecha: fecha,
      usuarioId: _usuarioId,
      creadoEn: ahora,
    );
    await _repo.crearDeuda(deuda);
  }

  Future<void> marcarPagado(String id) async {
    await _repo.marcarPagado(id);
  }

  Future<void> eliminar(String id) async {
    await _repo.eliminarDeuda(id);
  }
}
