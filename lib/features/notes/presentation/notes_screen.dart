import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glint/features/notes/domain/note_entity.dart';
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

  @override
  void dispose() {
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
          return CustomScrollView(
            slivers: [
              _buildAppBar(context, state),
              if (_searchVisible) _buildSearchBar(context),
              if (state is NoteLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state is NoteLoaded)
                _buildContent(context, state)
              else
                const SliverFillRemaining(
                  child: Center(child: Text('Error al cargar notas')),
                ),
            ],
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
              _searchVisible ? Icons.search_off : Icons.search,
            ),
            tooltip: 'Buscar',
            onPressed: () {
              setState(() {
                _searchVisible = !_searchVisible;
                if (!_searchVisible) {
                  _searchCtrl.clear();
                  context.read<NoteCubit>().buscar('');
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
        child: TextField(
          controller: _searchCtrl,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Buscar en notas...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchCtrl.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
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
            context.read<NoteCubit>().buscar(v);
            setState(() {});
          },
        ),
      ),
    );
  }

  // ─────────────────────── CONTENT ───────────────────────

  Widget _buildContent(BuildContext context, NoteLoaded state) {
    final lista = _searchVisible && _searchCtrl.text.isNotEmpty
        ? state.filtradas
        : state.notas;

    if (lista.isEmpty) {
      return SliverFillRemaining(
        child: _buildEmptyState(),
      );
    }

    final fijadas = lista.where((n) => n.esFijada).toList();
    final normales = lista.where((n) => !n.esFijada).toList();

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          if (fijadas.isNotEmpty) ...[
            _buildSectionHeader(context, 'Fijadas', Icons.push_pin),
            const SizedBox(height: 8),
            _buildGrid(context, fijadas),
            const SizedBox(height: 16),
          ],
          if (normales.isNotEmpty) ...[
            if (fijadas.isNotEmpty)
              _buildSectionHeader(context, 'Otras notas', Icons.notes),
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
        child: _NoteCard(
          nota: notas[i],
          hexToColor: _hexToColor,
          onTap: () => _abrirEditar(context, notas[i]),
          onLongPress: () => _mostrarOpcionesNota(context, notas[i]),
          onDismissed: () => _confirmarEliminar(context, notas[i].id),
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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('📝', style: TextStyle(fontSize: 72)),
          const SizedBox(height: 16),
          Text(
            'Crea tu primera nota',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Toca el botón + para empezar',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
          ),
        ],
      ),
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
          icon: const Icon(Icons.checklist),
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
          icon: const Icon(Icons.edit_note),
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
          Icons.delete_outline,
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
                color: cardColor.withOpacity(0.4),
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
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          height: 1.3,
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
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const SizedBox(height: 8),
                    // Categoría
                    Row(
                      children: [
                        Text(nota.categoria.emoji,
                            style: const TextStyle(fontSize: 12)),
                        const SizedBox(width: 4),
                        Text(
                          nota.categoria.nombre,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Pin icon
              if (nota.esFijada)
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(Icons.push_pin, size: 16, color: Colors.black54),
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
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
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
            leading: const Icon(Icons.edit_outlined),
            title: const Text('Editar'),
            onTap: onEdit,
          ),
          ListTile(
            leading: Icon(nota.esFijada
                ? Icons.push_pin_outlined
                : Icons.push_pin),
            title: Text(nota.esFijada ? 'Quitar fijado' : 'Fijar nota'),
            onTap: () {
              context.read<NoteCubit>().toggleFijada(nota);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_outline,
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

class _NoteEditSheetState extends State<_NoteEditSheet> {
  late TextEditingController _tituloCtrl;
  late TextEditingController _contenidoCtrl;
  late CategoriaNote _categoria;
  late String _color;
  late bool _esFijada;
  late List<ChecklistItem> _items;
  late bool _esChecklist;
  final List<TextEditingController> _itemCtrlList = [];

  @override
  void initState() {
    super.initState();
    final n = widget.nota;
    _tituloCtrl = TextEditingController(text: n?.titulo ?? '');
    _contenidoCtrl = TextEditingController(text: n?.contenido ?? '');
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
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _contenidoCtrl.dispose();
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

  void _guardar(BuildContext context) {
    final titulo = _tituloCtrl.text.trim();
    final contenido = _contenidoCtrl.text.trim();
    final items = _esChecklist ? _buildItems() : <ChecklistItem>[];

    if (titulo.isEmpty && contenido.isEmpty && items.every((i) => i.texto.isEmpty)) {
      Navigator.pop(context);
      return;
    }

    final cubit = context.read<NoteCubit>();

    if (widget.nota == null) {
      cubit.crearNota(
        titulo: titulo,
        contenido: contenido,
        categoria: _categoria,
        color: _color,
        esChecklist: _esChecklist,
        items: items,
      );
    } else {
      cubit.actualizarNota(widget.nota!.copyWith(
        titulo: titulo,
        contenido: contenido,
        categoria: _categoria,
        color: _color,
        esFijada: _esFijada,
        esChecklist: _esChecklist,
        items: items,
      ));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (ctx, scrollCtrl) {
        return Container(
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
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Título',
                        hintStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38),
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
                        style: const TextStyle(fontSize: 15, height: 1.5),
                        decoration: const InputDecoration(
                          hintText: 'Escribe tu nota aquí...',
                          hintStyle: TextStyle(color: Colors.black38),
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
                    // Colores
                    _buildColorSelector(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
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
            icon: const Icon(Icons.close),
            tooltip: 'Cerrar',
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          // Pin toggle
          IconButton(
            icon: Icon(
              _esFijada ? Icons.push_pin : Icons.push_pin_outlined,
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
            icon: const Icon(Icons.check, size: 18),
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
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
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
                          const TextStyle(color: Colors.black38, fontSize: 15),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (_) => _addItem(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18, color: Colors.black45),
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
              const Icon(Icons.add, size: 22, color: Colors.black45),
              const SizedBox(width: 8),
              Text(
                'Agregar elemento',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black.withOpacity(0.45),
                ),
              ),
            ],
          ),
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
            color: Colors.black.withOpacity(0.5),
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
                      : Colors.black.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(cat.emoji,
                        style: const TextStyle(fontSize: 14)),
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
            color: Colors.black.withOpacity(0.5),
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: coloresNota.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
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
                              color: widget.hexToColor(hex).withOpacity(0.5),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            )
                          ]
                        : [],
                  ),
                  child: selected
                      ? const Icon(Icons.check,
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
