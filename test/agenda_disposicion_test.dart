import 'package:flutter_test/flutter_test.dart';
import 'package:glint/features/agenda/domain/event_entity.dart';
import 'package:glint/features/agenda/presentation/disposicion_eventos.dart';

EventEntity ev(String titulo, String? hora, {int dur = 60, bool todoDia = false}) =>
    EventEntity(
      id: titulo,
      titulo: titulo,
      fecha: DateTime(2026, 8, 5),
      hora: hora,
      duracionMinutos: dur,
      todoElDia: todoDia,
      usuarioId: 'u1',
      creadoEn: DateTime(2026, 8, 1),
    );

PosicionEvento pos(List<PosicionEvento> l, String titulo) =>
    l.firstWhere((p) => p.evento.titulo == titulo);

void main() {
  group('minutos del evento', () {
    test('convierte HH:mm a minutos desde medianoche', () {
      expect(ev('a', '09:30').minutoInicio, 9 * 60 + 30);
      expect(ev('a', '00:00').minutoInicio, 0);
      expect(ev('a', '23:59').minutoInicio, 23 * 60 + 59);
    });

    test('un evento de todo el día no tiene minuto de inicio', () {
      expect(ev('a', '09:00', todoDia: true).minutoInicio, isNull);
      expect(ev('a', null).minutoInicio, isNull);
    });

    test('una hora mal escrita no revienta, simplemente no se sitúa', () {
      for (final malo in ['', '9', 'ab:cd', '25:00', '10:99', '10:30:00']) {
        expect(ev('a', malo).minutoInicio, isNull, reason: 'con "$malo"');
      }
    });

    test('el fin se recorta a medianoche en vez de desbordar la rejilla', () {
      // 23:00 + 3 h se saldría hasta el minuto 1560 del día siguiente.
      expect(ev('a', '23:00', dur: 180).minutoFin, 24 * 60);
    });

    test('una duración inválida cae a una hora', () {
      expect(ev('a', '09:00', dur: 0).minutoFin, 10 * 60);
      expect(ev('a', '09:00', dur: -30).minutoFin, 10 * 60);
    });

    test('el rango se muestra legible', () {
      expect(ev('a', '09:00', dur: 90).rangoHorario, '9:00 – 10:30');
    });
  });

  group('reparto en columnas', () {
    test('sin eventos no hay nada que colocar', () {
      expect(disponerEventos([]), isEmpty);
    });

    test('un evento solo ocupa todo el ancho', () {
      final r = disponerEventos([ev('a', '09:00')]);
      expect(r, hasLength(1));
      expect(r.first.columna, 0);
      expect(r.first.totalColumnas, 1);
    });

    test('dos que no se pisan ocupan el ancho entero cada uno', () {
      final r = disponerEventos([ev('a', '09:00'), ev('b', '11:00')]);
      expect(pos(r, 'a').totalColumnas, 1);
      expect(pos(r, 'b').totalColumnas, 1);
    });

    test('dos que se pisan se reparten a la mitad', () {
      final r = disponerEventos([ev('a', '09:00'), ev('b', '09:30')]);
      expect(pos(r, 'a').totalColumnas, 2);
      expect(pos(r, 'b').totalColumnas, 2);
      expect({pos(r, 'a').columna, pos(r, 'b').columna}, {0, 1});
    });

    test('los que se tocan por el extremo NO se consideran solapados', () {
      // a: 9:00–10:00, b: 10:00–11:00. Uno acaba justo cuando empieza el otro.
      final r = disponerEventos([ev('a', '09:00'), ev('b', '10:00')]);
      expect(pos(r, 'a').totalColumnas, 1);
      expect(pos(r, 'b').totalColumnas, 1);
    });

    test('tres solapados dan tres columnas', () {
      final r = disponerEventos(
          [ev('a', '09:00', dur: 180), ev('b', '09:30'), ev('c', '10:00')]);
      for (final t in ['a', 'b', 'c']) {
        expect(pos(r, t).totalColumnas, 3, reason: t);
      }
      expect({for (final t in ['a', 'b', 'c']) pos(r, t).columna}, {0, 1, 2});
    });

    test('el encadenado mantiene alineado a todo el grupo', () {
      // a 9–10, b 9:30–10:30, c 10:15–11. a y c NO se pisan entre sí, pero b
      // los encadena, así que los tres forman un grupo y deben compartir el
      // mismo ancho: si no, se verían columnas de anchuras distintas pegadas.
      //
      // El ancho correcto es 2, no 3: como a y c no coinciden, se turnan en la
      // misma columna, y en ningún momento hay más de dos eventos a la vez.
      final r = disponerEventos([
        ev('a', '09:00'),
        ev('b', '09:30'),
        ev('c', '10:15', dur: 45),
      ]);
      for (final t in ['a', 'b', 'c']) {
        expect(pos(r, t).totalColumnas, 2, reason: t);
      }
      expect(pos(r, 'a').columna, pos(r, 'c').columna,
          reason: 'a y c no se pisan: deben turnarse en la misma columna');
      expect(pos(r, 'b').columna, isNot(pos(r, 'a').columna));
    });

    test('una columna se reutiliza cuando queda libre', () {
      // a 9–11 largo; b 9–10 y c 10–11 caben ambos en la segunda columna.
      final r = disponerEventos([
        ev('a', '09:00', dur: 120),
        ev('b', '09:00'),
        ev('c', '10:00'),
      ]);
      expect(pos(r, 'a').totalColumnas, 2);
      expect(pos(r, 'b').columna, pos(r, 'c').columna,
          reason: 'b y c deberían compartir la misma columna');
    });

    test('grupos separados se calculan por su cuenta', () {
      // Mañana: dos solapados. Tarde: uno solo. El de la tarde no debe heredar
      // el ancho a la mitad de la mañana.
      final r = disponerEventos([
        ev('m1', '09:00'),
        ev('m2', '09:30'),
        ev('t1', '17:00'),
      ]);
      expect(pos(r, 'm1').totalColumnas, 2);
      expect(pos(r, 't1').totalColumnas, 1);
    });

    test('los de todo el día quedan fuera de la rejilla', () {
      final r = disponerEventos([
        ev('a', '09:00'),
        ev('completo', null, todoDia: true),
      ]);
      expect(r, hasLength(1));
      expect(r.first.evento.titulo, 'a');
    });

    test('no se pierde ni se duplica ningún evento', () {
      final entrada = [
        ev('a', '08:00', dur: 90),
        ev('b', '08:30'),
        ev('c', '09:00', dur: 30),
        ev('d', '14:00'),
        ev('e', '14:00'),
        ev('f', '23:30', dur: 120),
      ];
      final r = disponerEventos(entrada);
      expect(r, hasLength(entrada.length));
      expect(r.map((p) => p.evento.titulo).toSet(),
          entrada.map((e) => e.titulo).toSet());
    });

    test('el orden de entrada no cambia el resultado', () {
      final base = [
        ev('a', '09:00', dur: 120),
        ev('b', '09:30'),
        ev('c', '10:00'),
      ];
      final normal = disponerEventos([...base]);
      final alReves = disponerEventos([...base.reversed]);
      for (final t in ['a', 'b', 'c']) {
        expect(pos(alReves, t).columna, pos(normal, t).columna, reason: t);
        expect(pos(alReves, t).totalColumnas, pos(normal, t).totalColumnas,
            reason: t);
      }
    });
  });

  group('franja de todo el día', () {
    test('recoge los de todo el día y los que no tienen hora', () {
      final l = eventosDeTodoElDia([
        ev('a', '09:00'),
        ev('completo', null, todoDia: true),
        ev('sin hora', null),
      ]);
      expect(l.map((e) => e.titulo), ['completo', 'sin hora']);
    });
  });
}
