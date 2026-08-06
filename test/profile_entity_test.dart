import 'package:flutter_test/flutter_test.dart';
import 'package:glint/features/profile/domain/profile_entity.dart';

/// Lógica pura de la entidad de perfil: cómo se compone el nombre para
/// mostrar, las iniciales del avatar y la edad.
void main() {
  ProfileEntity perfil({
    String email = 'ana@ejemplo.com',
    String nombre = '',
    String? nombres,
    String? apellidos,
    DateTime? fechaNacimiento,
  }) =>
      ProfileEntity(
        id: 'u1',
        email: email,
        nombre: nombre,
        nombres: nombres,
        apellidos: apellidos,
        fechaNacimiento: fechaNacimiento,
        actualizadoEn: DateTime(2026, 1, 1),
      );

  group('nombreCompleto', () {
    test('une nombres y apellidos', () {
      expect(perfil(nombres: 'Ana', apellidos: 'Pérez').nombreCompleto,
          'Ana Pérez');
    });

    test('sin apellidos no deja el espacio colgando', () {
      expect(perfil(nombres: 'Ana').nombreCompleto, 'Ana');
    });

    test('sin nombres cae al nombre para mostrar', () {
      expect(perfil(nombre: 'Ana Pérez').nombreCompleto, 'Ana Pérez');
    });

    test('sin nada usa el prefijo del correo, como el trigger del servidor', () {
      expect(perfil(email: 'ana@ejemplo.com').nombreCompleto, 'ana');
    });

    test('sin nada de nada no revienta', () {
      expect(perfil(email: '').nombreCompleto, 'Usuario');
    });
  });

  group('iniciales', () {
    test('dos palabras → dos letras', () {
      expect(perfil(nombres: 'Ana', apellidos: 'Pérez').iniciales, 'AP');
    });

    test('una palabra → una letra', () {
      expect(perfil(nombres: 'Ana').iniciales, 'A');
    });

    test('respeta acentos', () {
      expect(perfil(nombres: 'Ángel', apellidos: 'Ñuño').iniciales, 'ÁÑ');
    });

    // Cortar por unidades UTF-16 partiría un emoji por la mitad y produciría
    // un carácter inválido; por eso la entidad usa `runes`.
    test('un emoji cuenta como una letra, sin partirse', () {
      final p = perfil(nombres: '🦊', apellidos: 'Zorro');
      expect(p.iniciales.runes.length, 2);
      expect(p.iniciales, '🦊Z');
    });

    test('espacios de sobra no generan iniciales vacías', () {
      expect(perfil(nombres: '  Ana  ', apellidos: '  Pérez ').iniciales, 'AP');
    });
  });

  group('edad', () {
    test('sin fecha de nacimiento es null', () {
      expect(perfil().edad, isNull);
    });

    test('cuenta años cumplidos', () {
      final hoy = DateTime.now();
      final hace30 = DateTime(hoy.year - 30, hoy.month, hoy.day);
      expect(perfil(fechaNacimiento: hace30).edad, 30);
    });

    test('el día del cumpleaños ya cuenta', () {
      final hoy = DateTime.now();
      expect(
        perfil(fechaNacimiento: DateTime(hoy.year - 20, hoy.month, hoy.day))
            .edad,
        20,
      );
    });

    test('si aún no ha llegado el cumpleaños, cuenta uno menos', () {
      final hoy = DateTime.now();
      // Un día después de hoy, hace 20 años.
      final manana = hoy.add(const Duration(days: 1));
      final nacimiento = DateTime(hoy.year - 20, manana.month, manana.day);
      // Solo tiene sentido comprobarlo si "mañana" sigue en el mismo año.
      if (manana.year == hoy.year) {
        expect(perfil(fechaNacimiento: nacimiento).edad, 19);
      }
    });
  });

  group('visibilidad', () {
    test('el texto guardado en la BD ida y vuelta', () {
      for (final v in VisibilidadPerfil.values) {
        expect(VisibilidadPerfil.desdeTexto(v.texto), v);
      }
    });

    test('un valor desconocido o nulo cae en amigos, el más conservador', () {
      expect(VisibilidadPerfil.desdeTexto(null), VisibilidadPerfil.amigos);
      expect(VisibilidadPerfil.desdeTexto('cualquier-cosa'),
          VisibilidadPerfil.amigos);
    });
  });

  group('copyWith', () {
    test('pasar null NO borra un campo (hay que usar limpiar*)', () {
      final p = perfil(nombres: 'Ana').copyWith(bio: 'hola');
      expect(p.copyWith(bio: null).bio, 'hola');
      expect(p.copyWith(limpiarBio: true).bio, isNull);
    });
  });
}
