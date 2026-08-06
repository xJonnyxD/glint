import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:glint/features/groups/data/group_repository.dart';
import 'package:glint/features/groups/domain/group_entity.dart';

// ── Estados ───────────────────────────────────────────────────────────────────

abstract class GroupsState {}

class GroupsLoading extends GroupsState {}

class GroupsLoaded extends GroupsState {
  final List<GroupEntity> grupos;
  GroupsLoaded(this.grupos);
}

class GroupsError extends GroupsState {
  final String mensaje;
  GroupsError(this.mensaje);
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

/// Maneja la lista de grupos del usuario (en vivo por Realtime).
class GroupsCubit extends Cubit<GroupsState> {
  final GroupRepository _repo;
  final String _usuarioId;
  final String _nombreUsuario;
  StreamSubscription? _sub;

  GroupsCubit(this._repo, this._usuarioId, this._nombreUsuario)
      : super(GroupsLoading()) {
    cargar();
  }

  void cargar() {
    _sub?.cancel();
    _sub = _repo.watchMisGrupos(_usuarioId).listen(
          (lista) => emit(GroupsLoaded(lista)),
          onError: (e) => emit(GroupsError('$e')),
        );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }

  Future<String> crearGrupo(
    String nombre, {
    String moneda = 'USD',
    String color = '#6750A4',
    String emoji = '👥',
  }) {
    return _repo.crearGrupo(
      nombre: nombre,
      usuarioId: _usuarioId,
      nombreCreador: _nombreUsuario,
      moneda: moneda,
      color: color,
      emoji: emoji,
    );
  }

  Future<void> eliminarGrupo(String grupoId) => _repo.eliminarGrupo(grupoId);

  /// Une al usuario a un grupo mediante un código de invitación.
  Future<String> unirsePorCodigo(String codigo) =>
      _repo.aceptarInvitacion(codigo);
}
