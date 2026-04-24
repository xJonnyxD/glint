import 'package:drift/drift.dart';
import 'package:glint/shared/database/app_database.dart';
import 'package:glint/features/routines/domain/routine_entity.dart';

/// Repositorio de rutinas — traduce entre la BD (Drift) y el dominio (RoutineEntity).
/// La pantalla solo conoce RoutineEntity, nunca los objetos de Drift directamente.
class RoutineRepository {
  final AppDatabase _db;

  RoutineRepository(this._db);

  /// Obtiene todas las rutinas del usuario ordenadas por período y orden
  Future<List<RoutineEntity>> obtenerRutinas(String usuarioId) async {
    final rows = await (_db.select(_db.routines)
          ..where((r) => r.usuarioId.equals(usuarioId))
          ..orderBy([
            (r) => OrderingTerm(expression: r.periodo),
            (r) => OrderingTerm(expression: r.orden),
          ]))
        .get();
    return rows.map(_rowToEntity).toList();
  }

  /// Escucha cambios en las rutinas en tiempo real (Stream)
  Stream<List<RoutineEntity>> watchRutinas(String usuarioId) {
    return (_db.select(_db.routines)
          ..where((r) => r.usuarioId.equals(usuarioId))
          ..orderBy([
            (r) => OrderingTerm(expression: r.periodo),
            (r) => OrderingTerm(expression: r.orden),
          ]))
        .watch()
        .map((rows) => rows.map(_rowToEntity).toList());
  }

  /// Crea una rutina nueva
  Future<void> crearRutina(RoutineEntity rutina) async {
    await _db.into(_db.routines).insert(_entityToCompanion(rutina));
  }

  /// Marca o desmarca una rutina como completada hoy
  Future<void> toggleCompletar(String id, bool completada) async {
    await (_db.update(_db.routines)..where((r) => r.id.equals(id))).write(
      RoutinesCompanion(completadaHoy: Value(completada)),
    );
  }

  /// Actualiza la racha de una rutina
  Future<void> actualizarRacha(String id, int nuevaRacha) async {
    await (_db.update(_db.routines)..where((r) => r.id.equals(id))).write(
      RoutinesCompanion(rachaActual: Value(nuevaRacha)),
    );
  }

  /// Edita los datos de una rutina existente
  Future<void> editarRutina({
    required String id,
    required String nombre,
    required String icono,
    required PeriodoDelDia periodo,
    required String hora,
  }) async {
    await (_db.update(_db.routines)..where((r) => r.id.equals(id))).write(
      RoutinesCompanion(
        nombre:  Value(nombre),
        icono:   Value(icono),
        periodo: Value(periodo.index),
        hora:    Value(hora),
      ),
    );
  }

  /// Elimina una rutina
  Future<void> eliminarRutina(String id) async {
    await (_db.delete(_db.routines)..where((r) => r.id.equals(id))).go();
  }

  /// Resetea todas las rutinas del usuario a "no completadas" (nuevo día)
  Future<void> resetearDiario(String usuarioId) async {
    await (_db.update(_db.routines)
          ..where((r) => r.usuarioId.equals(usuarioId)))
        .write(const RoutinesCompanion(completadaHoy: Value(false)));
  }

  // ── Conversores privados ──────────────────────────────────────────────────

  RoutineEntity _rowToEntity(Routine row) {
    return RoutineEntity(
      id:            row.id,
      nombre:        row.nombre,
      icono:         row.icono,
      periodo:       PeriodoDelDia.values[row.periodo],
      hora:          row.hora,
      completadaHoy: row.completadaHoy,
      rachaActual:   row.rachaActual,
      orden:         row.orden,
      usuarioId:     row.usuarioId,
      creadaEn:      row.creadaEn,
    );
  }

  RoutinesCompanion _entityToCompanion(RoutineEntity e) {
    return RoutinesCompanion(
      id:            Value(e.id),
      nombre:        Value(e.nombre),
      icono:         Value(e.icono),
      periodo:       Value(e.periodo.index),
      hora:          Value(e.hora),
      completadaHoy: Value(e.completadaHoy),
      rachaActual:   Value(e.rachaActual),
      orden:         Value(e.orden),
      usuarioId:     Value(e.usuarioId),
      creadaEn:      Value(e.creadaEn),
    );
  }
}
