import 'package:glint/features/habits/domain/habit_entity.dart';

/// Normaliza una fecha a solo año-mes-día (sin hora).
DateTime soloFecha(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

/// Fechas con las que reconstruir el historial de un hábito antiguo que tiene
/// racha pero ninguna completación registrada (creado antes del esquema v7).
///
/// Sin esto, recalcular su racha desde un historial vacío la borraría. Se
/// asume que los días de la racha son los inmediatamente anteriores: la
/// reconstrucción es una aproximación, pero preserva el progreso del usuario
/// y deja los datos consistentes de ahí en adelante.
Set<DateTime> fechasParaSembrarLegacy({
  required int rachaActual,
  required bool completadoHoy,
  required DateTime hoy,
  required FrecuenciaHabito frecuencia,
  required int metaSemanal,
}) {
  if (rachaActual <= 0) return {};
  final hoyNorm = soloFecha(hoy);
  final fechas = <DateTime>{};

  if (frecuencia == FrecuenciaHabito.diario) {
    // Si hoy ya está marcado, la racha termina hoy; si no, terminó ayer.
    final ultimoDia = completadoHoy
        ? hoyNorm
        : soloFecha(hoyNorm.subtract(const Duration(days: 1)));
    for (var i = 0; i < rachaActual; i++) {
      fechas.add(soloFecha(ultimoDia.subtract(Duration(days: i))));
    }
    return fechas;
  }

  // Semanal: la racha cuenta semanas, así que sembramos la meta de días
  // en cada una de las últimas `rachaActual` semanas.
  final lunesEstaSemana =
      soloFecha(hoyNorm.subtract(Duration(days: hoyNorm.weekday - 1)));
  final diasPorSemana = metaSemanal.clamp(1, 7);
  for (var semana = 0; semana < rachaActual; semana++) {
    final lunes = soloFecha(lunesEstaSemana.subtract(Duration(days: 7 * semana)));
    for (var dia = 0; dia < diasPorSemana; dia++) {
      fechas.add(soloFecha(lunes.add(Duration(days: dia))));
    }
  }
  return fechas;
}

/// Calcula la racha actual de un hábito a partir de su historial de
/// completaciones. Es una función pura para poder testearla sin BD.
///
/// - Diario: días consecutivos hasta hoy (o hasta ayer si hoy aún no se
///   completa — el día en curso no rompe la racha).
/// - Semanal: semanas consecutivas (lun-dom) cumpliendo la meta; la semana
///   en curso no rompe la racha si todavía no la cumple.
int calcularRacha({
  required Set<DateTime> fechas,
  required DateTime hoy,
  required FrecuenciaHabito frecuencia,
  required int metaSemanal,
}) {
  if (fechas.isEmpty) return 0;
  final hoyNorm = soloFecha(hoy);

  if (frecuencia == FrecuenciaHabito.diario) {
    var dia = fechas.contains(hoyNorm)
        ? hoyNorm
        : soloFecha(hoyNorm.subtract(const Duration(days: 1)));
    var racha = 0;
    while (fechas.contains(dia)) {
      racha++;
      dia = soloFecha(dia.subtract(const Duration(days: 1)));
    }
    return racha;
  }

  // Semanal: contar semanas consecutivas cumpliendo la meta
  DateTime inicioSemana(DateTime d) =>
      soloFecha(d.subtract(Duration(days: d.weekday - 1)));
  int completadasEn(DateTime inicio) {
    final fin = inicio.add(const Duration(days: 7));
    return fechas.where((f) => !f.isBefore(inicio) && f.isBefore(fin)).length;
  }

  var semana = inicioSemana(hoyNorm);
  var racha = 0;
  // La semana actual cuenta si ya cumplió la meta (si no, está en curso)
  if (completadasEn(semana) >= metaSemanal) racha++;
  semana = soloFecha(semana.subtract(const Duration(days: 7)));
  while (completadasEn(semana) >= metaSemanal) {
    racha++;
    semana = soloFecha(semana.subtract(const Duration(days: 7)));
  }
  return racha;
}
