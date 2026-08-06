import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:glint/features/agenda/domain/event_entity.dart';
import 'package:glint/core/icons/app_icons.dart';
import 'package:glint/shared/widgets/aparecer.dart';
import 'package:glint/shared/widgets/skeleton_lista.dart';
import 'agenda_cubit.dart';
import 'agenda_state.dart';
import 'vista_dia_semana.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

/// Las tres formas de mirar la agenda.
enum VistaAgenda { dia, semana, mes }

class _AgendaScreenState extends State<AgendaScreen> {
  VistaAgenda _vista = VistaAgenda.mes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AgendaCubit, AgendaState>(
        builder: (context, state) {
          if (state is AgendaLoading) {
            return const SkeletonLista();
          }
          if (state is! AgendaLoaded) return const SizedBox();

          return Column(
            children: [
              _BarraAgenda(
                state: state,
                vista: _vista,
                onCambiarVista: (v) => setState(() => _vista = v),
              ),
              Expanded(
                child: switch (_vista) {
                  VistaAgenda.mes => _AgendaContenido(state: state),
                  VistaAgenda.dia => VistaRejilla(
                      state: state,
                      diasVisibles: 1,
                      onTocarEvento: (e) => _abrirDetalle(context, e),
                      onCrearEn: (cuando) =>
                          _mostrarAgregarEvento(context, cuando: cuando),
                    ),
                  VistaAgenda.semana => VistaRejilla(
                      state: state,
                      diasVisibles: 7,
                      onTocarEvento: (e) => _abrirDetalle(context, e),
                      onCrearEn: (cuando) =>
                          _mostrarAgregarEvento(context, cuando: cuando),
                    ),
                },
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarAgregarEvento(context),
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
    );
  }

  void _abrirDetalle(BuildContext context, EventEntity evento) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<AgendaCubit>(),
        child: _DetalleEventoSheet(evento: evento),
      ),
    );
  }

  /// [cuando] llega cuando se ha tocado un hueco de la rejilla: además del día
  /// trae la hora, para no obligar a elegirla otra vez a mano.
  void _mostrarAgregarEvento(BuildContext context, {DateTime? cuando}) {
    final state = context.read<AgendaCubit>().state;
    final fecha = cuando ??
        (state is AgendaLoaded ? state.diaSeleccionado : DateTime.now());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<AgendaCubit>(),
        child: _AgregarEventoSheet(
          fechaInicial: fecha,
          horaInicial: cuando == null
              ? null
              : TimeOfDay(hour: cuando.hour, minute: cuando.minute),
        ),
      ),
    );
  }
}

/// Cabecera con el periodo, el botón de Hoy y el selector de vista.
class _BarraAgenda extends StatelessWidget {
  final AgendaLoaded state;
  final VistaAgenda vista;
  final void Function(VistaAgenda) onCambiarVista;

  const _BarraAgenda({
    required this.state,
    required this.vista,
    required this.onCambiarVista,
  });

  static const _meses = ['', 'enero', 'febrero', 'marzo', 'abril', 'mayo',
      'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre',
      'diciembre'];
  static const _mesesCortos = ['', 'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];

  String get _titulo {
    final d = state.diaSeleccionado;
    switch (vista) {
      case VistaAgenda.dia:
        return '${d.day} de ${_meses[d.month]}';
      case VistaAgenda.semana:
        final lunes = d.subtract(Duration(days: d.weekday - 1));
        final domingo = lunes.add(const Duration(days: 6));
        if (lunes.month == domingo.month) {
          return '${lunes.day} – ${domingo.day} ${_mesesCortos[lunes.month]}';
        }
        return '${lunes.day} ${_mesesCortos[lunes.month]} – '
            '${domingo.day} ${_mesesCortos[domingo.month]}';
      case VistaAgenda.mes:
        return '${_meses[d.month]} ${d.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
        child: Row(
          children: [
            // Expanded para que un título largo se recorte en vez de empujar
            // fuera de la pantalla a los botones de la derecha.
            Expanded(
              child: Text(
                _titulo,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.today_outlined),
              tooltip: 'Hoy',
              onPressed: () =>
                  context.read<AgendaCubit>().seleccionarDia(DateTime.now()),
            ),
            SegmentedButton<VistaAgenda>(
              segments: const [
                ButtonSegment(value: VistaAgenda.dia, label: Text('Día')),
                ButtonSegment(value: VistaAgenda.semana, label: Text('Semana')),
                ButtonSegment(value: VistaAgenda.mes, label: Text('Mes')),
              ],
              selected: {vista},
              showSelectedIcon: false,
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                textStyle: WidgetStatePropertyAll(
                  Theme.of(context).textTheme.labelSmall,
                ),
              ),
              onSelectionChanged: (s) => onCambiarVista(s.first),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    ).withFondo(colorScheme.surface);
  }
}

extension _ConFondo on Widget {
  Widget withFondo(Color color) => ColoredBox(color: color, child: this);
}

// ── Contenido principal (vista mensual) ───────────────────────────────────────

class _AgendaContenido extends StatelessWidget {
  final AgendaLoaded state;
  const _AgendaContenido({required this.state});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Sin SliverAppBar propia: el título del periodo, el botón de Hoy y el
    // selector de vista ya los pone _BarraAgenda, que es común a las tres.
    return CustomScrollView(
      slivers: [
        // Calendario
        SliverToBoxAdapter(
          child: Container(
            color: colorScheme.surface,
            child: TableCalendar<EventEntity>(
              locale: 'es_SV',
              firstDay: DateTime(2020),
              lastDay: DateTime(2030),
              focusedDay: state.diaSeleccionado,
              selectedDayPredicate: (d) => isSameDay(d, state.diaSeleccionado),
              onDaySelected: (selected, _) =>
                  context.read<AgendaCubit>().seleccionarDia(selected),
              eventLoader: (day) => state.todos
                  .where((e) => isSameDay(e.fecha, day))
                  .toList(),
              calendarFormat: CalendarFormat.month,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w700),
                leftChevronIcon: Icon(Icons.chevron_left,
                    color: colorScheme.primary),
                rightChevronIcon: Icon(Icons.chevron_right,
                    color: colorScheme.primary),
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: colorScheme.primary.withAlpha(60),
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(
                    color: colorScheme.primary, fontWeight: FontWeight.bold),
                selectedDecoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle:
                    TextStyle(color: colorScheme.onPrimary),
                markerDecoration: BoxDecoration(
                  color: colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
                outsideDaysVisible: false,
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: Divider(height: 1)),

        // Encabezado del día seleccionado
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatFechaLarga(state.diaSeleccionado),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${state.eventosDelDia.length} eventos',
                    style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Lista de eventos
        if (state.eventosDelDia.isEmpty)
          SliverToBoxAdapter(child: _buildDiaVacio(context))
        else
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => Aparecer(
                indice: i,
                child: _EventoCard(evento: state.eventosDelDia[i]),
              ),
              childCount: state.eventosDelDia.length,
            ),
          ),

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildDiaVacio(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(Icons.event_available_outlined,
              size: 56, color: colorScheme.primary.withAlpha(100)),
          const SizedBox(height: 12),
          Text('Día libre',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('No hay eventos para este día',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withAlpha(153),
                  )),
        ],
      ),
    );
  }

  String _formatFechaLarga(DateTime d) {
    final dias  = ['', 'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sábado', 'domingo'];
    final meses = ['', 'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
        'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];
    return '${dias[d.weekday].substring(0, 1).toUpperCase()}${dias[d.weekday].substring(1)}, ${d.day} de ${meses[d.month]}';
  }
}

// ── Tarjeta de evento ─────────────────────────────────────────────────────────

class _EventoCard extends StatelessWidget {
  final EventEntity evento;
  const _EventoCard({required this.evento});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final esTarea     = evento.esTarea;
    final tieneNotas  = evento.descripcion != null && evento.descripcion!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colorScheme.outline.withAlpha(40)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: tieneNotas ? () => _verDetalle(context) : null,
          onLongPress: () => _confirmarEliminar(context),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Indicador de hora o checkbox
                if (evento.hora != null)
                  SizedBox(
                    width: 48,
                    child: Text(
                      evento.hora!,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  )
                else if (esTarea)
                  GestureDetector(
                    onTap: () =>
                        context.read<AgendaCubit>().toggleCompletado(evento),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 28,
                      height: 28,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: evento.completado
                            ? colorScheme.primary
                            : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: evento.completado
                              ? colorScheme.primary
                              : colorScheme.outline,
                          width: 2,
                        ),
                      ),
                      child: evento.completado
                          ? Icon(Icons.check,
                              size: 16, color: colorScheme.onPrimary)
                          : null,
                    ),
                  )
                else
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),

                const SizedBox(width: 8),

                // Contenido
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        evento.titulo,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              decoration: evento.completado
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: evento.completado
                                  ? colorScheme.onSurface.withAlpha(128)
                                  : null,
                            ),
                      ),
                      if (tieneNotas) ...[
                        const SizedBox(height: 3),
                        Text(
                          evento.descripcion!,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: colorScheme.onSurface.withAlpha(153)),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                // Badge tipo
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: esTarea
                        ? colorScheme.secondaryContainer
                        : colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    esTarea ? 'Tarea' : 'Evento',
                    style: TextStyle(
                        fontSize: 10,
                        color: esTarea
                            ? colorScheme.onSecondaryContainer
                            : colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _verDetalle(BuildContext context) async {
    final accion = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _DetalleEventoSheet(evento: evento),
    );
    if (!context.mounted) return;
    if (accion == 'editar') {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => _AgregarEventoSheet(
          fechaInicial: evento.fecha,
          eventoEditar: evento,
        ),
      );
    } else if (accion == 'eliminar') {
      context.read<AgendaCubit>().eliminarEvento(evento.id);
    }
  }

  void _confirmarEliminar(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar'),
        content: Text('¿Eliminar "${evento.titulo}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AgendaCubit>().eliminarEvento(evento.id);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

// ── Detalle de evento ─────────────────────────────────────────────────────────

class _DetalleEventoSheet extends StatelessWidget {
  final EventEntity evento;
  const _DetalleEventoSheet({required this.evento});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final meses = ['', 'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
        'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(evento.esTarea ? AppIcons.check : AppIcons.event,
                  size: 28, color: colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(evento.titulo,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        )),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined,
                  size: 16, color: colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                '${evento.fecha.day} de ${meses[evento.fecha.month]} de ${evento.fecha.year}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (evento.hora != null) ...[
                const SizedBox(width: 12),
                Icon(Icons.access_time,
                    size: 16, color: colorScheme.primary),
                const SizedBox(width: 4),
                Text(evento.hora!,
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ],
          ),
          if (evento.descripcion != null && evento.descripcion!.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Text('Notas',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                    )),
            const SizedBox(height: 6),
            Text(evento.descripcion!,
                style: Theme.of(context).textTheme.bodyMedium),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context, 'editar'),
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Editar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.errorContainer,
                    foregroundColor: colorScheme.onErrorContainer,
                  ),
                  onPressed: () => Navigator.pop(context, 'eliminar'),
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Eliminar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Bottom sheet agregar evento ───────────────────────────────────────────────

class _AgregarEventoSheet extends StatefulWidget {
  final DateTime fechaInicial;
  /// Hora con la que abrir el formulario, cuando se ha llegado tocando un hueco
  /// de la rejilla: se aprovecha dónde tocó el dedo en vez de pedirla de nuevo.
  final TimeOfDay? horaInicial;
  final EventEntity? eventoEditar;
  const _AgregarEventoSheet({
    required this.fechaInicial,
    this.horaInicial,
    this.eventoEditar,
  });

  @override
  State<_AgregarEventoSheet> createState() => _AgregarEventoSheetState();
}

class _AgregarEventoSheetState extends State<_AgregarEventoSheet> {
  final _tituloCtrl      = TextEditingController();
  final _descripcionCtrl = TextEditingController();
  final _formKey         = GlobalKey<FormState>();

  TipoEvento _tipo  = TipoEvento.evento;
  TimeOfDay? _hora;
  int _duracionMinutos = 60;
  late DateTime _fecha;

  /// Duraciones habituales. Se ofrecen como fichas en vez de un campo libre
  /// porque casi todo cae en una de estas y así se elige de un toque.
  static const _duracionesSugeridas = [15, 30, 45, 60, 90, 120, 180, 240];

  static String _formatoDuracion(int min) {
    if (min < 60) return '$min min';
    final h = min ~/ 60;
    final m = min % 60;
    return m == 0 ? '$h h' : '$h h $m min';
  }

  bool get _esEdicion => widget.eventoEditar != null;

  @override
  void initState() {
    super.initState();
    final e = widget.eventoEditar;
    if (e != null) {
      _tituloCtrl.text = e.titulo;
      _descripcionCtrl.text = e.descripcion ?? '';
      _tipo = e.tipo;
      _fecha = e.fecha;
      if (!e.todoElDia && e.hora != null && e.hora!.contains(':')) {
        final p = e.hora!.split(':');
        _hora = TimeOfDay(
            hour: int.tryParse(p[0]) ?? 0, minute: int.tryParse(p[1]) ?? 0);
      }
      _duracionMinutos = e.duracionMinutos;
    } else {
      _fecha = widget.fechaInicial;
      _hora = widget.horaInicial;
    }
  }

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      maxChildSize: 0.95,
      builder: (_, scrollCtrl) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            controller: scrollCtrl,
            padding: EdgeInsets.fromLTRB(
                24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 24),
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(_esEdicion ? 'Editar evento' : 'Nuevo evento',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      )),
              const SizedBox(height: 20),

              // Tipo segmentado
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: _SegmentBtn(
                        label: 'Evento',
                        selected: _tipo == TipoEvento.evento,
                        color: colorScheme.primary,
                        onTap: () =>
                            setState(() => _tipo = TipoEvento.evento),
                      ),
                    ),
                    Expanded(
                      child: _SegmentBtn(
                        label: 'Tarea',
                        selected: _tipo == TipoEvento.tarea,
                        color: colorScheme.secondary,
                        onTap: () =>
                            setState(() => _tipo = TipoEvento.tarea),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Título
              TextFormField(
                controller: _tituloCtrl,
                decoration: InputDecoration(
                  labelText: 'Título',
                  prefixIcon: const Icon(Icons.title),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Ingresa un título'
                    : null,
              ),
              const SizedBox(height: 14),

              // Descripción / notas
              TextFormField(
                controller: _descripcionCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Notas (opcional)',
                  hintText: 'Detalles, recordatorios...',
                  prefixIcon: const Icon(Icons.notes_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 14),

              // Fecha
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.calendar_today_outlined,
                    color: colorScheme.primary),
                title: Text(_formatFecha(_fecha),
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Toca para cambiar'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                        color: colorScheme.outline.withAlpha(80))),
                onTap: _seleccionarFecha,
              ),
              const SizedBox(height: 10),

              // Hora (solo eventos)
              if (_tipo == TipoEvento.evento)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.access_time_outlined,
                      color: colorScheme.primary),
                  title: Text(
                    _hora != null
                        ? _hora!.format(context)
                        : 'Sin hora específica',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text('Toca para agregar hora'),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                          color: colorScheme.outline.withAlpha(80))),
                  onTap: _seleccionarHora,
                ),

              // Duración: solo tiene sentido si el evento tiene una hora. Es lo
              // que decide el alto del bloque en la vista de día y semana.
              if (_tipo == TipoEvento.evento && _hora != null) ...[
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Duración',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          )),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final min in _duracionesSugeridas)
                      ChoiceChip(
                        label: Text(_formatoDuracion(min)),
                        selected: _duracionMinutos == min,
                        onSelected: (_) =>
                            setState(() => _duracionMinutos = min),
                      ),
                  ],
                ),
              ],

              const SizedBox(height: 24),

              FilledButton(
                onPressed: _guardar,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Guardar',
                    style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatFecha(DateTime d) {
    final meses = ['', 'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
        'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];
    return '${d.day} de ${meses[d.month]} de ${d.year}';
  }

  Future<void> _seleccionarFecha() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _fecha = picked);
  }

  Future<void> _seleccionarHora() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _hora ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _hora = picked);
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;
    final horaStr = _hora != null
        ? '${_hora!.hour.toString().padLeft(2, '0')}:${_hora!.minute.toString().padLeft(2, '0')}'
        : null;
    final descripcion = _descripcionCtrl.text.trim().isEmpty
        ? null
        : _descripcionCtrl.text.trim();
    final cubit = context.read<AgendaCubit>();

    if (_esEdicion) {
      cubit.editarEvento(
        original:    widget.eventoEditar!,
        titulo:      _tituloCtrl.text.trim(),
        descripcion: descripcion,
        fecha:       _fecha,
        hora:        horaStr,
        duracionMinutos: _duracionMinutos,
        tipo:        _tipo,
      );
    } else {
      cubit.crearEvento(
        titulo:      _tituloCtrl.text.trim(),
        descripcion: descripcion,
        fecha:       _fecha,
        hora:        horaStr,
        duracionMinutos: _duracionMinutos,
        tipo:        _tipo,
      );
    }
    Navigator.pop(context);
  }
}

// ── Botón segmentado ──────────────────────────────────────────────────────────

class _SegmentBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _SegmentBtn({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? color.withAlpha(220) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : null,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
