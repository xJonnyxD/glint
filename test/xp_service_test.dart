import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:glint/shared/services/xp_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    XpService.setUsuario(null);
  });

  group('XpService — XP por usuario', () {
    test('sin usuario activo no guarda ni devuelve XP', () async {
      await XpService.agregarXP(50, motivo: 'test');
      expect(await XpService.getXP(), 0);
    });

    test('cada usuario tiene su propio XP', () async {
      XpService.setUsuario('user-a');
      await XpService.agregarXP(100, motivo: 'hábito');
      expect(await XpService.getXP(), 100);

      // Otro usuario en el mismo dispositivo NO hereda el XP
      XpService.setUsuario('user-b');
      expect(await XpService.getXP(), 0);
      await XpService.agregarXP(25, motivo: 'nota');
      expect(await XpService.getXP(), 25);

      // Al volver, el usuario original conserva el suyo
      XpService.setUsuario('user-a');
      expect(await XpService.getXP(), 100);
    });

    test('migra el XP legacy (global) al primer usuario que lo lee', () async {
      SharedPreferences.setMockInitialValues({
        'glint_xp_total': 500,
        'glint_xp_historial': ['{"xp":10,"motivo":"legacy","fecha":"2026-01-01T00:00:00"}'],
      });

      XpService.setUsuario('user-a');
      expect(await XpService.getXP(), 500);
      final historial = await XpService.getHistorial();
      expect(historial, hasLength(1));
      expect(historial.first['motivo'], 'legacy');

      // El legacy ya fue consumido: un segundo usuario no lo hereda
      XpService.setUsuario('user-b');
      expect(await XpService.getXP(), 0);
    });

    test('el historial se mantiene por usuario y limitado a 20', () async {
      XpService.setUsuario('user-a');
      for (var i = 0; i < 25; i++) {
        await XpService.agregarXP(1, motivo: 'accion $i');
      }
      final historial = await XpService.getHistorial();
      expect(historial, hasLength(20));
      expect(historial.first['motivo'], 'accion 24'); // más reciente primero
    });
  });
}
