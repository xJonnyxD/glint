import 'package:flutter_test/flutter_test.dart';
import 'package:glint/features/habits/domain/habit_entity.dart';
import 'package:glint/features/habits/domain/racha_calculator.dart';

void main() {
  // Lunes 20 de julio de 2026 como "hoy" de referencia
  final hoy = DateTime(2026, 7, 20);

  DateTime d(int diasAtras) => hoy.subtract(Duration(days: diasAtras));

  group('calcularRacha — hábitos diarios', () {
    int racha(Set<DateTime> fechas) => calcularRacha(
          fechas: fechas,
          hoy: hoy,
          frecuencia: FrecuenciaHabito.diario,
          metaSemanal: 7,
        );

    test('sin completaciones → racha 0', () {
      expect(racha({}), 0);
    });

    test('completado solo hoy → racha 1', () {
      expect(racha({d(0)}), 1);
    });

    test('3 días consecutivos incluyendo hoy → racha 3', () {
      expect(racha({d(0), d(1), d(2)}), 3);
    });

    test('hoy aún sin completar no rompe la racha de ayer', () {
      expect(racha({d(1), d(2), d(3)}), 3);
    });

    test('un día fallado SÍ rompe la racha (el bug original)', () {
      // Completó hace 2 y 3 días, falló ayer, nada hoy → racha 0
      expect(racha({d(2), d(3)}), 0);
    });

    test('hueco en el historial: solo cuenta el tramo reciente', () {
      // 10 días completados pero falló hace 3 días
      expect(racha({d(0), d(1), d(2), d(4), d(5), d(6)}), 3);
    });

    test('la hora del día no afecta el cálculo', () {
      final conHora = {
        DateTime(2026, 7, 20, 23, 59),
      }.map(soloFecha).toSet();
      expect(
        calcularRacha(
          fechas: conHora,
          hoy: DateTime(2026, 7, 20, 8, 30),
          frecuencia: FrecuenciaHabito.diario,
          metaSemanal: 7,
        ),
        1,
      );
    });
  });

  group('calcularRacha — hábitos semanales', () {
    int racha(Set<DateTime> fechas, {int meta = 3}) => calcularRacha(
          fechas: fechas,
          hoy: hoy, // lunes: semana actual = 20-26 julio
          frecuencia: FrecuenciaHabito.semanal,
          metaSemanal: meta,
        );

    test('sin completaciones → racha 0', () {
      expect(racha({}), 0);
    });

    test('semana pasada cumplió la meta, esta semana en curso → racha 1', () {
      // Semana pasada (13-19 julio): 3 completaciones con meta 3
      expect(racha({d(1), d(3), d(5)}), 1);
    });

    test('semana en curso que ya cumplió la meta también cuenta', () {
      // Hoy lunes + semana pasada completa: 2 semanas... pero con meta 1
      expect(racha({d(0), d(3)}, meta: 1), 2);
    });

    test('semana pasada sin cumplir meta rompe la racha', () {
      // Hace 2 semanas cumplió, la pasada no → racha 0 (la actual va en curso)
      expect(racha({d(8), d(14), d(15), d(16)}), 0);
    });
  });

  group('fechasParaSembrarLegacy — migración de hábitos sin historial', () {
    test('sin racha previa no siembra nada', () {
      expect(
        fechasParaSembrarLegacy(
          rachaActual: 0,
          completadoHoy: false,
          hoy: hoy,
          frecuencia: FrecuenciaHabito.diario,
          metaSemanal: 7,
        ),
        isEmpty,
      );
    });

    test('diario completado hoy: siembra hoy y los días previos', () {
      final fechas = fechasParaSembrarLegacy(
        rachaActual: 3,
        completadoHoy: true,
        hoy: hoy,
        frecuencia: FrecuenciaHabito.diario,
        metaSemanal: 7,
      );
      expect(fechas, {d(0), d(1), d(2)});
    });

    test('diario no completado hoy: la racha termina ayer', () {
      final fechas = fechasParaSembrarLegacy(
        rachaActual: 3,
        completadoHoy: false,
        hoy: hoy,
        frecuencia: FrecuenciaHabito.diario,
        metaSemanal: 7,
      );
      expect(fechas, {d(1), d(2), d(3)});
    });

    test('la racha migrada se preserva al recalcularla', () {
      // Este es el punto de la migración: sembrar y recalcular debe
      // devolver exactamente la racha que el usuario ya tenía.
      for (final completadoHoy in [true, false]) {
        final fechas = fechasParaSembrarLegacy(
          rachaActual: 12,
          completadoHoy: completadoHoy,
          hoy: hoy,
          frecuencia: FrecuenciaHabito.diario,
          metaSemanal: 7,
        );
        expect(
          calcularRacha(
            fechas: fechas,
            hoy: hoy,
            frecuencia: FrecuenciaHabito.diario,
            metaSemanal: 7,
          ),
          12,
          reason: 'completadoHoy=$completadoHoy',
        );
      }
    });

    test('semanal: siembra la meta de días en cada semana de la racha', () {
      final fechas = fechasParaSembrarLegacy(
        rachaActual: 2,
        completadoHoy: false,
        hoy: hoy,
        frecuencia: FrecuenciaHabito.semanal,
        metaSemanal: 3,
      );
      expect(fechas, hasLength(6)); // 2 semanas × 3 días
      expect(
        calcularRacha(
          fechas: fechas,
          hoy: hoy,
          frecuencia: FrecuenciaHabito.semanal,
          metaSemanal: 3,
        ),
        2,
      );
    });
  });
}
