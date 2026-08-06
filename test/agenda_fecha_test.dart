import 'package:flutter_test/flutter_test.dart';
import 'package:glint/features/agenda/presentation/agenda_cubit.dart';
import 'package:glint/shared/services/sync_resolver.dart';

/// Regresión del bug "agendo el 10 y se guarda el 9".
///
/// `table_calendar` construye TODOS sus días con `DateTime.utc(...)`
/// (`utils.dart:46` del paquete). En una zona al oeste de Greenwich —El
/// Salvador es UTC−6— la medianoche UTC del día 10 es en realidad el día 9 a
/// las 18:00, así que el evento nacía y se mostraba un día antes.
///
/// `AgendaCubit.soloDiaLocal` es la puerta por la que pasan todas las fechas
/// de agenda; estas pruebas fijan que deja el día correcto.
void main() {
  group('soloDiaLocal', () {
    test('una fecha en UTC (la que da table_calendar) conserva su día', () {
      final delCalendario = DateTime.utc(2026, 8, 10);
      final normalizada = AgendaCubit.soloDiaLocal(delCalendario);

      expect(normalizada.day, 10);
      expect(normalizada.month, 8);
      expect(normalizada.year, 2026);
      expect(normalizada.isUtc, isFalse,
          reason: 'debe quedar en hora local, o al guardarla se corre el día');
    });

    test('deja el día a medianoche, sin arrastrar la hora actual', () {
      // El calendario semanal pasaba el día con la hora en la que tocabas.
      final conHora = DateTime(2026, 8, 10, 15, 44, 16);
      final normalizada = AgendaCubit.soloDiaLocal(conHora);

      expect(normalizada, DateTime(2026, 8, 10));
      expect(normalizada.hour, 0);
      expect(normalizada.minute, 0);
    });

    test('una fecha ya local se queda igual', () {
      expect(AgendaCubit.soloDiaLocal(DateTime(2026, 8, 10)),
          DateTime(2026, 8, 10));
    });

    test('el día no cambia en ningún mes del año', () {
      for (var mes = 1; mes <= 12; mes++) {
        final normalizada = AgendaCubit.soloDiaLocal(DateTime.utc(2026, mes, 10));
        expect(normalizada.day, 10, reason: 'falla en el mes $mes');
        expect(normalizada.month, mes);
      }
    });
  });

  group('ida y vuelta por el sincronizador', () {
    // Reproduce el camino completo: lo que el usuario elige → epoch de Drift →
    // ISO que sube a Supabase → lo que se lee de vuelta.
    int comoLoGuardaDrift(DateTime d) => d.millisecondsSinceEpoch ~/ 1000;
    DateTime comoLoLeeLaApp(int epoch) =>
        DateTime.fromMillisecondsSinceEpoch(epoch * 1000);

    test('el día elegido sobrevive al viaje al servidor y de vuelta', () {
      final elegido = AgendaCubit.soloDiaLocal(DateTime.utc(2026, 8, 10));
      final epoch = comoLoGuardaDrift(elegido);

      // Lo que se sube (el sync usa esta misma función).
      final iso = segundosAIso(epoch);
      // Y lo que vuelve.
      final deVuelta = comoLoLeeLaApp(isoASegundos(iso)!);

      expect(deVuelta.day, 10,
          reason: 'si esto falla, el evento vuelve a verse el día anterior');
      expect(deVuelta.month, 8);
    });

    test('sin normalizar, el día SÍ se pierde (el bug original)', () {
      // Esta prueba documenta por qué existe soloDiaLocal: guardar tal cual lo
      // que da el calendario reproduce el fallo.
      final sinNormalizar = DateTime.utc(2026, 8, 10);
      final deVuelta = comoLoLeeLaApp(comoLoGuardaDrift(sinNormalizar));

      // En una zona negativa (América) se ve el día anterior; en una positiva
      // (Europa/Asia) coincide. La prueba solo tiene sentido al oeste.
      if (DateTime.now().timeZoneOffset.isNegative) {
        expect(deVuelta.day, 9,
            reason: 'este es exactamente el fallo que se corrigió');
      }
    });
  });
}
