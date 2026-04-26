import 'package:drift/drift.dart' as drift;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:glint/shared/database/app_database.dart';
import 'package:glint/features/habits/data/habit_remote_data_source.dart';
import 'package:glint/features/habits/domain/habit_entity.dart';

/// Orquestador central de sincronización con Supabase
/// Maneja la descarga y subida de datos de todos los módulos
class SyncManager {
  static SyncManager? _instance;

  final AppDatabase _db;
  late final HabitRemoteDataSource _habitRemote;

  SyncManager({
    required SupabaseClient supabase,
    required AppDatabase db,
  })  : _db = db {
    _habitRemote = HabitRemoteDataSource(supabase);
  }

  /// Obtener instancia singleton
  static void initialize({
    required SupabaseClient supabase,
    required AppDatabase db,
  }) {
    _instance = SyncManager(supabase: supabase, db: db);
  }

  static SyncManager get instance {
    if (_instance == null) {
      throw Exception('SyncManager no ha sido inicializado. Llama a initialize()');
    }
    return _instance!;
  }

  /// Sincronizar todos los datos al iniciar sesión
  /// Se ejecuta en background (no espera)
  Future<void> sincronizarAlInicio(String usuarioId) async {
    try {
      // Descargar datos en paralelo
      await Future.wait([
        _sincronizarHabitos(usuarioId),
        // Aquí se agregarían: transacciones, rutinas, notas, eventos, etc.
      ]);
    } catch (e) {
      // No fallar la app si la sync falla
    }
  }

  /// Sincronizar hábitos: descargar de Supabase e insertar en Drift local
  Future<void> _sincronizarHabitos(String usuarioId) async {
    try {
      // 1. Descargar hábitos remotos de Supabase
      final remotos = await _habitRemote.descargarHabitos(usuarioId);

      // 2. Para cada hábito remoto, verificar si existe localmente
      for (var remote in remotos) {
        // Convertir entidad a row para insertar en Drift
        final companion = _entityToCompanion(remote);

        // Upsert: si existe (por ID), actualiza; si no existe, crea
        await _db.into(_db.habits).insert(
          companion,
          onConflict: drift.DoUpdate((_) => companion),
        );
      }
    } catch (e) {
      // Fallar silenciosamente en background
    }
  }

  /// Subir un hábito a Supabase (se llama después de crear localmente)
  Future<void> subirHabito(HabitEntity habit, String usuarioId) async {
    try {
      await _habitRemote.crearHabito(habit, usuarioId);
    } catch (e) {
      // No fallar localmente si Supabase no responde
    }
  }

  /// Actualizar un hábito en Supabase
  Future<void> actualizarHabitoRemoto(HabitEntity habit, String usuarioId) async {
    try {
      await _habitRemote.actualizarHabito(habit, usuarioId);
    } catch (e) {
      // No fallar localmente
    }
  }

  /// Eliminar un hábito de Supabase
  Future<void> eliminarHabitoRemoto(String habitId, String usuarioId) async {
    try {
      await _habitRemote.eliminarHabito(habitId, usuarioId);
    } catch (e) {
      // No fallar localmente
    }
  }

  /// Convertir HabitEntity a Companion para insertar en Drift
  HabitsCompanion _entityToCompanion(HabitEntity entity) {
    return HabitsCompanion(
      id: drift.Value(entity.id),
      nombre: drift.Value(entity.nombre),
      icono: drift.Value(entity.icono),
      categoria: drift.Value(entity.categoria.index),
      frecuencia: drift.Value(entity.frecuencia.index),
      metaSemanal: drift.Value(entity.metaSemanal),
      completadoHoy: drift.Value(entity.completadoHoy),
      rachaActual: drift.Value(entity.rachaActual),
      rachaMaxima: drift.Value(entity.rachaMaxima),
      totalCompletados: drift.Value(entity.totalCompletados),
      color: drift.Value(entity.color),
      usuarioId: drift.Value(entity.usuarioId),
      creadoEn: drift.Value(entity.creadoEn),
    );
  }
}
