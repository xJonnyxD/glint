import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:glint/features/groups/data/group_repository.dart';
import 'group_detail_cubit.dart';
import 'widgets/member_avatar.dart';

/// Hoja para añadir un miembro al grupo: una persona real (buscada por correo o
/// código de amigo) o un miembro "virtual" (sin cuenta).
class AddMemberSheet extends StatefulWidget {
  const AddMemberSheet({super.key});

  @override
  State<AddMemberSheet> createState() => _AddMemberSheetState();
}

class _AddMemberSheetState extends State<AddMemberSheet> {
  final _buscarCtrl = TextEditingController();
  final _virtualCtrl = TextEditingController();
  List<PerfilBusqueda> _resultados = [];
  List<PerfilBusqueda> _amigos = [];
  bool _buscando = false;

  @override
  void initState() {
    super.initState();
    // Cargar la lista de amigos para poder añadirlos con un toque.
    context.read<GroupDetailCubit>().obtenerAmigos().then((lista) {
      if (mounted) setState(() => _amigos = lista);
    }).catchError((_) {});
  }

  @override
  void dispose() {
    _buscarCtrl.dispose();
    _virtualCtrl.dispose();
    super.dispose();
  }

  Future<void> _buscar() async {
    final texto = _buscarCtrl.text.trim();
    if (texto.isEmpty) return;
    setState(() => _buscando = true);
    try {
      final res = await context.read<GroupDetailCubit>().buscarPerfil(texto);
      if (mounted) setState(() => _resultados = res);
    } finally {
      if (mounted) setState(() => _buscando = false);
    }
  }

  Future<void> _agregarReal(PerfilBusqueda p) async {
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    try {
      await context.read<GroupDetailCubit>().agregarMiembroReal(p);
      nav.pop();
      messenger.showSnackBar(
        SnackBar(content: Text('${p.nombre.isNotEmpty ? p.nombre : p.email} añadido')),
      );
    } catch (_) {
      // Por seguridad, solo puedes añadir directamente a tus amigos; a los demás
      // se les invita por código (SEC-14). No cerramos el sheet para reintentar.
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Solo puedes añadir directamente a tus amigos. '
              'Para el resto, usa "Invitar por código".'),
        ),
      );
    }
  }

  Future<void> _agregarVirtual() async {
    final nombre = _virtualCtrl.text.trim();
    if (nombre.isEmpty) return;
    final nav = Navigator.of(context);
    await context.read<GroupDetailCubit>().agregarMiembroVirtual(nombre);
    nav.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Añadir miembro',
                      style: Theme.of(context).textTheme.titleLarge),
                ),
                IconButton(
                  icon: const Icon(Symbols.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Amigos (añadir con un toque) ──────────────────────────────
            if (_amigos.isNotEmpty) ...[
              Text('Tus amigos',
                  style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final a in _amigos)
                    ActionChip(
                      avatar: MemberAvatar(
                          nombre: a.nombre.isNotEmpty ? a.nombre : a.email,
                          seed: a.id,
                          radio: 11),
                      label: Text(a.nombre.isNotEmpty ? a.nombre : a.email),
                      onPressed: () => _agregarReal(a),
                    ),
                ],
              ),
              const Divider(height: 28),
            ],

            // ── Persona real ──────────────────────────────────────────────
            Text('Invitar a alguien de Glint',
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _buscarCtrl,
              onSubmitted: (_) => _buscar(),
              decoration: InputDecoration(
                labelText: 'Correo o código de amigo',
                prefixIcon: const Icon(Symbols.search_rounded),
                suffixIcon: IconButton(
                  icon: _buscando
                      ? const SizedBox(
                          width: 18, height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Symbols.arrow_forward_rounded),
                  onPressed: _buscando ? null : _buscar,
                ),
              ),
            ),
            const SizedBox(height: 8),
            for (final p in _resultados)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  child: Text(p.nombre.isNotEmpty
                      ? p.nombre.characters.first.toUpperCase()
                      : '?'),
                ),
                title: Text(p.nombre.isNotEmpty ? p.nombre : p.email),
                subtitle: Text(p.email),
                trailing: FilledButton(
                  onPressed: () => _agregarReal(p),
                  child: const Text('Añadir'),
                ),
              ),
            if (_resultados.isEmpty && _buscarCtrl.text.isNotEmpty && !_buscando)
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                child: Text('Sin resultados. También puedes invitar por código.',
                    style: Theme.of(context).textTheme.bodySmall),
              ),

            const Divider(height: 32),

            // ── Miembro virtual ──────────────────────────────────────────
            Text('O añade a alguien sin cuenta',
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            TextField(
              controller: _virtualCtrl,
              onSubmitted: (_) => _agregarVirtual(),
              decoration: const InputDecoration(
                labelText: 'Nombre (ej. Pablo)',
                prefixIcon: Icon(Symbols.person_add_rounded),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _agregarVirtual,
              icon: const Icon(Symbols.add_rounded),
              label: const Text('Añadir persona'),
            ),
          ],
        ),
      ),
    );
  }
}
