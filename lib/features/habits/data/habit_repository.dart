import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:glint/shared/database/app_database.dart';
import 'package:glint/features/habits/domain/habit_entity.dart';

/// Repositorio de hábitos — traduce entre la BD (Drift) y el dominio (HabitEntity).
class HabitRepository {
  final AppDatabase _db;

  HabitRepository(this._db);

  // ── Hábitos ───────────────────────────────────────────────────────────────

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

  Future<void> crearHabito(HabitEntity habito) async {
    await _db.into(_db.habits).insert(_entityToCompanion(habito));
  }

  Future<void> toggleCompletar(HabitEntity habito, bool completado) async {
    final nuevaRacha = completado
        ? habito.rachaActual + 1
        : (habito.rachaActual > 0 ? habito.rachaActual - 1 : 0);

    final nuevaRachaMaxima =
        nuevaRacha > habito.rachaMaxima ? nuevaRacha : habito.rachaMaxima;

    final nuevoTotal =
        completado ? habito.totalCompletados + 1 : habito.totalCompletados;

    await (_db.update(_db.habits)..where((h) => h.id.equals(habito.id))).write(
      HabitsCompanion(
        completadoHoy:   Value(completado),
        rachaActual:     Value(nuevaRacha),
        rachaMaxima:     Value(nuevaRachaMaxima),
        totalCompletados: Value(nuevoTotal),
      ),
    );

    // Registrar o eliminar completación histórica
    final hoy = _soloFecha(DateTime.now());
    if (completado) {
      await registrarCompletacion(habito.id, habito.usuarioId, hoy);
    } else {
      await eliminarCompletacion(habito.id, hoy);
    }
  }

  Future<void> editarHabito({
    required String id,
    required String nombre,
    required String icono,
    required CategoriaHabito categoria,
    required FrecuenciaHabito frecuencia,
    required int metaSemanal,
  }) async {
    await (_db.update(_db.habits)..where((h) => h.id.equals(id))).write(
      HabitsCompanion(
        nombre:      Value(nombre),
        icono:       Value(icono),
        categoria:   Value(categoria.index),
        frecuencia:  Value(frecuencia.index),
        metaSemanal: Value(metaSemanal),
      ),
    );
  }

  Future<void> eliminarHabito(String id) async {
    await (_db.delete(_db.habits)..where((h) => h.id.equals(id))).go();
    // Eliminar también sus completaciones históricas
    await (_db.delete(_db.habitCompletions)
          ..where((c) => c.habitId.equals(id)))
        .go();
  }

  Future<void> resetearDiario(String usuarioId) async {
    await (_db.update(_db.habits)
          ..where((h) => h.usuarioId.equals(usuarioId)))
        .write(const HabitsCompanion(completadoHoy: Value(false)));
  }

  // ── Completaciones históricas (para heat map y estadísticas) ─────────────

  /// Registra que un hábito fue completado en una fecha específica.
  /// Evita duplicados (mismo habitId + fecha).
  Future<void> registrarCompletacion(
    String habitId,
    String usuarioId,
    DateTime fecha,
  ) async {
    final fechaNorm = _soloFecha(fecha);
    // Verificar si ya existe
    final existe = await (_db.select(_db.habitCompletions)
          ..where((c) =>
              c.habitId.equals(habitId) &
              c.fecha.equals(fechaNorm)))
        .getSingleOrNull();
    if (existe != null) return;

    await _db.into(_db.habitCompletions).insert(
          HabitCompletionsCompanion(
            id:        Value(const Uuid().v4()),
            habitId:   Value(habitId),
            usuarioId: Value(usuarioId),
            fecha:     Value(fechaNorm),
          ),
        );
  }

  /// Elimina la completación de un hábito para una fecha específica.
  Future<void> eliminarCompletacion(String habitId, DateTime fecha) async {
    await (_db.delete(_db.habitCompletions)
          ..where((c) =>
              c.habitId.equals(habitId) &
              c.fecha.equals(_soloFecha(fecha))))
        .go();
  }

  /// Devuelve un mapa {fecha → cantidad de hábitos completados ese día}
  /// para los últimos [dias] días del usuario dado.
  Future<Map<DateTime, int>> obtenerMapaCalor({
    required String usuarioId,
    int dias = 112, // 16 semanas
  }) async {
    final desde = _soloFecha(DateTime.now().subtract(Duration(days: dias)));
    final rows = await (_db.select(_db.habitCompletions)
          ..where((c) =>
              c.usuarioId.equals(usuarioId) &
              c.fecha.isBiggerOrEqualValue(desde)))
        .get();

    final mapa = <DateTime, int>{};
    for (final row in rows) {
      final fecha = _soloFecha(row.fecha);
      mapa[fecha] = (mapa[fecha] ?? 0) + 1;
    }
    return mapa;
  }

  /// Devuelve cuántos hábitos distintos completó el usuario cada día
  /// en los últimos 7 días (para estadísticas semanales).
  Future<Map<DateTime, int>> obtenerCompletacionesSemana(
      String usuarioId) async {
    return obtenerMapaCalor(usuarioId: usuarioId, dias: 7);
  }

  // ── Helpers privados ──────────────────────────────────────────────────────

  /// Normaliza una fecha a solo año-mes-día (sin hora)
  DateTime _soloFecha(DateTime dt) =>
      DateTime(dt.year, dt.month, dt.day);

  HabitEntity _rowToEntity(Habit row) {
    return HabitEntity(
      id:              row.id,
      nombre:          row.nombre,
      icono:           row.icono,
      categoria:       CategoriaHabito.values[row.categoria],
      frecuencia:      FrecuenciaHabito.values[row.frecuencia],
      metaSemanal:     row.metaSemanal,
      completadoHoy:   row.completadoHoy,
      rachaActual:     row.rachaActual,
      rachaMaxima:     row.rachaMaxima,
      totalCompletados: row.totalCompletados,
      color:           row.color,
      usuarioId:       row.usuarioId,
      creadoEn:        row.creadoEn,
    );
  }

  HabitsCompanion _entityToCompanion(HabitEntity e) {
    return HabitsCompanion(
      id:              Value(e.id),
      nombre:          Value(e.nombre),
      icono:           Value(e.icono),
      categoria:       Value(e.categoria.index),
      frecuencia:      Value(e.frecuencia.index),
      metaSemanal:     Value(e.metaSemanal),
      completadoHoy:   Value(e.completadoHoy),
      rachaActual:     Value(e.rachaActual),
      rachaMaxima:     Value(e.rachaMaxima),
      totalCompletados: Value(e.totalCompletados),
      color:           Value(e.color),
      usuarioId:       Value(e.usuarioId),
      creadoEn:        Value(e.creadoEn),
    );
  }
}
