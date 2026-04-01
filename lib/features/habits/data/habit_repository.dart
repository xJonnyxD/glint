import 'package:drift/drift.dart';
import 'package:glint/shared/database/app_database.dart';
import 'package:glint/features/habits/domain/habit_entity.dart';

/// Repositorio de hábitos — traduce entre la BD (Drift) y el dominio (HabitEntity).
/// La pantalla solo conoce HabitEntity, nunca los objetos de Drift directamente.
class HabitRepository {
  final AppDatabase _db;

  HabitRepository(this._db);

  /// Escucha cambios en los hábitos en tiempo real (Stream)
  Stream<List<HabitEntity>> watchHabitos(String usuarioId) {
    return (_db.select(_db.habits)
          ..where((h) => h.usuarioId.equals(usuarioId))
          ..orderBy([
            (h) => OrderingTerm(expression: h.categoria),
            (h) => OrderingTerm(expression: h.creadoEn),
          ]))
        .watch()
        .map((rows) => rows.map(_rowToEntity).toList());
  }

  /// Crea un hábito nuevo
  Future<void> crearHabito(HabitEntity habito) async {
    await _db.into(_db.habits).insert(_entityToCompanion(habito));
  }

  /// Marca o desmarca un hábito como completado hoy
  Future<void> toggleCompletar(HabitEntity habito, bool completado) async {
    final nuevaRacha = completado
        ? habito.rachaActual + 1 // completando → suma racha
        : (habito.rachaActual > 0 ? habito.rachaActual - 1 : 0);

    final nuevaRachaMaxima =
        nuevaRacha > habito.rachaMaxima ? nuevaRacha : habito.rachaMaxima;

    final nuevoTotal =
        completado ? habito.totalCompletados + 1 : habito.totalCompletados;

    await (_db.update(_db.habits)..where((h) => h.id.equals(habito.id)))
        .write(
      HabitsCompanion(
        completadoHoy: Value(completado),
        rachaActual: Value(nuevaRacha),
        rachaMaxima: Value(nuevaRachaMaxima),
        totalCompletados: Value(nuevoTotal),
      ),
    );
  }

  /// Elimina un hábito
  Future<void> eliminarHabito(String id) async {
    await (_db.delete(_db.habits)..where((h) => h.id.equals(id))).go();
  }

  /// Resetea todos los hábitos del usuario a "no completados" (nuevo día)
  Future<void> resetearDiario(String usuarioId) async {
    await (_db.update(_db.habits)
          ..where((h) => h.usuarioId.equals(usuarioId)))
        .write(const HabitsCompanion(completadoHoy: Value(false)));
  }

  // ── Conversores privados ──────────────────────────────────────────────────

  HabitEntity _rowToEntity(Habit row) {
    return HabitEntity(
      id: row.id,
      nombre: row.nombre,
      icono: row.icono,
      categoria: CategoriaHabito.values[row.categoria],
      frecuencia: FrecuenciaHabito.values[row.frecuencia],
      metaSemanal: row.metaSemanal,
      completadoHoy: row.completadoHoy,
      rachaActual: row.rachaActual,
      rachaMaxima: row.rachaMaxima,
      totalCompletados: row.totalCompletados,
      color: row.color,
      usuarioId: row.usuarioId,
      creadoEn: row.creadoEn,
    );
  }

  HabitsCompanion _entityToCompanion(HabitEntity e) {
    return HabitsCompanion(
      id: Value(e.id),
      nombre: Value(e.nombre),
      icono: Value(e.icono),
      categoria: Value(e.categoria.index),
      frecuencia: Value(e.frecuencia.index),
      metaSemanal: Value(e.metaSemanal),
      completadoHoy: Value(e.completadoHoy),
      rachaActual: Value(e.rachaActual),
      rachaMaxima: Value(e.rachaMaxima),
      totalCompletados: Value(e.totalCompletados),
      color: Value(e.color),
      usuarioId: Value(e.usuarioId),
      creadoEn: Value(e.creadoEn),
    );
  }
}
