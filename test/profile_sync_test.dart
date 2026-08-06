import 'package:flutter_test/flutter_test.dart';
import 'package:glint/shared/services/profile_sync_service.dart';

/// El servidor concede UPDATE sobre `profiles` **columna por columna**
/// (deploy/db-init/04-seguridad-roles.sql + 19-perfil-social.sql). PostgREST
/// rechaza la fila ENTERA con un 42501 si el envío incluye una sola columna
/// sin permiso, y ese error se registra pero no se ve: el perfil simplemente
/// dejaría de guardarse.
///
/// Estas pruebas fijan qué viaja y qué no.
void main() {
  group('columnas que viajan al servidor', () {
    test('nunca se manda nada que el usuario no pueda escribir', () {
      // Si alguna de estas llegara al servidor, el guardado entero fallaría.
      const prohibidas = {
        'id',
        'email',
        'es_admin',
        'xp',
        'codigo_amigo',
        'creado_en',
        'ultima_actividad',
        'plataforma',
      };
      expect(
        ProfileSyncService.columnasQueViajan.intersection(prohibidas),
        isEmpty,
        reason: 'Ampliar la allowlist exige ampliar el grant update(...) '
            'de 19-perfil-social.sql',
      );
    });

    test('las columnas locales del avatar no viajan', () {
      expect(ProfileSyncService.columnasQueViajan,
          isNot(contains('avatar_bytes')));
      expect(ProfileSyncService.columnasQueViajan,
          isNot(contains('avatar_pendiente')));
      expect(ProfileSyncService.columnasQueViajan,
          isNot(contains('pendiente_sync')));
    });

    test('sí viaja lo que el usuario edita', () {
      expect(
        ProfileSyncService.columnasQueViajan,
        containsAll(<String>[
          'nombre',
          'nombres',
          'apellidos',
          'bio',
          'fecha_nacimiento',
          'telefono',
          'zona_horaria',
          'visibilidad',
          'avatar_url',
          'actualizado_en',
        ]),
      );
    });
  });

  group('serialización de una fila local', () {
    // Una fila tal y como la devuelve SQLite: fechas en segundos epoch,
    // booleanos como 0/1, y columnas que no deben salir de aquí.
    Map<String, dynamic> filaLocal() => {
          'id': 'u1',
          'email': 'ana@ejemplo.com',
          'nombre': 'Ana Pérez',
          'nombres': 'Ana',
          'apellidos': 'Pérez',
          'bio': 'hola',
          // 1990-05-12T00:00:00Z
          'fecha_nacimiento': 642470400,
          'telefono': '+503 7777 7777',
          'zona_horaria': 'America/El_Salvador',
          'visibilidad': 'amigos',
          'avatar_url': 'https://glint.yanes.xyz/storage/v1/o/a.jpg?v=1',
          'actualizado_en': 1785000000,
          'avatar_bytes': [1, 2, 3],
          'avatar_pendiente': 0,
          'pendiente_sync': 1,
        };

    test('filtra las columnas no permitidas', () {
      final json = ProfileSyncService.aJsonRemoto(filaLocal());
      expect(json.keys.toSet(), ProfileSyncService.columnasQueViajan);
    });

    test('actualizado_en va como ISO completo (es timestamptz)', () {
      final json = ProfileSyncService.aJsonRemoto(filaLocal());
      expect(json['actualizado_en'], contains('T'));
      expect(json['actualizado_en'], endsWith('Z'));
    });

    // fecha_nacimiento es `date` en Postgres, no timestamptz. Si se manda un
    // ISO completo, la conversión de zona horaria puede correr el día — que
    // alguien nacido el 12 de mayo aparezca como del 11.
    test('fecha_nacimiento va como YYYY-MM-DD, sin hora', () {
      final json = ProfileSyncService.aJsonRemoto(filaLocal());
      expect(json['fecha_nacimiento'], '1990-05-12');
      expect(json['fecha_nacimiento'], isNot(contains('T')));
    });

    test('los nulos se conservan (así se vacía un campo en el servidor)', () {
      final fila = filaLocal()..['bio'] = null;
      final json = ProfileSyncService.aJsonRemoto(fila);
      expect(json.containsKey('bio'), isTrue);
      expect(json['bio'], isNull);
    });

    test('una fecha nula no revienta', () {
      final fila = filaLocal()..['fecha_nacimiento'] = null;
      final json = ProfileSyncService.aJsonRemoto(fila);
      expect(json['fecha_nacimiento'], isNull);
    });
  });
}
