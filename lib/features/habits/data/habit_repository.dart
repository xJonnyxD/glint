import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:glint/shared/database/app_database.dart';
import 'package:glint/features/habits/domain/habit_entity.dart';
import 'package:glint/features/habits/domain/racha_calculator.dart';

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

  /// Marca o desmarca el hábito hoy. La racha se recalcula desde el
  /// historial de completaciones (fuente de verdad) en lugar de
  /// sumar/restar a ciegas, para que un día fallado la rompa de verdad.
  /// Devuelve `true` si la completación de hoy realmente cambió de estado
  /// (para que el cubit dé XP solo cuando corresponde, no en doble-toque).
  Future<bool> toggleCompletar(HabitEntity habito, bool completado) async {
    final hoy = _soloFecha(DateTime.now());

    // 1. Registrar o eliminar la completación histórica de hoy.
    //    `cambio` es false si el hábito ya estaba en ese estado (doble toque),
    //    para no inflar ni desinflar el total en ese caso.
    final cambio = completado
        ? await registrarCompletacion(habito.id, habito.usuarioId, hoy)
        : await eliminarCompletacion(habito.id, hoy);

    // 2. Recalcular racha desde el historial
    final fechas = await _fechasCompletadas(habito.id);
    final racha = calcularRacha(
      fechas:      fechas,
      hoy:         hoy,
      frecuencia:  habito.frecuencia,
      metaSemanal: habito.metaSemanal,
    );

    final nuevaRachaMaxima =
        racha > habito.rachaMaxima ? racha : habito.rachaMaxima;

    final nuevoTotal = !cambio
        ? habito.totalCompletados
        : completado
            ? habito.totalCompletados + 1
            : (habito.totalCompletados > 0 ? habito.totalCompletados - 1 : 0);

    await (_db.update(_db.habits)..where((h) => h.id.equals(habito.id))).write(
      HabitsCompanion(
        completadoHoy:   Value(completado),
        rachaActual:     Value(racha),
        rachaMaxima:     Value(nuevaRachaMaxima),
        totalCompletados: Value(nuevoTotal),
        // Marcar para sync: el conteo y la racha cambiaron.
        actualizadoEn:   Value(DateTime.now()),
        pendienteSync:   const Value(true),
      ),
    );
    return cambio;
  }

  /// Debe llamarse al abrir la app: si cambió el día, desmarca
  /// `completadoHoy` y recalcula las rachas según el historial real.
  /// Sin esto, las rachas nunca se rompían al fallar un día.
  Future<void> verificarNuevoDia(String usuarioId) async {
    final hoy = _soloFecha(DateTime.now());
    final habitos = await (_db.select(_db.habits)
          ..where((h) => h.usuarioId.equals(usuarioId)))
        .get();

    for (final h in habitos) {
      await _sembrarHistorialLegacy(h, hoy);
      final fechas = await _fechasCompletadas(h.id);
      final completadoHoy = fechas.contains(hoy);
      final racha = calcularRacha(
        fechas:      fechas,
        hoy:         hoy,
        frecuencia:  FrecuenciaHabito.values[h.frecuencia],
        metaSemanal: h.metaSemanal,
      );
      final rachaMaxima = racha > h.rachaMaxima ? racha : h.rachaMaxima;

      if (completadoHoy != h.completadoHoy ||
          racha != h.rachaActual ||
          rachaMaxima != h.rachaMaxima) {
        // Si cambió la racha (no solo el estado local del día), marcar pendiente
        // para que el nuevo valor suba; si no, la web seguiría con la racha vieja.
        final rachaCambio = racha != h.rachaActual || rachaMaxima != h.rachaMaxima;
        await (_db.update(_db.habits)..where((t) => t.id.equals(h.id))).write(
          HabitsCompanion(
            completadoHoy: Value(completadoHoy),
            rachaActual:   Value(racha),
            rachaMaxima:   Value(rachaMaxima),
            actualizadoEn: rachaCambio ? Value(DateTime.now()) : const Value.absent(),
            pendienteSync: rachaCambio ? const Value(true) : const Value.absent(),
          ),
        );
      }
    }
  }

  /// Los hábitos creados antes de que existiera la tabla de completaciones
  /// (esquema v7) tienen racha pero no historial. Recalcular su racha desde
  /// un historial vacío la borraría, así que primero la reconstruimos: se
  /// asume que los días de la racha son los inmediatamente anteriores.
  Future<void> _sembrarHistorialLegacy(Habit h, DateTime hoy) async {
    if (h.rachaActual <= 0) return;
    final yaTieneHistorial = await (_db.select(_db.habitCompletions)
          ..where((c) => c.habitId.equals(h.id))
          ..limit(1))
        .getSingleOrNull();
    if (yaTieneHistorial != null) return;

    final fechas = fechasParaSembrarLegacy(
      rachaActual:   h.rachaActual,
      completadoHoy: h.completadoHoy,
      hoy:           hoy,
      frecuencia:    FrecuenciaHabito.values[h.frecuencia],
      metaSemanal:   h.metaSemanal,
    );
    for (final fecha in fechas) {
      await registrarCompletacion(h.id, h.usuarioId, fecha);
    }
  }

  /// Fechas (normalizadas a solo día) en que el hábito fue completado.
  Future<Set<DateTime>> _fechasCompletadas(String habitId) async {
    final rows = await (_db.select(_db.habitCompletions)
          ..where((c) => c.habitId.equals(habitId)))
        .get();
    return rows.map((r) => _soloFecha(r.fecha)).toSet();
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
        actualizadoEn: Value(DateTime.now()),
        pendienteSync: const Value(true),
      ),
    );
  }

  Future<void> eliminarHabito(String id) async {
    // Antes de borrar, dejar una tumba para poder borrarlo también en el
    // servidor. Sin esto, la próxima descarga volvería a traer el hábito.
    final row = await (_db.select(_db.habits)..where((h) => h.id.equals(id)))
        .getSingleOrNull();
    if (row != null) {
      await _db.into(_db.syncTombstones).insertOnConflictUpdate(
            SyncTombstonesCompanion.insert(
              filaId: id,
              tabla: 'habits',
              usuarioId: row.usuarioId,
            ),
          );
    }

    await (_db.delete(_db.habits)..where((h) => h.id.equals(id))).go();
    // Las completaciones se borran en cascada en el servidor, así que
    // localmente basta con eliminarlas sin dejar tumba propia.
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
  /// Devuelve `true` solo si realmente insertó una completación nueva.
  Future<bool> registrarCompletacion(
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
    if (existe != null) return false;

    await _db.into(_db.habitCompletions).insert(
          HabitCompletionsCompanion(
            id:        Value(const Uuid().v4()),
            habitId:   Value(habitId),
            usuarioId: Value(usuarioId),
            fecha:     Value(fechaNorm),
          ),
        );
    return true;
  }

  /// Elimina la completación de un hábito para una fecha específica.
  /// Devuelve `true` solo si realmente había una que eliminar.
  Future<bool> eliminarCompletacion(String habitId, DateTime fecha) async {
    final fechaNorm = _soloFecha(fecha);
    // Necesitamos el id para poder borrar la misma fila en el servidor.
    final row = await (_db.select(_db.habitCompletions)
          ..where((c) => c.habitId.equals(habitId) & c.fecha.equals(fechaNorm)))
        .getSingleOrNull();
    if (row == null) return false;

    // Si la completación ya estaba subida (no pendiente), su borrado debe
    // viajar por una tumba. Si nunca llegó a subir, basta con quitarla.
    if (!row.pendienteSync) {
      await _db.into(_db.syncTombstones).insertOnConflictUpdate(
            SyncTombstonesCompanion.insert(
              filaId: row.id,
              tabla: 'habit_completions',
              usuarioId: row.usuarioId,
            ),
          );
    }

    await (_db.delete(_db.habitCompletions)..where((c) => c.id.equals(row.id)))
        .go();
    return true;
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
