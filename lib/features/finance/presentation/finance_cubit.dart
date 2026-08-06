import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:glint/features/finance/data/transaction_repository.dart';
import 'package:glint/features/finance/domain/transaction_entity.dart';
import 'finance_state.dart';

class FinanceCubit extends Cubit<FinanceState> {
  final TransactionRepository _repo;
  final String _usuarioId;
  StreamSubscription? _sub;

  FinanceCubit(this._repo, this._usuarioId) : super(FinanceLoading()) {
    cargarTransacciones();
  }

  /// Expuestos para la pantalla de Análisis, que necesita el histórico completo
  /// (varios meses), no solo el mes actual.
  TransactionRepository get repo => _repo;
  String get usuarioId => _usuarioId;

  void cargarTransacciones() {
    _sub?.cancel();
    _sub = _repo.watchMesActual(_usuarioId).listen(
      (lista) => emit(FinanceLoaded(lista)),
      onError: (_) => emit(FinanceLoaded([])), // en web sin SQLite → lista vacía
    );
  }

  Future<void> agregarTransaccion({
    required TipoTransaccion tipo,
    required double monto,
    required String descripcion,
    required String categoria,
    required String categoriaEmoji,
    String? notas,
    String? imagenPath,
    DateTime? fecha,
  }) async {
    final tx = TransactionEntity(
      id:             const Uuid().v4(),
      tipo:           tipo,
      monto:          monto,
      descripcion:    descripcion,
      categoria:      categoria,
      categoriaEmoji: categoriaEmoji,
      notas:          notas,
      imagenPath:     imagenPath,
      fecha:          fecha ?? DateTime.now(),
      usuarioId:      _usuarioId,
      creadaEn:       DateTime.now(),
    );
    // Dejar que el error se propague a la UI para que pueda mostrarlo
    await _repo.crearTransaccion(tx);
  }

  /// Edita un movimiento existente conservando su id y su fecha de creación.
  Future<void> editarTransaccion({
    required TransactionEntity original,
    required TipoTransaccion tipo,
    required double monto,
    required String descripcion,
    required String categoria,
    required String categoriaEmoji,
    String? notas,
    DateTime? fecha,
  }) async {
    await _repo.actualizarTransaccion(
      TransactionEntity(
        id:             original.id,
        tipo:           tipo,
        monto:          monto,
        descripcion:    descripcion,
        categoria:      categoria,
        categoriaEmoji: categoriaEmoji,
        notas:          notas,
        imagenPath:     original.imagenPath,
        fecha:          fecha ?? original.fecha,
        usuarioId:      original.usuarioId,
        creadaEn:       original.creadaEn,
      ),
    );
  }

  Future<void> eliminarTransaccion(String id) async {
    await _repo.eliminarTransaccion(id);
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
