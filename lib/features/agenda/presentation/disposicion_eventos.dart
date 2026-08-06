import '../domain/event_entity.dart';

/// Dónde va un evento dentro de la rejilla horaria.
///
/// [columna] y [totalColumnas] son lo que reparte el ancho: un evento solo en
/// su franja ocupa todo (`0` de `1`), y dos que se pisan ocupan media cada uno
/// (`0` y `1` de `2`).
class PosicionEvento {
  final EventEntity evento;
  final int columna;
  final int totalColumnas;
  final int minutoInicio;
  final int minutoFin;

  const PosicionEvento({
    required this.evento,
    required this.columna,
    required this.totalColumnas,
    required this.minutoInicio,
    required this.minutoFin,
  });

  int get duracionMinutos => minutoFin - minutoInicio;

  @override
  String toString() => '${evento.titulo} '
      '[$minutoInicio-$minutoFin] col $columna/$totalColumnas';
}

/// Coloca [eventos] en columnas para que los que se solapan queden uno al lado
/// del otro en vez de encima.
///
/// Es el reparto clásico de las agendas: se recorren en orden de comienzo, se
/// agrupan los que se pisan en cadena (si A pisa a B y B pisa a C, los tres van
/// al mismo grupo aunque A y C no se toquen) y dentro del grupo cada uno cae en
/// la primera columna libre. Todos los del grupo comparten el mismo
/// [PosicionEvento.totalColumnas] para que las columnas queden alineadas.
///
/// Los eventos de todo el día y los que no tienen hora se descartan: esos van
/// en la franja de arriba, no dentro de la rejilla.
List<PosicionEvento> disponerEventos(List<EventEntity> eventos) {
  final conHora = <EventEntity>[
    for (final e in eventos)
      if (e.minutoInicio != null && e.minutoFin != null) e,
  ];
  if (conHora.isEmpty) return const [];

  // Orden estable: por comienzo y, a igualdad, primero el más largo (queda a la
  // izquierda, que es como se leen mejor las agendas).
  conHora.sort((a, b) {
    final porInicio = a.minutoInicio!.compareTo(b.minutoInicio!);
    if (porInicio != 0) return porInicio;
    return b.minutoFin!.compareTo(a.minutoFin!);
  });

  final resultado = <PosicionEvento>[];

  // Un grupo es un bloque de eventos encadenados por solapamiento. Se cierra en
  // cuanto aparece uno que empieza después de que hayan terminado todos los
  // anteriores, y solo entonces se sabe cuántas columnas hizo falta.
  var grupo = <EventEntity>[];
  var columnas = <List<EventEntity>>[];
  var finDelGrupo = -1;

  void cerrarGrupo() {
    if (grupo.isEmpty) return;
    final total = columnas.length;
    for (var c = 0; c < total; c++) {
      for (final e in columnas[c]) {
        resultado.add(PosicionEvento(
          evento: e,
          columna: c,
          totalColumnas: total,
          minutoInicio: e.minutoInicio!,
          minutoFin: e.minutoFin!,
        ));
      }
    }
    grupo = [];
    columnas = [];
    finDelGrupo = -1;
  }

  for (final e in conHora) {
    if (grupo.isNotEmpty && e.minutoInicio! >= finDelGrupo) cerrarGrupo();

    // Primera columna cuyo último evento ya terminó.
    var colocado = false;
    for (final col in columnas) {
      if (col.last.minutoFin! <= e.minutoInicio!) {
        col.add(e);
        colocado = true;
        break;
      }
    }
    if (!colocado) columnas.add([e]);

    grupo.add(e);
    if (e.minutoFin! > finDelGrupo) finDelGrupo = e.minutoFin!;
  }
  cerrarGrupo();

  return resultado;
}

/// Los que van en la franja de arriba: de todo el día, o sin hora puesta.
List<EventEntity> eventosDeTodoElDia(List<EventEntity> eventos) => [
      for (final e in eventos)
        if (e.minutoInicio == null) e,
    ];
