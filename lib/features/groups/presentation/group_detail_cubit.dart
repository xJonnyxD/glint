import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:glint/features/groups/data/group_repository.dart';
import 'package:glint/features/groups/domain/group_detail.dart';
import 'package:glint/features/groups/domain/settlement_entity.dart';

// ── Estados ───────────────────────────────────────────────────────────────────

abstract class GroupDetailState {}

class GroupDetailLoading extends GroupDetailState {}

class GroupDetailLoaded extends GroupDetailState {
  final GroupDetail detalle;
  GroupDetailLoaded(this.detalle);
}

class GroupDetailError extends GroupDetailState {
  final String mensaje;
  GroupDetailError(this.mensaje);
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

/// Maneja el detalle de un grupo (miembros, gastos, saldos y liquidaciones),
/// todo en vivo por Realtime.
class GroupDetailCubit extends Cubit<GroupDetailState> {
  final GroupRepository _repo;
  final String grupoId;
  final String usuarioId;
  StreamSubscription? _sub;

  GroupDetailCubit(this._repo, this.grupoId, this.usuarioId)
      : super(GroupDetailLoading()) {
    _sub = _repo.watchDetalle(grupoId).listen(
          (d) => emit(GroupDetailLoaded(d)),
          onError: (e) => emit(GroupDetailError('$e')),
        );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }

  // ── Miembros ────────────────────────────────────────────────────────────
  Future<void> agregarMiembroVirtual(String nombre) =>
      _repo.agregarMiembroVirtual(grupoId, nombre);

  Future<void> agregarMiembroReal(PerfilBusqueda perfil) => _repo.agregarMiembroReal(
        grupoId: grupoId,
        userId: perfil.id,
        nombre: perfil.nombre.isNotEmpty ? perfil.nombre : perfil.email,
        avatarUrl: perfil.avatarUrl,
      );

  Future<List<PerfilBusqueda>> buscarPerfil(String texto) =>
      _repo.buscarPerfil(texto);

  Future<List<PerfilBusqueda>> obtenerAmigos() => _repo.obtenerAmigos();

  Future<void> eliminarMiembro(String miembroId) =>
      _repo.eliminarMiembro(miembroId);

  // ── Gastos ──────────────────────────────────────────────────────────────
  Future<void> crearGasto({
    required String descripcion,
    required double monto,
    required String pagadoPor,
    required DateTime fecha,
    required Map<String, double> partes,
    String categoria = '🧾',
    String moneda = 'USD',
  }) {
    return _repo.crearGasto(
      grupoId: grupoId,
      descripcion: descripcion,
      monto: monto,
      pagadoPor: pagadoPor,
      fecha: fecha,
      partes: partes,
      usuarioId: usuarioId,
      categoria: categoria,
      moneda: moneda,
    );
  }

  Future<void> editarGasto({
    required String gastoId,
    required String descripcion,
    required double monto,
    required String pagadoPor,
    required DateTime fecha,
    required Map<String, double> partes,
    String categoria = '🧾',
    String moneda = 'USD',
  }) {
    return _repo.editarGasto(
      gastoId: gastoId,
      descripcion: descripcion,
      monto: monto,
      pagadoPor: pagadoPor,
      fecha: fecha,
      partes: partes,
      categoria: categoria,
      moneda: moneda,
    );
  }

  Future<void> eliminarGasto(String gastoId) => _repo.eliminarGasto(gastoId);

  /// Registra el pago de una liquidación sugerida como transferencia.
  Future<void> registrarPago(SettlementEntity s, {String moneda = 'USD'}) {
    return _repo.crearTransferencia(
      grupoId: grupoId,
      deMiembroId: s.deId,
      aMiembroId: s.aId,
      monto: s.monto,
      usuarioId: usuarioId,
      moneda: moneda,
    );
  }

  // ── Invitaciones ──────────────────────────────────────────────────────────
  Future<String> crearInvitacion() =>
      _repo.crearInvitacion(grupoId: grupoId, usuarioId: usuarioId);

  Future<void> eliminarGrupo() => _repo.eliminarGrupo(grupoId);
  Future<void> renombrarGrupo(String nombre) =>
      _repo.renombrarGrupo(grupoId, nombre);
}
