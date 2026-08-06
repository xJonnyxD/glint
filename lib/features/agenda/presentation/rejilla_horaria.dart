import 'dart:async';

import 'package:flutter/material.dart';

import '../domain/event_entity.dart';
import 'disposicion_eventos.dart';

/// Rejilla horaria de un día: las horas en el eje vertical y los eventos como
/// bloques colocados según cuándo empiezan y cuánto duran.
///
/// Es la pieza que comparten las vistas de Día y de Semana; la de Semana pinta
/// una de estas por cada día, compartiendo el mismo scroll.
class ColumnaDia extends StatelessWidget {
  final DateTime dia;
  final List<EventEntity> eventos;

  /// Alto de una hora. De él sale todo lo demás, porque la rejilla trabaja en
  /// minutos: la posición de un bloque es `minuto / 60 * altoHora`.
  final double altoHora;

  final void Function(EventEntity)? onTocarEvento;

  /// Se avisa con el minuto (redondeado al cuarto de hora) donde se ha tocado
  /// un hueco libre, para poder crear ahí un evento.
  final void Function(DateTime cuando)? onTocarHueco;

  const ColumnaDia({
    super.key,
    required this.dia,
    required this.eventos,
    this.altoHora = 60,
    this.onTocarEvento,
    this.onTocarHueco,
  });

  static const int _minutosDia = 24 * 60;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final posiciones = disponerEventos(eventos);
    final alto = altoHora * 24;

    return SizedBox(
      height: alto,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final ancho = constraints.maxWidth;
          return Stack(
            children: [
              // Líneas de cada hora, por debajo de todo.
              for (var h = 1; h < 24; h++)
                Positioned(
                  top: h * altoHora,
                  left: 0,
                  right: 0,
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),

              // Capa para crear tocando un hueco. Va debajo de los bloques para
              // que tocar un evento abra el evento y no cree otro encima.
              if (onTocarHueco != null)
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTapUp: (d) {
                      final minuto = (d.localPosition.dy / altoHora * 60)
                          .clamp(0, _minutosDia - 1)
                          .toInt();
                      // Al cuarto de hora más cercano: nadie quiere un evento
                      // a las 9:07 solo porque ahí cayó el dedo.
                      final redondeado = (minuto ~/ 15) * 15;
                      onTocarHueco!(DateTime(dia.year, dia.month, dia.day,
                          redondeado ~/ 60, redondeado % 60));
                    },
                  ),
                ),

              for (final p in posiciones)
                _BloqueEvento(
                  posicion: p,
                  altoHora: altoHora,
                  anchoDisponible: ancho,
                  onTocar: onTocarEvento,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _BloqueEvento extends StatelessWidget {
  final PosicionEvento posicion;
  final double altoHora;
  final double anchoDisponible;
  final void Function(EventEntity)? onTocar;

  const _BloqueEvento({
    required this.posicion,
    required this.altoHora,
    required this.anchoDisponible,
    this.onTocar,
  });

  /// Separación entre bloques contiguos, para que se distingan dos eventos
  /// pegados en columnas vecinas.
  static const double _hueco = 3;

  @override
  Widget build(BuildContext context) {
    final e = posicion.evento;
    final color = _color(e.color);

    final anchoColumna = anchoDisponible / posicion.totalColumnas;
    final top = posicion.minutoInicio / 60 * altoHora;
    final alto = posicion.duracionMinutos / 60 * altoHora;

    // Un evento de 15 minutos daría un bloque de 15 px donde no cabe ni una
    // línea de texto; se le da un mínimo para que siga siendo legible y
    // pulsable (24 px es el mínimo táctil razonable aquí).
    final altoVisible = alto < 24 ? 24.0 : alto - _hueco;

    // Debajo de ~34 px no caben dos líneas, así que se enseña solo el título.
    final cabeLaHora = altoVisible >= 34;

    return Positioned(
      top: top,
      left: posicion.columna * anchoColumna,
      width: anchoColumna - _hueco,
      height: altoVisible,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTocar == null ? null : () => onTocar!(e),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              // Relleno tenue con una barra lateral del color del evento: se
              // distingue el color sin que el texto pierda contraste, que es lo
              // que pasaría al escribir sobre el color a plena saturación.
              color: color.withValues(alpha: 0.16),
              border: Border(left: BorderSide(color: color, width: 3)),
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(4),
                right: Radius.circular(8),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  e.titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        decoration:
                            e.completado ? TextDecoration.lineThrough : null,
                      ),
                ),
                if (cabeLaHora && e.rangoHorario != null)
                  Text(
                    e.rangoHorario!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _color(String hex) {
    final limpio = hex.replaceAll('#', '');
    final v = int.tryParse('FF$limpio', radix: 16);
    return v == null ? Colors.blueGrey : Color(v);
  }
}

/// La columna de horas de la izquierda (00:00, 01:00, …).
class EjeHoras extends StatelessWidget {
  final double altoHora;
  final double ancho;

  const EjeHoras({super.key, required this.altoHora, this.ancho = 52});

  @override
  Widget build(BuildContext context) {
    final estilo = Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );

    return SizedBox(
      width: ancho,
      height: altoHora * 24,
      child: Stack(
        children: [
          for (var h = 1; h < 24; h++)
            Positioned(
              top: h * altoHora - 7, // centrada sobre su línea
              right: 8,
              child: Text('${h.toString().padLeft(2, '0')}:00', style: estilo),
            ),
        ],
      ),
    );
  }
}

/// Línea roja de la hora actual, como en cualquier agenda.
///
/// Se redibuja sola cada minuto: sin el temporizador se queda clavada donde
/// estaba al abrir la pantalla, y una línea de "ahora" que miente es peor que
/// no tenerla.
class LineaAhora extends StatefulWidget {
  final double altoHora;

  /// Si el día que se muestra no es hoy, no se pinta nada.
  final bool visible;

  const LineaAhora({super.key, required this.altoHora, this.visible = true});

  @override
  State<LineaAhora> createState() => _LineaAhoraState();
}

class _LineaAhoraState extends State<LineaAhora> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.visible) return const SizedBox.shrink();
    final ahora = DateTime.now();
    final top = (ahora.hour * 60 + ahora.minute) / 60 * widget.altoHora;
    final color = Theme.of(context).colorScheme.error;

    return Positioned(
      top: top - 5,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            Expanded(child: Container(height: 2, color: color)),
          ],
        ),
      ),
    );
  }
}
