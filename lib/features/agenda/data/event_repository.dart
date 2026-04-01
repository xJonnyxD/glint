import 'package:drift/drift.dart';
import 'package:glint/shared/database/app_database.dart';
import 'package:glint/features/agenda/domain/event_entity.dart';

class EventRepository {
  final AppDatabase _db;

  EventRepository(this._db);

  /// Stream de todos los eventos del usuario, ordenados por fecha
  Stream<List<EventEntity>> watchEventos(String usuarioId) {
    return (_db.select(_db.events)
          ..where((e) => e.usuarioId.equals(usuarioId))
          ..orderBy([(e) => OrderingTerm.asc(e.fecha)]))
        .watch()
        .map((rows) => rows.map(_toEntity).toList());
  }

  /// Eventos de un día específico
  Stream<List<EventEntity>> watchDia(String usuarioId, DateTime dia) {
    final inicio = DateTime(dia.year, dia.month, dia.day);
    final fin    = inicio.add(const Duration(days: 1));

    return (_db.select(_db.events)
          ..where((e) =>
              e.usuarioId.equals(usuarioId) &
              e.fecha.isBiggerOrEqualValue(inicio) &
              e.fecha.isSmallerThanValue(fin))
          ..orderBy([(e) => OrderingTerm.asc(e.fecha)]))
        .watch()
        .map((rows) => rows.map(_toEntity).toList());
  }

  Future<void> crearEvento(EventEntity evento) async {
    await _db.into(_db.events).insert(_toCompanion(evento));
  }

  Future<void> toggleCompletado(String id, bool completado) async {
    await (_db.update(_db.events)..where((e) => e.id.equals(id)))
        .write(EventsCompanion(completado: Value(completado)));
  }

  Future<void> eliminarEvento(String id) async {
    await (_db.delete(_db.events)..where((e) => e.id.equals(id))).go();
  }

  EventEntity _toEntity(Event row) => EventEntity(
        id:          row.id,
        titulo:      row.titulo,
        descripcion: row.descripcion,
        fecha:       row.fecha,
        hora:        row.hora,
        todoElDia:   row.todoElDia,
        completado:  row.completado,
        color:       row.color,
        tipo:        row.tipo == 'tarea' ? TipoEvento.tarea : TipoEvento.evento,
        usuarioId:   row.usuarioId,
        creadoEn:    row.creadoEn,
      );

  EventsCompanion _toCompanion(EventEntity e) => EventsCompanion(
        id:          Value(e.id),
        titulo:      Value(e.titulo),
        descripcion: Value(e.descripcion),
        fecha:       Value(e.fecha),
        hora:        Value(e.hora),
        todoElDia:   Value(e.todoElDia),
        completado:  Value(e.completado),
        color:       Value(e.color),
        tipo:        Value(e.esTarea ? 'tarea' : 'evento'),
        usuarioId:   Value(e.usuarioId),
        creadoEn:    Value(e.creadoEn),
      );
}
