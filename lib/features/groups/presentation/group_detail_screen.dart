import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:glint/features/auth/presentation/auth_cubit.dart';
import 'package:glint/features/auth/presentation/auth_state.dart';
import 'package:glint/features/groups/data/group_repository.dart';
import 'package:glint/features/groups/domain/group_detail.dart';
import 'package:glint/features/groups/domain/shared_expense_entity.dart';
import 'package:glint/shared/widgets/skeleton_lista.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'group_categories.dart';
import 'group_colors.dart';
import 'group_detail_cubit.dart';
import 'add_expense_screen.dart';
import 'add_member_sheet.dart';
import 'settle_up_screen.dart';
import 'widgets/balance_bubbles.dart';
import 'widgets/member_avatar.dart';

final _fmtFecha = DateFormat('dd MMM yyyy', 'es');

NumberFormat _fmt(String moneda) =>
    NumberFormat.currency(locale: 'en_US', symbol: _simbolo(moneda));

String _simbolo(String moneda) => switch (moneda) {
      'USD' => '\$',
      'EUR' => '€',
      'GBP' => '£',
      _ => '$moneda ',
    };

/// Detalle de un grupo: saldos, gastos y accesos a añadir gasto / miembros /
/// saldar deudas. Crea su propio [GroupDetailCubit] (Realtime).
class GroupDetailScreen extends StatelessWidget {
  final String grupoId;
  const GroupDetailScreen({super.key, required this.grupoId});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    final usuarioId = authState is AuthAuthenticated ? authState.user.id : '';

    return BlocProvider<GroupDetailCubit>(
      create: (_) => GroupDetailCubit(
        GroupRepository(Supabase.instance.client),
        grupoId,
        usuarioId,
      ),
      child: const _GroupDetailView(),
    );
  }
}

class _GroupDetailView extends StatelessWidget {
  const _GroupDetailView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocBuilder<GroupDetailCubit, GroupDetailState>(
        builder: (context, state) {
          if (state is GroupDetailLoading) {
            return const SkeletonLista();
          }
          if (state is GroupDetailError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Error al cargar el grupo.\n${state.mensaje}',
                    textAlign: TextAlign.center),
              ),
            );
          }
          if (state is GroupDetailLoaded) {
            return _Contenido(detalle: state.detalle);
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: BlocBuilder<GroupDetailCubit, GroupDetailState>(
        builder: (context, state) {
          if (state is! GroupDetailLoaded) return const SizedBox.shrink();
          return FloatingActionButton.extended(
            onPressed: () => _abrirNuevoGasto(context, state.detalle),
            icon: const Icon(Icons.add),
            label: const Text('Gasto'),
          );
        },
      ),
    );
  }

  void _abrirNuevoGasto(BuildContext context, GroupDetail detalle) {
    if (detalle.miembros.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Agrega al menos 2 miembros para registrar un gasto'),
        ),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<GroupDetailCubit>(),
          child: AddExpenseScreen(detalle: detalle),
        ),
      ),
    );
  }
}

// ── Contenido principal ────────────────────────────────────────────────────────

class _Contenido extends StatelessWidget {
  final GroupDetail detalle;
  const _Contenido({required this.detalle});

  @override
  Widget build(BuildContext context) {
    final color = colorDesdeHex(detalle.grupo.color);
    final fmt = _fmt(detalle.grupo.moneda);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 168,
          backgroundColor: color,
          foregroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(iconoDeGrupo(detalle.grupo.emoji), size: 22),
                const SizedBox(width: 8),
                Flexible(child: Text(detalle.grupo.nombre)),
              ],
            ),
            titlePadding: const EdgeInsets.only(left: 56, bottom: 14, right: 56),
            background: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, Color.lerp(color, Colors.black, 0.28)!],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 42),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: AvatarStack(
                      radio: 15,
                      maximo: 6,
                      personas: [
                        for (final m in detalle.miembros)
                          (nombre: m.nombre, seed: m.id, virtual: m.esVirtual),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (v) => _menu(context, v),
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'miembro', child: Text('Añadir miembro')),
                PopupMenuItem(value: 'invitar', child: Text('Invitar por código')),
                PopupMenuItem(value: 'saldar', child: Text('Saldar deudas')),
                PopupMenuItem(value: 'eliminar', child: Text('Eliminar grupo')),
              ],
            ),
          ],
        ),

        // Resumen de saldos
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: _ResumenSaldos(detalle: detalle, fmt: fmt),
          ),
        ),

        // Botón de saldar deudas
        if (detalle.liquidaciones.isNotEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: FilledButton.tonalIcon(
                onPressed: () => _abrirSaldar(context),
                icon: const Icon(Icons.handshake_outlined),
                label: Text(
                  'Saldar deudas (${detalle.liquidaciones.length} ${detalle.liquidaciones.length == 1 ? 'pago' : 'pagos'})',
                ),
              ),
            ),
          ),

        // Encabezado gastos
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Movimientos',
                    style: Theme.of(context).textTheme.titleMedium),
                Text('Total: ${fmt.format(detalle.totalGastado)}',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ),

        if (detalle.gastos.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text('Aún no hay gastos.\nToca "Gasto" para añadir el primero.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            sliver: SliverList.builder(
              itemCount: detalle.gastos.length,
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _GastoCard(gasto: detalle.gastos[i], detalle: detalle, fmt: fmt)
                    .animate()
                    .fadeIn(duration: 260.ms, delay: (i * 40).ms)
                    .slideY(begin: 0.15, curve: Curves.easeOut),
              ),
            ),
          ),
      ],
    );
  }

  // ── Acciones del menú ─────────────────────────────────────────────────────
  Future<void> _menu(BuildContext context, String v) async {
    final cubit = context.read<GroupDetailCubit>();
    switch (v) {
      case 'miembro':
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (_) => BlocProvider.value(
            value: cubit,
            child: const AddMemberSheet(),
          ),
        );
        break;
      case 'invitar':
        await _mostrarInvitacion(context, cubit);
        break;
      case 'saldar':
        _abrirSaldar(context);
        break;
      case 'eliminar':
        await _confirmarEliminar(context, cubit);
        break;
    }
  }

  void _abrirSaldar(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<GroupDetailCubit>(),
          child: SettleUpScreen(detalle: detalle, fmt: _fmt(detalle.grupo.moneda)),
        ),
      ),
    );
  }

  Future<void> _mostrarInvitacion(
      BuildContext context, GroupDetailCubit cubit) async {
    final messenger = ScaffoldMessenger.of(context);
    String? codigo;
    try {
      codigo = await cubit.crearInvitacion();
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('No se pudo crear la invitación')),
      );
      return;
    }
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Invitar por código'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Comparte este código. Quien lo use se unirá al grupo:'),
            const SizedBox(height: 16),
            SelectableText(
              codigo!,
              style: Theme.of(ctx).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: codigo!));
              Navigator.pop(ctx);
            },
            child: const Text('Copiar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Listo'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmarEliminar(
      BuildContext context, GroupDetailCubit cubit) async {
    final nav = Navigator.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar grupo'),
        content: Text(
            '¿Eliminar "${detalle.grupo.nombre}"? Se borrarán todos sus gastos para todos los miembros.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await cubit.eliminarGrupo();
      nav.pop(); // volver a la lista de grupos
    }
  }
}

// ── Resumen de saldos (burbujas animadas) ─────────────────────────────────────

class _ResumenSaldos extends StatelessWidget {
  final GroupDetail detalle;
  final NumberFormat fmt;
  const _ResumenSaldos({required this.detalle, required this.fmt});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        child: BalanceBubbles(balances: detalle.balances, fmt: fmt),
      ),
    );
  }
}

// ── Card de gasto ──────────────────────────────────────────────────────────────

class _GastoCard extends StatelessWidget {
  final SharedExpenseEntity gasto;
  final GroupDetail detalle;
  final NumberFormat fmt;
  const _GastoCard({required this.gasto, required this.detalle, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final pagador = detalle.miembroPorId(gasto.pagadoPor)?.nombre ?? '¿?';
    final esTransfer = gasto.esTransferencia;
    final subtitulo = esTransfer
        ? '$pagador → ${detalle.miembroPorId(gasto.transferidoA ?? '')?.nombre ?? '¿?'}'
        : '$pagador pagó';

    return Dismissible(
      key: Key(gasto.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: cs.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(Icons.delete_outline, color: cs.onError),
      ),
      confirmDismiss: (_) => showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Eliminar movimiento'),
          content: Text('¿Eliminar "${gasto.descripcion}"?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancelar')),
            FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Eliminar')),
          ],
        ),
      ),
      onDismissed: (_) => context.read<GroupDetailCubit>().eliminarGasto(gasto.id),
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          leading: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: (esTransfer ? const Color(0xFF2A9D5C) : cs.primary)
                  .withAlpha(28),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Icon(
                  esTransfer
                      ? Symbols.handshake_rounded
                      : iconoDeCategoriaGasto(gasto.categoria),
                  size: 24,
                  color: esTransfer ? const Color(0xFF2A9D5C) : cs.primary),
            ),
          ),
          title: Text(
            gasto.descripcion.isEmpty
                ? (esTransfer ? 'Pago de deudas' : 'Gasto')
                : gasto.descripcion,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                if (!esTransfer)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: MemberAvatar(
                        nombre: pagador, seed: gasto.pagadoPor, radio: 9),
                  ),
                Flexible(
                  child: Text('$subtitulo · ${_fmtFecha.format(gasto.fecha)}',
                      overflow: TextOverflow.ellipsis),
                ),
                if (!esTransfer && gasto.partes.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  AvatarStack(
                    radio: 9,
                    personas: [
                      for (final p in gasto.partes)
                        (
                          nombre: detalle.miembroPorId(p.miembroId)?.nombre ?? '?',
                          seed: p.miembroId,
                          virtual:
                              detalle.miembroPorId(p.miembroId)?.esVirtual ?? false,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          trailing: Text(
            fmt.format(gasto.monto),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: esTransfer ? const Color(0xFF2A9D5C) : null,
                ),
          ),
          // Las transferencias no se editan (son pagos); los gastos sí.
          onTap: esTransfer ? null : () => _editar(context),
        ),
      ),
    );
  }

  void _editar(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<GroupDetailCubit>(),
          child: AddExpenseScreen(detalle: detalle, gastoEditar: gasto),
        ),
      ),
    );
  }
}
