import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:glint/features/habits/domain/habit_entity.dart';

/// Un hábito tal y como vive en Supabase, con su marca de actualización.
/// La marca es lo que permite resolver conflictos entre dispositivos.
class HabitRemoto {
  final HabitEntity habito;
  final DateTime actualizadoEn;
  const HabitRemoto(this.habito, this.actualizadoEn);
}

/// Una completación tal y como vive en Supabase.
class CompletacionRemota {
  final String id;
  final String habitId;
  final DateTime fecha;
  const CompletacionRemota({
    required this.id,
    required this.habitId,
    required this.fecha,
  });
}

/// Comunica con Supabase para sincronizar hábitos y sus completaciones.
class HabitRemoteDataSource {
  final SupabaseClient _supabase;

  HabitRemoteDataSource(this._supabase);

  // ── Hábitos ─────────────────────────────────────────────────────────────

  /// Sube un hábito (crea o actualiza). Envía `actualizada_en` para que el
  /// otro dispositivo pueda resolver el conflicto por fecha.
  Future<void> subirHabito(
    HabitEntity habit,
    String usuarioId,
    DateTime actualizadoEn,
  ) async {
    await _supabase.from('habits').upsert({
      'id': habit.id,
      'user_id': usuarioId,
      'nombre': habit.nombre,
      'icono': habit.icono,
      'categoria': habit.categoria.index,
      'frecuencia': habit.frecuencia.index,
      'meta_semanal': habit.metaSemanal,
      'racha_actual': habit.rachaActual,
      'racha_maxima': habit.rachaMaxima,
      'total_completados': habit.totalCompletados,
      'color': habit.color,
      'creada_en': habit.creadoEn.toIso8601String(),
      'actualizada_en': actualizadoEn.toIso8601String(),
    });
  }

  Future<void> eliminarHabito(String habitId, String usuarioId) async {
    await _supabase
        .from('habits')
        .delete()
        .eq('id', habitId)
        .eq('user_id', usuarioId);
  }

  /// Descarga todos los hábitos del usuario, con su marca de actualización.
  Future<List<HabitRemoto>> descargarHabitos(String usuarioId) async {
    final response = await _supabase
        .from('habits')
        .select()
        .eq('user_id', usuarioId);

    return (response as List).map((h) {
      final data = h as Map<String, dynamic>;
      return HabitRemoto(
        _remoteToEntity(data, usuarioId),
        DateTime.tryParse(data['actualizada_en'] as String? ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0),
      );
    }).toList();
  }

  // ── Completaciones ──────────────────────────────────────────────────────

  Future<void> subirCompletaciones(
    List<Map<String, dynamic>> filas,
  ) async {
    if (filas.isEmpty) return;
    await _supabase.from('habit_completions').upsert(filas);
  }

  Future<void> eliminarCompletacion(String id, String usuarioId) async {
    await _supabase
        .from('habit_completions')
        .delete()
        .eq('id', id)
        .eq('user_id', usuarioId);
  }

  Future<List<CompletacionRemota>> descargarCompletaciones(
    String usuarioId,
  ) async {
    final response = await _supabase
        .from('habit_completions')
        .select()
        .eq('user_id', usuarioId);

    return (response as List).map((c) {
      final data = c as Map<String, dynamic>;
      return CompletacionRemota(
        id: data['id'] as String,
        habitId: data['habit_id'] as String,
        fecha: DateTime.parse(data['fecha'] as String),
      );
    }).toList();
  }

  // ── Conversión ──────────────────────────────────────────────────────────

  HabitEntity _remoteToEntity(Map<String, dynamic> data, String usuarioId) {
    return HabitEntity(
      id: data['id'] as String,
      nombre: data['nombre'] as String,
      icono: data['icono'] as String,
      categoria: CategoriaHabito.values[data['categoria'] as int],
      frecuencia: FrecuenciaHabito.values[data['frecuencia'] as int],
      metaSemanal: data['meta_semanal'] as int? ?? 7,
      completadoHoy: false, // se recalcula localmente al abrir la app
      rachaActual: data['racha_actual'] as int? ?? 0,
      rachaMaxima: data['racha_maxima'] as int? ?? 0,
      totalCompletados: data['total_completados'] as int? ?? 0,
      color: data['color'] as String? ?? '#1E88E5',
      usuarioId: usuarioId,
      creadoEn: DateTime.tryParse(data['creada_en'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
