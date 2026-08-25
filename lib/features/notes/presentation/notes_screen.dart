import 'package:material_symbols_icons/symbols.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:glint/core/icons/app_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glint/features/notes/data/note_draft_repository.dart';
import 'package:glint/features/notes/domain/note_entity.dart';
import 'package:glint/shared/services/sync_manager.dart';
import 'package:glint/shared/widgets/aparecer.dart';
import 'package:glint/shared/widgets/estado_vacio.dart';
import 'package:glint/shared/widgets/skeleton_lista.dart';
import 'note_cubit.dart';
import 'note_state.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  bool _searchVisible = false;
  CategoriaNote? _categoriaFiltro;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  Color _hexToColor(String hex) {
    final h = hex.replaceAll('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NoteCubit, NoteState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => SyncManager.instance.refrescar(),
            child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              _buildAppBar(context, state),
              if (_searchVisible) _buildSearchBar(context),
              if (state is NoteLoading)
                const SliverFillRemaining(child: SkeletonLista())
              else if (state is NoteLoaded)
                _buildContent(context, state)
              else
                const SliverFillRemaining(
                  child: Center(child: Text('Error al cargar notas')),
                ),
            ],
          ),
          );
        },
      ),
      floatingActionButton: _buildFab(context),
    );
  }

  // ─────────────────────── APP BAR ───────────────────────

  SliverAppBar _buildAppBar(BuildContext context, NoteState state) {
    final count = state is NoteLoaded ? state.total : 0;
    return SliverAppBar(
      floating: true,
      snap: true,
      centerTitle: false,
      title: const Text(
        'Notas',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      actions: [
        if (state is NoteLoaded && count > 0)
          IconButton(
            icon: Icon(
              _searchVisible ? Symbols.search_off_rounded : Symbols.search_rounded,
            ),
            tooltip: 'Buscar',
            onPressed: () {
              setState(() {
                _searchVisible = !_searchVisible;
                if (!_searchVisible) {
                  _searchCtrl.clear();
                  _categoriaFiltro = null;
                  context.read<NoteCubit>().buscar('');
                  context.read<NoteCubit>().filtrarCategoria(null);
                }
              });
            },
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  // ─────────────────────── SEARCH BAR ───────────────────────

  SliverToBoxAdapter _buildSearchBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchCtrl,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Buscar en título, texto, etiquetas y listas...',
                prefixIcon: const Icon(Symbols.search_rounded),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Symbols.close_rounded),
                        onPressed: () {
                          _searchCtrl.clear();
                          context.read<NoteCubit>().buscar('');
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (v) {
                setState(() {});
                _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 300), () {
                  context.read<NoteCubit>().buscar(v);
                });
              },
            ),
            const SizedBox(height: 8),
            // Filtro por categoría
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ChoiceChip(
                    label: const Text('Todas'),
                    selected: _categoriaFiltro == null,
                    onSelected: (_) {
                      setState(() => _categoriaFiltro = null);
                      context.read<NoteCubit>().filtrarCategoria(null);
                    },
                  ),
                  const SizedBox(width: 8),
                  for (final c in CategoriaNote.values) ...[
                    ChoiceChip(
                      avatar: Icon(c.icono, size: 16),
                      label: Text(c.nombre),
                      selected: _categoriaFiltro == c,
                      onSelected: (_) {
                        setState(() => _categoriaFiltro = c);
                        context.read<NoteCubit>().filtrarCategoria(c);
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────── CONTENT ───────────────────────

  Widget _buildContent(BuildContext context, NoteLoaded state) {
    final lista = state.hayFiltro ? state.filtradas : state.notas;

    if (lista.isEmpty) {
      return SliverFillRemaining(
        child: state.hayFiltro
            ? const EstadoVacio(
                icono: AppIcons.search,
                titulo: 'Sin resultados',
                subtitulo: 'Prueba con otra búsqueda o categoría')
            : _buildEmptyState(),
      );
    }

    final fijadas = lista.where((n) => n.esFijada).toList();
    final normales = lista.where((n) => !n.esFijada).toList();

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          if (fijadas.isNotEmpty) ...[
            _buildSectionHeader(context, 'Fijadas', Symbols.push_pin_rounded),
            const SizedBox(height: 8),
            _buildGrid(context, fijadas),
            const SizedBox(height: 16),
          ],
          if (normales.isNotEmpty) ...[
            if (fijadas.isNotEmpty)
              _buildSectionHeader(context, 'Otras notas', Symbols.notes_rounded),
            if (fijadas.isNotEmpty) const SizedBox(height: 8),
            _buildGrid(context, normales),
          ],
        ]),
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String titulo, IconData icono) {
    return Row(
      children: [
        Icon(icono,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Text(
          titulo.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(BuildContext context, List<NoteEntity> notas) {
    // 2-column staggered grid using Wrap
    final List<Widget> col1 = [];
    final List<Widget> col2 = [];
    for (int i = 0; i < notas.length; i++) {
      final card = Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Aparecer(
          indice: i,
          child: _NoteCard(
            nota: notas[i],
            hexToColor: _hexToColor,
            onTap: () => _abrirEditar(context, notas[i]),
            onLongPress: () => _mostrarOpcionesNota(context, notas[i]),
            onDismissed: () => _confirmarEliminar(context, notas[i].id),
          ),
        ),
      );
      if (i.isEven) {
        col1.add(card);
      } else {
        col2.add(card);
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Column(children: col1)),
        const SizedBox(width: 10),
        Expanded(child: Column(children: col2)),
      ],
    );
  }

  // ─────────────────────── EMPTY STATE ───────────────────────

  Widget _buildEmptyState() {
    return const EstadoVacio(
      icono: AppIcons.notes,
      titulo: 'Crea tu primera nota',
      subtitulo: 'Toca el botón + para empezar',
    );
  }

  // ─────────────────────── FAB ───────────────────────

  Widget _buildFab(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        FloatingActionButton.extended(
          heroTag: 'fab_lista',
          onPressed: () => _abrirCrear(context, esChecklist: true),
          icon: const Icon(Symbols.checklist_rounded),
          label: const Text('Lista'),
          backgroundColor:
              Theme.of(context).colorScheme.secondaryContainer,
          foregroundColor:
              Theme.of(context).colorScheme.onSecondaryContainer,
        ),
        const SizedBox(height: 12),
        FloatingActionButton.extended(
          heroTag: 'fab_nota',
          onPressed: () => _abrirCrear(context, esChecklist: false),
          icon: const Icon(Symbols.edit_note_rounded),
          label: const Text('Nota'),
        ),
      ],
    );
  }

  // ─────────────────────── DIALOGS / SHEETS ───────────────────────

  void _abrirCrear(BuildContext context, {required bool esChecklist}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<NoteCubit>(),
        child: _NoteEditSheet(
          esChecklist: esChecklist,
          hexToColor: _hexToColor,
        ),
      ),
    );
  }

  void _abrirEditar(BuildContext context, NoteEntity nota) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<NoteCubit>(),
        child: _NoteEditSheet(
          nota: nota,
          esChecklist: nota.esChecklist,
          hexToColor: _hexToColor,
        ),
      ),
    );
  }

  void _mostrarOpcionesNota(BuildContext context, NoteEntity nota) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => BlocProvider.value(
        value: context.read<NoteCubit>(),
        child: _NoteOptionsSheet(
          nota: nota,
          onEdit: () {
            Navigator.pop(ctx);
            _abrirEditar(context, nota);
          },
        ),
      ),
    );
  }

  Future<void> _confirmarEliminar(BuildContext context, String id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar nota'),
        content: const Text('¿Estás seguro de que deseas eliminar esta nota?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      context.read<NoteCubit>().eliminarNota(id);
    }
  }
}

// ═══════════════════════════════════════════════════════════════
//  NOTE CARD
// ═══════════════════════════════════════════════════════════════

class _NoteCard extends StatelessWidget {
  final NoteEntity nota;
  final Color Function(String) hexToColor;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onDismissed;

  const _NoteCard({
    required this.nota,
    required this.hexToColor,
    required this.onTap,
    required this.onLongPress,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = hexToColor(nota.color);
    return Dismissible(
      key: ValueKey(nota.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          Symbols.delete_rounded,
          color: Theme.of(context).colorScheme.error,
        ),
      ),
      confirmDismiss: (_) async {
        onDismissed();
        return false; // We handle deletion ourselves via dialog
      },
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: cardColor.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 36, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Título
                    if (nota.titulo.isNotEmpty) ...[
                      Text(
                        nota.titulo,
                        // Fondo pastel claro en ambos temas → texto negro fijo.
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          height: 1.3,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                    ],
                    // Contenido o checklist
                    if (nota.esChecklist)
                      _buildChecklistPreview(nota.items)
                    else if (nota.contenido.isNotEmpty)
                      Text(
                        nota.contenido,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: Colors.black87,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8),
                    // Categoría
                    Row(
                      children: [
                        Icon(nota.categoria.icono, size: 13),
                        const SizedBox(width: 4),
                        Text(
                          nota.categoria.nombre,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                    // Tags chips
                    if (nota.tags.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: nota.tags
                            .split(',')
                            .map((t) => t.trim())
                            .where((t) => t.isNotEmpty)
                            .map((t) => Chip(
                                  label: Text(t,
                                      style: const TextStyle(fontSize: 11)),
                                  padding: EdgeInsets.zero,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor:
                                      Colors.black.withValues(alpha: 0.08),
                                  side: BorderSide.none,
                                ))
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
              // Pin icon
              if (nota.esFijada)
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(Symbols.push_pin_rounded, size: 16, color: Colors.black54),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChecklistPreview(List<ChecklistItem> items) {
    final preview = items.take(4).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ...preview.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    item.completado
                        ? Symbols.check_box_rounded
                        : Symbols.check_box_outline_blank_rounded,
                    size: 14,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      item.texto,
                      style: TextStyle(
                        fontSize: 12,
                        decoration: item.completado
                            ? TextDecoration.lineThrough
                            : null,
                        color:
                            item.completado ? Colors.black45 : Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )),
        if (items.length > 4)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              '+ ${items.length - 4} más',
              style: const TextStyle(fontSize: 11, color: Colors.black45),
            ),
          ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  NOTE OPTIONS SHEET (long press)
// ═══════════════════════════════════════════════════════════════

class _NoteOptionsSheet extends StatelessWidget {
  final NoteEntity nota;
  final VoidCallback onEdit;

  const _NoteOptionsSheet({required this.nota, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Symbols.edit_rounded),
            title: const Text('Editar'),
            onTap: onEdit,
          ),
          ListTile(
            leading: Icon(nota.esFijada
                ? Symbols.push_pin_rounded
                : Symbols.push_pin_rounded),
            title: Text(nota.esFijada ? 'Quitar fijado' : 'Fijar nota'),
            onTap: () {
              context.read<NoteCubit>().toggleFijada(nota);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Symbols.delete_rounded,
                color: Theme.of(context).colorScheme.error),
            title: Text('Eliminar',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.error)),
            onTap: () async {
              Navigator.pop(context);
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Eliminar nota'),
                  content: const Text(
                      '¿Estás seguro de que deseas eliminar esta nota?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancelar')),
                    FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            Theme.of(ctx).colorScheme.error,
                      ),
                      child: const Text('Eliminar'),
                    ),
                  ],
                ),
              );
              if (ok == true && context.mounted) {
                context.read<NoteCubit>().eliminarNota(nota.id);
              }
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  NOTE EDIT SHEET (create / edit)
// ═══════════════════════════════════════════════════════════════

class _NoteEditSheet extends StatefulWidget {
  final NoteEntity? nota;
  final bool esChecklist;
  final Color Function(String) hexToColor;

  const _NoteEditSheet({
    this.nota,
    required this.esChecklist,
    required this.hexToColor,
  });

  @override
  State<_NoteEditSheet> createState() => _NoteEditSheetState();
}

class _NoteEditSheetState extends State<_NoteEditSheet>
    with WidgetsBindingObserver {
  late TextEditingController _tituloCtrl;
  late TextEditingController _contenidoCtrl;
  late TextEditingController _tagsCtrl;
  late CategoriaNote _categoria;
  late String _color;
  late bool _esFijada;
  late List<ChecklistItem> _items;
  late bool _esChecklist;
  final List<TextEditingController> _itemCtrlList = [];

  // ── Borrador ──────────────────────────────────────────────────────────────
  late final NoteDraftRepository _borradores;
  late final String _usuarioId;

  /// Clave del borrador: el id de la nota, o `nueva` si aún no existe.
  String get _claveBorrador => widget.nota?.id ?? NoteDraftRepository.claveNueva;

  Timer? _debounce;

  /// Lo que había al abrir, para saber si de verdad se ha cambiado algo.
  late String _tituloInicial;
  late String _contenidoInicial;
  late String _tagsInicial;
  late List<String> _itemsInicial;

  bool _guardadoDefinitivo = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final n = widget.nota;
    _tituloCtrl = TextEditingController(text: n?.titulo ?? '');
    _contenidoCtrl = TextEditingController(text: n?.contenido ?? '');
    _tagsCtrl = TextEditingController(text: n?.tags ?? '');
    _categoria = n?.categoria ?? CategoriaNote.personal;
    _color = n?.color ?? '#FFF9C4';
    _esFijada = n?.esFijada ?? false;
    _esChecklist = widget.esChecklist;
    _items = n?.items.map((i) => i).toList() ?? [];
    if (_esChecklist && _items.isEmpty) {
      _items.add(const ChecklistItem(texto: '', completado: false));
    }
    for (final item in _items) {
      _itemCtrlList.add(TextEditingController(text: item.texto));
    }

    _guardarEstadoInicial();

    _borradores = NoteDraftRepository(SyncManager.instance.baseDatos);
    _usuarioId = context.read<NoteCubit>().usuarioId;

    // Escribir en cada tecla castigaría la batería y el disco; medio segundo
    // de calma basta para no perder nada.
    for (final c in [_tituloCtrl, _contenidoCtrl, _tagsCtrl]) {
      c.addListener(_programarGuardado);
    }

    _restaurarBorrador();
  }

  void _guardarEstadoInicial() {
    _tituloInicial = _tituloCtrl.text;
    _contenidoInicial = _contenidoCtrl.text;
    _tagsInicial = _tagsCtrl.text;
    _itemsInicial = [for (final c in _itemCtrlList) c.text];
  }

  /// Recupera lo que quedó a medias la última vez.
  Future<void> _restaurarBorrador() async {
    final b = await _borradores.leer(_usuarioId, _claveBorrador);
    if (b == null || !mounted) return;

    setState(() {
      _tituloCtrl.text = b.titulo;
      _contenidoCtrl.text = b.contenido;
      _tagsCtrl.text = b.tags;
      _categoria = b.categoria;
      _color = b.color;
      _esFijada = b.esFijada;
      _esChecklist = b.esChecklist;

      if (b.items.isNotEmpty) {
        for (final c in _itemCtrlList) {
          c.dispose();
        }
        _itemCtrlList
          ..clear()
          ..addAll([for (final i in b.items) TextEditingController(text: i.texto)]);
        _items = List.of(b.items);
      }
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recuperamos lo que estabas escribiendo'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _programarGuardado() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), _guardarBorrador);
  }

  Future<void> _guardarBorrador() async {
    if (_guardadoDefinitivo) return;
    await _borradores.guardar(_usuarioId, _claveBorrador, _borradorActual());
  }

  BorradorNota _borradorActual() => BorradorNota(
        titulo: _tituloCtrl.text,
        contenido: _contenidoCtrl.text,
        tags: _tagsCtrl.text,
        items: _esChecklist ? _buildItems() : const [],
        categoria: _categoria,
        color: _color,
        esFijada: _esFijada,
        esChecklist: _esChecklist,
      );

  /// ¿Se ha tocado algo desde que se abrió el editor?
  bool get _hayCambios {
    if (_tituloCtrl.text != _tituloInicial) return true;
    if (_contenidoCtrl.text != _contenidoInicial) return true;
    if (_tagsCtrl.text != _tagsInicial) return true;
    final itemsAhora = [for (final c in _itemCtrlList) c.text];
    if (itemsAhora.length != _itemsInicial.length) return true;
    for (var i = 0; i < itemsAhora.length; i++) {
      if (itemsAhora[i] != _itemsInicial[i]) return true;
    }
    return false;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Al minimizar o cambiar de app, guardar YA: puede que el sistema mate la
    // app sin avisar y el temporizador del autoguardado no llegue a saltar.
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _debounce?.cancel();
      _guardarBorrador();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _debounce?.cancel();
    _tituloCtrl.dispose();
    _contenidoCtrl.dispose();
    _tagsCtrl.dispose();
    for (final c in _itemCtrlList) {
      c.dispose();
    }
    super.dispose();
  }

  void _addItem() {
    setState(() {
      _items.add(const ChecklistItem(texto: '', completado: false));
      _itemCtrlList.add(TextEditingController());
    });
  }

  void _toggleItemCompletado(int index) {
    setState(() {
      _items[index] =
          _items[index].copyWith(completado: !_items[index].completado);
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
      _itemCtrlList[index].dispose();
      _itemCtrlList.removeAt(index);
    });
  }

  List<ChecklistItem> _buildItems() {
    return List.generate(
      _items.length,
      (i) => ChecklistItem(
        texto: _itemCtrlList[i].text.trim(),
        completado: _items[i].completado,
      ),
    );
  }

  /// Qué hacer cuando el usuario pulsa atrás o arrastra el panel para cerrarlo.
  ///
  /// Devuelve `true` si se puede cerrar. Tres casos, según lo acordado:
  ///  · nota nueva y vacía → se cierra sin crear nada,
  ///  · nota nueva con algo escrito → se guarda el borrador y se avisa,
  ///  · nota existente con cambios → se pregunta qué hacer.
  Future<bool> _alIntentarSalir() async {
    final esNueva = widget.nota == null;

    if (!_hayCambios) {
      await _borradores.descartar(_usuarioId, _claveBorrador);
      return true;
    }

    if (esNueva) {
      if (_borradorActual().vacio) {
        // Ni título ni texto: no hay nada que conservar.
        await _borradores.descartar(_usuarioId, _claveBorrador);
        return true;
      }
      _debounce?.cancel();
      await _guardarBorrador();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Borrador guardado'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return true;
    }

    // Nota que ya existía y se ha modificado.
    final decision = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tienes cambios sin guardar'),
        content: const Text('¿Qué quieres hacer con lo que has escrito?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'cancelar'),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'descartar'),
            child: const Text('Descartar cambios'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, 'guardar'),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (!mounted) return false;

    switch (decision) {
      case 'guardar':
        await _guardar(context);
        return false; // _guardar ya cierra el panel
      case 'descartar':
        await _borradores.descartar(_usuarioId, _claveBorrador);
        return true;
      default:
        return false; // cancelar: seguir editando
    }
  }

  Future<void> _guardar(BuildContext context) async {
    final titulo = _tituloCtrl.text.trim();
    final contenido = _contenidoCtrl.text.trim();
    final tags = _tagsCtrl.text.trim();
    final items = _esChecklist ? _buildItems() : <ChecklistItem>[];

    if (titulo.isEmpty && contenido.isEmpty && items.every((i) => i.texto.isEmpty)) {
      await _borradores.descartar(_usuarioId, _claveBorrador);
      if (context.mounted) Navigator.pop(context);
      return;
    }

    final cubit = context.read<NoteCubit>();

    try {
      if (widget.nota == null) {
        await cubit.crearNota(
          titulo: titulo,
          contenido: contenido,
          categoria: _categoria,
          color: _color,
          esChecklist: _esChecklist,
          items: items,
          tags: tags,
        );
      } else {
        await cubit.actualizarNota(widget.nota!.copyWith(
          titulo: titulo,
          contenido: contenido,
          categoria: _categoria,
          color: _color,
          esFijada: _esFijada,
          esChecklist: _esChecklist,
          items: items,
          tags: tags,
        ));
      }
      // Ya está a salvo como nota: el borrador sobra y no debe reaparecer la
      // próxima vez que se abra.
      _guardadoDefinitivo = true;
      _debounce?.cancel();
      await _borradores.descartar(_usuarioId, _claveBorrador);
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString().length > 120 ? e.toString().substring(0, 120) : e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 6),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // canPop: false para poder decidir nosotros qué pasa con lo escrito antes
    // de que el panel se cierre. Sin esto, "atrás" lo cerraba de golpe y se
    // perdía todo.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        // Se guarda el navegador ANTES del await: usar `context` después de
        // una espera es lo que avisa el analizador, porque el widget podría
        // haberse desmontado entre medias.
        final navegador = Navigator.of(context);
        final puedeSalir = await _alIntentarSalir();
        if (puedeSalir && mounted) navegador.pop();
      },
      child: _construirPanel(context),
    );
  }

  Widget _construirPanel(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (ctx, scrollCtrl) {
        return Theme(
          // El papel de la nota es siempre un pastel claro, en tema claro y en
          // oscuro. Pero el tema global de la app pinta los campos de texto con
          // `filled: true` y un fondo oscuro: en modo oscuro eso dejaba un
          // rectángulo negro debajo del texto (que va en negro), y no se leía
          // NADA de lo que se escribía.
          //
          // Aquí se anula para todo el editor de una vez, en lugar de ir campo
          // por campo: sin relleno, y con el cursor y la selección en tonos que
          // se ven sobre el pastel.
          data: Theme.of(ctx).copyWith(
            inputDecorationTheme: const InputDecorationTheme(
              filled: false,
              fillColor: Colors.transparent,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintStyle: TextStyle(color: Colors.black54),
              labelStyle: TextStyle(color: Colors.black54),
            ),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Colors.black87,
              selectionColor: Colors.black.withValues(alpha: 0.20),
              selectionHandleColor: Colors.black54,
            ),
          ),
          child: Container(
          decoration: BoxDecoration(
            color: widget.hexToColor(_color),
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Toolbar
              _buildToolbar(context),
              const Divider(height: 1, color: Colors.black12),
              // Scrollable body
              Expanded(
                child: ListView(
                  controller: scrollCtrl,
                  padding: EdgeInsets.fromLTRB(
                      20,
                      16,
                      20,
                      MediaQuery.of(context).viewInsets.bottom + 16),
                  children: [
                    // Título
                    TextField(
                      controller: _tituloCtrl,
                      // El fondo de la nota es siempre un pastel claro (en ambos
                      // temas), así que el texto va en negro fijo; si no, en
                      // tema oscuro heredaría blanco y quedaría invisible.
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Título',
                        hintStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: null,
                    ),
                    const SizedBox(height: 8),
                    // Contenido o checklist
                    if (_esChecklist)
                      _buildChecklistEditor()
                    else
                      TextField(
                        controller: _contenidoCtrl,
                        style: const TextStyle(
                            fontSize: 15, height: 1.5, color: Colors.black87),
                        decoration: const InputDecoration(
                          hintText: 'Escribe tu nota aquí...',
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: null,
                        minLines: 5,
                        keyboardType: TextInputType.multiline,
                      ),
                    const SizedBox(height: 24),
                    // Categorías
                    _buildCategoriaSelector(),
                    const SizedBox(height: 20),
                    // Etiquetas
                    _buildTagsField(),
                    const SizedBox(height: 20),
                    // Colores
                    _buildColorSelector(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
          ),
        );
      },
    );
  }

  // ─── Toolbar ───

  Widget _buildToolbar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Symbols.close_rounded),
            tooltip: 'Cerrar',
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          // Pin toggle
          IconButton(
            icon: Icon(
              _esFijada ? Symbols.push_pin_rounded : Symbols.push_pin_rounded,
              color: _esFijada
                  ? Theme.of(context).colorScheme.primary
                  : Colors.black54,
            ),
            tooltip: _esFijada ? 'Quitar fijado' : 'Fijar',
            onPressed: () => setState(() => _esFijada = !_esFijada),
          ),
          // Save button
          FilledButton.icon(
            onPressed: () => _guardar(context),
            icon: const Icon(Symbols.check_rounded, size: 18),
            label: const Text('Guardar'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.black87,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  // ─── Checklist Editor ───

  Widget _buildChecklistEditor() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(_items.length, (i) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _toggleItemCompletado(i),
                  child: Icon(
                    _items[i].completado
                        ? Symbols.check_circle_rounded
                        : Symbols.radio_button_unchecked_rounded,
                    size: 22,
                    color: _items[i].completado
                        ? Colors.black54
                        : Colors.black87,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _itemCtrlList[i],
                    style: TextStyle(
                      fontSize: 15,
                      decoration: _items[i].completado
                          ? TextDecoration.lineThrough
                          : null,
                      color: _items[i].completado
                          ? Colors.black45
                          : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Elemento ${i + 1}',
                      hintStyle:
                          const TextStyle(color: Colors.black54, fontSize: 15),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (_) => _addItem(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Symbols.close_rounded, size: 18, color: Colors.black45),
                  onPressed: () => _removeItem(i),
                  splashRadius: 18,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: _addItem,
          child: Row(
            children: [
              const Icon(Symbols.add_rounded, size: 22, color: Colors.black45),
              const SizedBox(width: 8),
              Text(
                'Agregar elemento',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black.withValues(alpha: 0.45),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Tags Field ───

  Widget _buildTagsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Etiquetas',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black.withValues(alpha: 0.5),
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _tagsCtrl,
          decoration: InputDecoration(
            hintText: 'trabajo, personal, ideas',
            hintStyle: const TextStyle(color: Colors.black54, fontSize: 14),
            prefixIcon: const Icon(Symbols.label_rounded, color: Colors.black45),
            filled: true,
            fillColor: Colors.black.withValues(alpha: 0.06),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          textCapitalization: TextCapitalization.none,
        ),
      ],
    );
  }

  // ─── Categoria Selector ───

  Widget _buildCategoriaSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categoría',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black.withValues(alpha: 0.5),
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: CategoriaNote.values.map((cat) {
            final selected = _categoria == cat;
            return GestureDetector(
              onTap: () => setState(() => _categoria = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.black87
                      : Colors.black.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(cat.icono, size: 15),
                    const SizedBox(width: 5),
                    Text(
                      cat.nombre,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: selected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ─── Color Selector ───

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black.withValues(alpha: 0.5),
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: coloresNota.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final c = coloresNota[i];
              final hex = c['hex']!;
              final selected = _color == hex;
              return GestureDetector(
                onTap: () => setState(() => _color = hex),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: widget.hexToColor(hex),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selected ? Colors.black87 : Colors.black26,
                      width: selected ? 2.5 : 1.5,
                    ),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: widget.hexToColor(hex).withValues(alpha: 0.5),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            )
                          ]
                        : [],
                  ),
                  child: selected
                      ? const Icon(Symbols.check_rounded,
                          size: 16, color: Colors.black54)
                      : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
