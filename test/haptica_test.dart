import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:glint/core/feedback/haptica.dart';

/// La háptica debe: estar activada por defecto, silenciarse cuando el usuario
/// la apaga (sin llamar al canal de plataforma) y recordar la preferencia.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final llamadas = <MethodCall>[];

  setUp(() {
    llamadas.clear();
    // Captura las invocaciones al canal de plataforma (donde va la vibración).
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
      llamadas.add(call);
      return null;
    });
    SharedPreferences.setMockInitialValues({});
  });

  Iterable<MethodCall> vibraciones() =>
      llamadas.where((c) => c.method == 'HapticFeedback.vibrate');

  test('por defecto está activada y vibra en un éxito', () async {
    await Haptica.cargar();
    expect(Haptica.activada, isTrue);

    Haptica.exito();
    expect(vibraciones(), isNotEmpty);
  });

  test('desactivada no llama al canal de plataforma', () async {
    await Haptica.definir(false);
    expect(Haptica.activada, isFalse);

    llamadas.clear();
    Haptica.exito();
    Haptica.seleccion();
    Haptica.error();
    expect(vibraciones(), isEmpty);
  });

  test('la preferencia se recuerda entre arranques', () async {
    await Haptica.definir(false);
    // Simula un arranque nuevo: se relee de disco.
    await Haptica.cargar();
    expect(Haptica.activada, isFalse);
  });
}
