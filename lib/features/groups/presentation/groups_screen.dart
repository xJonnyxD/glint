import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:glint/core/constants/app_constants.dart';
import 'package:glint/features/groups/domain/group_entity.dart';
import 'package:glint/shared/widgets/estado_vacio.dart';
import 'package:glint/shared/widgets/skeleton_lista.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'groups_cubit.dart';
import 'group_categories.dart';
import 'group_colors.dart';
import 'group_detail_screen.dart';

/// Lista de grupos de gastos compartidos del usuario.
class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocBuilder<GroupsCubit, GroupsState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                title: const Text('Gastos compartidos'),
                actions: [
                  IconButton(
                    icon: const Icon(Symbols.people_alt_rounded),
                    tooltip: 'Amigos',
                    onPressed: () => context.push(AppRoutes.friends),
                  ),
                  IconButton(
                    icon: const Icon(Symbols.group_add_rounded),
                    tooltip: 'Unirme con un código',
                    onPressed: () => _unirsePorCodigo(context),
                  ),
                ],
              ),
              if (state is GroupsLoading)
                const SliverFillRemaining(child: SkeletonLista())
              else if (state is GroupsError)
                SliverFillRemaining(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'No se pudieron cargar los grupos.\n${state.mensaje}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                )
              else if (state is GroupsLoaded && state.grupos.isEmpty)
                SliverFillRemaining(child: _EstadoVacio())
              else if (state is GroupsLoaded)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                  sliver: SliverList.builder(
                    itemCount: state.grupos.length,
                    itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _GrupoCard(grupo: state.grupos[i])
                          .animate()
                          .fadeIn(duration: 260.ms, delay: (i * 50).ms)
                          .slideX(begin: 0.12, curve: Curves.easeOut),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _crearGrupo(context),
        icon: const Icon(Symbols.add_rounded),
        label: const Text('Nuevo grupo'),
      ),
    );
  }

  void _crearGrupo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<GroupsCubit>(),
        child: const _NuevoGrupoSheet(),
      ),
    );
  }

  Future<void> _unirsePorCodigo(BuildContext context) async {
    final ctrl = TextEditingController();
    final cubit = context.read<GroupsCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final codigo = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Unirme a un grupo'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            labelText: 'Código de invitación',
            hintText: 'Ej. ABCD2345',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('Unirme'),
          ),
        ],
      ),
    );
    if (codigo == null || codigo.isEmpty) return;
    try {
      await cubit.unirsePorCodigo(codigo);
      messenger.showSnackBar(
        const SnackBar(content: Text('¡Te uniste al grupo!')),
      );
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Código no válido o vencido')),
      );
    }
  }
}

// ── Card de grupo ─────────────────────────────────────────────────────────────

class _GrupoCard extends StatelessWidget {
  final GroupEntity grupo;
  const _GrupoCard({required this.grupo});

  @override
  Widget build(BuildContext context) {
    final color = colorDesdeHex(grupo.color);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, Color.lerp(color, Colors.black, 0.28)!],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: color.withAlpha(70),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Icon(iconoDeGrupo(grupo.emoji),
                size: 26, color: Colors.white),
          ),
        ),
        title: Text(
          grupo.nombre,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text('Moneda: ${grupo.moneda}'),
        trailing: const Icon(Symbols.chevron_right_rounded),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => GroupDetailScreen(grupoId: grupo.id),
          ),
        ),
      ),
    );
  }
}

// ── Estado vacío ───────────────────────────────────────────────────────────────

class _EstadoVacio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const EstadoVacio(
      icono: Symbols.group_rounded,
      titulo: 'Aún no tienes grupos',
      subtitulo: 'Crea uno para dividir gastos con amigos,\n'
          'compañeros de piso o en un viaje.',
    );
  }
}

// ── Sheet: nuevo grupo ─────────────────────────────────────────────────────────

class _NuevoGrupoSheet extends StatefulWidget {
  const _NuevoGrupoSheet();

  @override
  State<_NuevoGrupoSheet> createState() => _NuevoGrupoSheetState();
}

class _NuevoGrupoSheetState extends State<_NuevoGrupoSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  String _emoji = '👥';
  String _color = grupoColores.first;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final cubit = context.read<GroupsCubit>();
    final nav = Navigator.of(context);
    await cubit.crearGrupo(
      _nombreCtrl.text.trim(),
      emoji: _emoji,
      color: _color,
    );
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
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Nuevo grupo',
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                  IconButton(
                    icon: const Icon(Symbols.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nombreCtrl,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Nombre del grupo',
                  hintText: 'Ej. Viaje al sur, Piso compartido',
                  prefixIcon: Icon(Symbols.groups_rounded),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Ponle un nombre' : null,
              ),
              const SizedBox(height: 20),
              Text('Icono', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  for (final e in iconosGrupo.entries)
                    ChoiceChip(
                      label: Icon(e.value, size: 22),
                      selected: _emoji == e.key,
                      onSelected: (_) => setState(() => _emoji = e.key),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Color', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10,
                children: [
                  for (final c in grupoColores)
                    GestureDetector(
                      onTap: () => setState(() => _color = c),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: colorDesdeHex(c),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _color == c
                                ? Theme.of(context).colorScheme.onSurface
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _guardar,
                child: const Text('Crear grupo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
