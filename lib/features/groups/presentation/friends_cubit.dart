import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:glint/features/groups/data/group_repository.dart';

class FriendsState {
  final bool cargando;
  final List<PerfilBusqueda> amigos;
  final List<SolicitudAmistad> solicitudes;
  final String? error;

  const FriendsState({
    this.cargando = true,
    this.amigos = const [],
    this.solicitudes = const [],
    this.error,
  });

  FriendsState copyWith({
    bool? cargando,
    List<PerfilBusqueda>? amigos,
    List<SolicitudAmistad>? solicitudes,
    String? error,
  }) {
    return FriendsState(
      cargando: cargando ?? this.cargando,
      amigos: amigos ?? this.amigos,
      solicitudes: solicitudes ?? this.solicitudes,
      error: error,
    );
  }
}

/// Maneja la lista de amigos y las solicitudes recibidas.
class FriendsCubit extends Cubit<FriendsState> {
  final GroupRepository _repo;

  FriendsCubit(this._repo) : super(const FriendsState()) {
    cargar();
  }

  Future<void> cargar() async {
    emit(state.copyWith(cargando: true));
    try {
      final amigos = await _repo.obtenerAmigos();
      final solicitudes = await _repo.obtenerSolicitudes();
      emit(FriendsState(
          cargando: false, amigos: amigos, solicitudes: solicitudes));
    } catch (e) {
      emit(state.copyWith(cargando: false, error: '$e'));
    }
  }

  Future<List<PerfilBusqueda>> buscar(String texto) => _repo.buscarPerfil(texto);

  Future<void> solicitar(String destinatarioId) async {
    await _repo.solicitarAmistad(destinatarioId);
    await cargar();
  }

  Future<void> responder(String id, bool aceptar) async {
    await _repo.responderAmistad(id, aceptar);
    await cargar();
  }

  Future<void> eliminar(String amigoId) async {
    await _repo.eliminarAmigo(amigoId);
    await cargar();
  }
}
