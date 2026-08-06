import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/event_entity.dart';
import 'agenda_cubit.dart';
import 'agenda_state.dart';
import 'disposicion_eventos.dart';
import 'rejilla_horaria.dart';

/// Vista de Día y de Semana sobre la rejilla horaria.
///
/// Las dos comparten estructura —franja de todo el día arriba, horas a la
/// izquierda y columnas desplazables— así que se resuelven con el mismo widget
/// cambiando cuántos días se pintan.
class VistaRejilla extends StatefulWidget {
  final AgendaLoaded state;

  /// 1 para la vista de Día, 7 para la de Semana.
  final int diasVisibles;

  final void Function(EventEntity) onTocarEvento;
  final void Function(DateTime cuando) onCrearEn;

  const VistaRejilla({
    super.key,
    required this.state,
    required this.diasVisibles,
    required this.onTocarEvento,
    required this.onCrearEn,
  });

  @override
  State<VistaRejilla> createState() => _VistaRejillaState();
}

class _VistaRejillaState extends State<VistaRejilla> {
  static const double _altoHora = 60;
  static const double _anchoEje = 52;

  final _scroll = ScrollController();
  bool _yaCentrado = false;

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  /// Coloca el scroll a primera hora de la mañana en vez de a medianoche.
  ///
  /// Abrir la agenda a las 00:00 deja media pantalla vacía y obliga a
  /// desplazarse siempre; se apunta a la hora actual (o a las 8, si es de
  /// madrugada) dejando algo de contexto por encima.
  void _centrarEnLaHoraUtil() {
    if (_yaCentrado || !_scroll.hasClients) return;
    _yaCentrado = true;
    final ahora = DateTime.now();
    final horaFoco = ahora.hour < 7 ? 8 : ahora.hour;
    final destino = ((horaFoco - 1) * _altoHora)
        .clamp(0.0, _scroll.position.maxScrollExtent);
    _scroll.jumpTo(destino);
  }

  List<DateTime> get _dias {
    final sel = widget.state.diaSeleccionado;
    if (widget.diasVisibles == 1) return [sel];
    final lunes = sel.subtract(Duration(days: sel.weekday - 1));
    return [for (var i = 0; i < 7; i++) lunes.add(Duration(days: i))];
  }

  List<EventEntity> _eventosDe(DateTime dia) => [
        for (final e in widget.state.todos)
          if (e.fecha.year == dia.year &&
              e.fecha.month == dia.month &&
              e.fecha.day == dia.day)
            e,
      ];

  bool _esHoy(DateTime d) {
    final hoy = DateTime.now();
    return d.year == hoy.year && d.month == hoy.month && d.day == hoy.day;
  }

  @override
  Widget build(BuildContext context) {
    final dias = _dias;
    final colorScheme = Theme.of(context).colorScheme;

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _centrarEnLaHoraUtil());

    return LayoutBuilder(
      builder: (context, constraints) {
        // En la semana, el ancho útil se reparte entre los 7 días. Por debajo
        // de ~90 px por día los títulos no se leen, así que la rejilla se hace
        // más ancha que la pantalla y se desplaza en horizontal.
        final anchoUtil = constraints.maxWidth - _anchoEje;
        final anchoDia = widget.diasVisibles == 1
            ? anchoUtil
            : (anchoUtil / 7).clamp(90.0, double.infinity);
        final necesitaScrollH = anchoDia * dias.length > anchoUtil + 1;

        final contenido = SizedBox(
          width: _anchoEje + anchoDia * dias.length,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CabeceraDias(
                dias: dias,
                anchoEje: _anchoEje,
                anchoDia: anchoDia,
                esHoy: _esHoy,
                diaSeleccionado: widget.state.diaSeleccionado,
                onSeleccionar: (d) =>
                    context.read<AgendaCubit>().seleccionarDia(d),
              ),
              _FranjaTodoElDia(
                dias: dias,
                anchoEje: _anchoEje,
                anchoDia: anchoDia,
                eventosDe: (d) => eventosDeTodoElDia(_eventosDe(d)),
                onTocarEvento: widget.onTocarEvento,
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scroll,
                  child: Stack(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EjeHoras(altoHora: _altoHora, ancho: _anchoEje),
                          for (final d in dias)
                            SizedBox(
                              width: anchoDia,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: colorScheme.outlineVariant
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                ),
                                child: ColumnaDia(
                                  dia: d,
                                  eventos: _eventosDe(d),
                                  altoHora: _altoHora,
                                  onTocarEvento: widget.onTocarEvento,
                                  onTocarHueco: widget.onCrearEn,
                                ),
                              ),
                            ),
                        ],
                      ),
                      // La línea de "ahora" cruza toda la rejilla, pero solo si
                      // alguno de los días a la vista es hoy.
                      Positioned(
                        left: _anchoEje,
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Stack(
                          children: [
                            LineaAhora(
                              altoHora: _altoHora,
                              visible: dias.any(_esHoy),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

        if (!necesitaScrollH) return contenido;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: _anchoEje + anchoDia * dias.length,
            child: contenido,
          ),
        );
      },
    );
  }
}

/// Cabecera con el día de la semana y el número, resaltando hoy.
class _CabeceraDias extends StatelessWidget {
  final List<DateTime> dias;
  final double anchoEje;
  final double anchoDia;
  final bool Function(DateTime) esHoy;
  final DateTime diaSeleccionado;
  final void Function(DateTime) onSeleccionar;

  const _CabeceraDias({
    required this.dias,
    required this.anchoEje,
    required this.anchoDia,
    required this.esHoy,
    required this.diaSeleccionado,
    required this.onSeleccionar,
  });

  // Dos letras para que el miércoles no sea "X", que aquí se lee como un error.
  static const _diasCortos = ['Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sá', 'Do'];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(width: anchoEje),
          for (final d in dias)
            SizedBox(
              width: anchoDia,
              child: InkWell(
                onTap: () => onSeleccionar(d),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    children: [
                      Text(
                        _diasCortos[d.weekday - 1],
                        style:
                            Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: esHoy(d) ? colorScheme.primary : null,
                        ),
                        child: Text(
                          '${d.day}',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: esHoy(d)
                                    ? colorScheme.onPrimary
                                    : colorScheme.onSurface,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Franja superior con los eventos de todo el día, que no caben en la rejilla.
class _FranjaTodoElDia extends StatelessWidget {
  final List<DateTime> dias;
  final double anchoEje;
  final double anchoDia;
  final List<EventEntity> Function(DateTime) eventosDe;
  final void Function(EventEntity) onTocarEvento;

  const _FranjaTodoElDia({
    required this.dias,
    required this.anchoEje,
    required this.anchoDia,
    required this.eventosDe,
    required this.onTocarEvento,
  });

  @override
  Widget build(BuildContext context) {
    final porDia = {for (final d in dias) d: eventosDe(d)};
    // Sin eventos de todo el día no se reserva espacio: una franja vacía
    // permanente le roba altura a la rejilla sin aportar nada.
    if (porDia.values.every((l) => l.isEmpty)) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final maxPorDia = porDia.values.map((l) => l.length).reduce((a, b) => a > b ? a : b);

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: anchoEje,
            child: Padding(
              padding: const EdgeInsets.only(right: 8, top: 4),
              child: Text(
                'Todo\nel día',
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
          ),
          for (final d in dias)
            SizedBox(
              width: anchoDia,
              height: maxPorDia * 26,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final e in porDia[d]!)
                    Padding(
                      padding: const EdgeInsets.only(left: 2, bottom: 2),
                      child: InkWell(
                        onTap: () => onTocarEvento(e),
                        child: Container(
                          height: 22,
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: _color(e.color).withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            e.titulo,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _color(String hex) {
    final v = int.tryParse('FF${hex.replaceAll('#', '')}', radix: 16);
    return v == null ? Colors.blueGrey : Color(v);
  }
}
