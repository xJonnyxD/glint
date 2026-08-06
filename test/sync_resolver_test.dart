import 'package:flutter_test/flutter_test.dart';
import 'package:glint/shared/services/sync_resolver.dart';

void main() {
  final t0 = DateTime(2026, 7, 22, 10, 0);
  final t1 = DateTime(2026, 7, 22, 11, 0); // una hora después

  group('resolver — última escritura gana', () {
    test('solo local → subir', () {
      expect(
        resolver(localActualizado: t0, remotoActualizado: null),
        AccionSync.subir,
      );
    });

    test('solo remoto → bajar', () {
      expect(
        resolver(localActualizado: null, remotoActualizado: t0),
        AccionSync.bajar,
      );
    });

    test('ninguno → nada', () {
      expect(
        resolver(localActualizado: null, remotoActualizado: null),
        AccionSync.nada,
      );
    });

    test('local más reciente → subir', () {
      expect(
        resolver(localActualizado: t1, remotoActualizado: t0),
        AccionSync.subir,
      );
    });

    test('remoto más reciente → bajar', () {
      expect(
        resolver(localActualizado: t0, remotoActualizado: t1),
        AccionSync.bajar,
      );
    });

    test('misma marca → nada (evita rebotes entre dispositivos)', () {
      expect(
        resolver(localActualizado: t0, remotoActualizado: t0),
        AccionSync.nada,
      );
    });
  });

  group('conversión de fechas SQLite ↔ ISO', () {
    test('round-trip: segundos → ISO → segundos preserva el instante', () {
      // 2026-07-22T14:00:00Z
      final segundos = DateTime.utc(2026, 7, 22, 14).millisecondsSinceEpoch ~/ 1000;
      final iso = segundosAIso(segundos);
      expect(iso, '2026-07-22T14:00:00.000Z');
      expect(isoASegundos(iso), segundos);
    });

    test('ISO con offset se normaliza a UTC', () {
      // 09:00 en -05:00 == 14:00 UTC
      final s = isoASegundos('2026-07-22T09:00:00-05:00');
      expect(s, DateTime.utc(2026, 7, 22, 14).millisecondsSinceEpoch ~/ 1000);
    });

    test('nulo/vacío → null', () {
      expect(isoASegundos(null), isNull);
      expect(isoASegundos(''), isNull);
    });
  });
}
