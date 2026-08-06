import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:glint/features/groups/data/group_repository.dart';
import 'friends_cubit.dart';
import 'widgets/member_avatar.dart';

/// Lista de amigos, solicitudes recibidas y búsqueda para enviar solicitudes.
class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FriendsCubit(GroupRepository(Supabase.instance.client)),
      child: const _FriendsView(),
    );
  }
}

class _FriendsView extends StatelessWidget {
  const _FriendsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amigos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_outlined),
            tooltip: 'Buscar y agregar',
            onPressed: () => _buscar(context),
          ),
        ],
      ),
      body: BlocBuilder<FriendsCubit, FriendsState>(
        builder: (context, state) {
          if (state.cargando) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: () => context.read<FriendsCubit>().cargar(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (state.solicitudes.isNotEmpty) ...[
                  Text('Solicitudes',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  for (final s in state.solicitudes)
                    Card(
                      child: ListTile(
                        leading: MemberAvatar(
                            nombre: s.perfil.nombre.isNotEmpty
                                ? s.perfil.nombre
                                : s.perfil.email,
                            seed: s.perfil.id),
                        title: Text(s.perfil.nombre.isNotEmpty
                            ? s.perfil.nombre
                            : s.perfil.email),
                        subtitle: Text(s.perfil.email),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check_circle,
                                  color: Color(0xFF2A9D5C)),
                              tooltip: 'Aceptar',
                              onPressed: () => context
                                  .read<FriendsCubit>()
                                  .responder(s.id, true),
                            ),
                            IconButton(
                              icon: Icon(Icons.cancel,
                                  color: Theme.of(context).colorScheme.error),
                              tooltip: 'Rechazar',
                              onPressed: () => context
                                  .read<FriendsCubit>()
                                  .responder(s.id, false),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
                Text('Mis amigos',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                if (state.amigos.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Symbols.diversity_3_rounded,
                              size: 44,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant),
                          const SizedBox(height: 8),
                          Text('Aún no tienes amigos',
                              style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 4),
                          Text('Toca el + para buscar por correo o código',
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  )
                else
                  for (final a in state.amigos)
                    Card(
                      child: ListTile(
                        leading: MemberAvatar(
                            nombre: a.nombre.isNotEmpty ? a.nombre : a.email,
                            seed: a.id),
                        title: Text(a.nombre.isNotEmpty ? a.nombre : a.email),
                        subtitle: Text(a.codigoAmigo == null
                            ? a.email
                            : '${a.email} · ${a.codigoAmigo}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.person_remove_outlined),
                          tooltip: 'Eliminar',
                          onPressed: () => _confirmarEliminar(context, a),
                        ),
                      ),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _confirmarEliminar(BuildContext context, PerfilBusqueda a) async {
    final cubit = context.read<FriendsCubit>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar amigo'),
        content: Text('¿Eliminar a ${a.nombre.isNotEmpty ? a.nombre : a.email}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Eliminar')),
        ],
      ),
    );
    if (ok == true) await cubit.eliminar(a.id);
  }

  Future<void> _buscar(BuildContext context) async {
    final cubit = context.read<FriendsCubit>();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const _BuscarAmigoSheet(),
      ),
    );
  }
}

class _BuscarAmigoSheet extends StatefulWidget {
  const _BuscarAmigoSheet();

  @override
  State<_BuscarAmigoSheet> createState() => _BuscarAmigoSheetState();
}

class _BuscarAmigoSheetState extends State<_BuscarAmigoSheet> {
  final _ctrl = TextEditingController();
  List<PerfilBusqueda> _resultados = [];
  bool _buscando = false;
  final Set<String> _enviados = {};

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _buscar() async {
    final texto = _ctrl.text.trim();
    if (texto.isEmpty) return;
    setState(() => _buscando = true);
    try {
      final res = await context.read<FriendsCubit>().buscar(texto);
      if (mounted) setState(() => _resultados = res);
    } finally {
      if (mounted) setState(() => _buscando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          24, 24, 24, MediaQuery.viewInsetsOf(context).bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Agregar amigo',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          TextField(
            controller: _ctrl,
            autofocus: true,
            onSubmitted: (_) => _buscar(),
            decoration: InputDecoration(
              labelText: 'Correo o código de amigo',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: _buscando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.arrow_forward),
                onPressed: _buscando ? null : _buscar,
              ),
            ),
          ),
          const SizedBox(height: 8),
          for (final p in _resultados)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: MemberAvatar(
                  nombre: p.nombre.isNotEmpty ? p.nombre : p.email, seed: p.id),
              title: Text(p.nombre.isNotEmpty ? p.nombre : p.email),
              subtitle: Text(p.email),
              trailing: _enviados.contains(p.id)
                  ? const Text('Enviada')
                  : FilledButton(
                      onPressed: () async {
                        await context.read<FriendsCubit>().solicitar(p.id);
                        if (mounted) setState(() => _enviados.add(p.id));
                      },
                      child: const Text('Agregar'),
                    ),
            ),
          if (_resultados.isEmpty && _ctrl.text.isNotEmpty && !_buscando)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text('Sin resultados.',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
        ],
      ),
    );
  }
}
