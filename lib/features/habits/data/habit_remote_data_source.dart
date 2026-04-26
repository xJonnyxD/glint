import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:glint/features/habits/domain/habit_entity.dart';

/// Comunica con Supabase para sincronizar hábitos
class HabitRemoteDataSource {
  final SupabaseClient _supabase;

  HabitRemoteDataSource(this._supabase);

  /// Subir un hábito a Supabase
  Future<void> crearHabito(HabitEntity habit, String usuarioId) async {
    await _supabase.from('habits').insert({
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
      'creada_en': DateTime.now().toIso8601String(),
      'actualizada_en': DateTime.now().toIso8601String(),
    });
  }

  /// Actualizar un hábito en Supabase
  Future<void> actualizarHabito(HabitEntity habit, String usuarioId) async {
    await _supabase.from('habits').update({
      'nombre': habit.nombre,
      'icono': habit.icono,
      'categoria': habit.categoria.index,
      'frecuencia': habit.frecuencia.index,
      'meta_semanal': habit.metaSemanal,
      'racha_actual': habit.rachaActual,
      'racha_maxima': habit.rachaMaxima,
      'total_completados': habit.totalCompletados,
      'color': habit.color,
      'actualizada_en': DateTime.now().toIso8601String(),
    }).eq('id', habit.id).eq('user_id', usuarioId);
  }

  /// Eliminar un hábito de Supabase
  Future<void> eliminarHabito(String habitId, String usuarioId) async {
    await _supabase
        .from('habits')
        .delete()
        .eq('id', habitId)
        .eq('user_id', usuarioId);
  }

  /// Descargar todos los hábitos del usuario desde Supabase
  Future<List<HabitEntity>> descargarHabitos(String usuarioId) async {
    final response = await _supabase
        .from('habits')
        .select()
        .eq('user_id', usuarioId)
        .order('creada_en', ascending: false);

    return (response as List).map((h) => _remoteToEntity(h, usuarioId)).toList();
  }

  /// Convertir datos remotos (JSON) a entidad local
  HabitEntity _remoteToEntity(Map<String, dynamic> data, String usuarioId) {
    return HabitEntity(
      id: data['id'] as String,
      nombre: data['nombre'] as String,
      icono: data['icono'] as String,
      categoria: CategoriaHabito.values[data['categoria'] as int],
      frecuencia: FrecuenciaHabito.values[data['frecuencia'] as int],
      metaSemanal: data['meta_semanal'] as int? ?? 7,
      completadoHoy: false, // Se actualiza localmente
      rachaActual: data['racha_actual'] as int? ?? 0,
      rachaMaxima: data['racha_maxima'] as int? ?? 0,
      totalCompletados: data['total_completados'] as int? ?? 0,
      color: data['color'] as String? ?? '#FF6B6B',
      usuarioId: usuarioId,
      creadoEn: DateTime.parse(data['creada_en'] as String),
    );
  }
}
