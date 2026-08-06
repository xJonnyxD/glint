import 'package:hive_flutter/hive_flutter.dart';

import 'package:glint/features/habits/domain/habit_entity.dart';
import 'package:glint/shared/services/notification_service.dart';

/// Recordatorios por hábito. La hora elegida (formato "HH:mm") se guarda en un
/// box de Hive por-dispositivo — las notificaciones son locales, así que no
/// hace falta sincronizarlas ni tocar el esquema remoto. Cada hábito puede
/// tener su propia hora de recordatorio, o ninguna.
class HabitReminderService {
  static const String _boxName = 'glint_habit_reminders';
  static Box? _box;

  static Future<Box> _abrir() async =>
      _box ??= await Hive.openBox(_boxName);

  /// Hora guardada ("HH:mm") o null si el hábito no tiene recordatorio.
  static Future<String?> getHora(String habitId) async {
    final box = await _abrir();
    return box.get(habitId) as String?;
  }

  /// Versión síncrona (si el box ya está abierto), útil para prellenar formularios.
  static String? getHoraSync(String habitId) => _box?.get(habitId) as String?;

  /// Define (o quita, si [horaHHmm] es null/vacío) el recordatorio de un hábito
  /// y programa/cancela la notificación correspondiente.
  static Future<void> definir(
    String habitId,
    String nombre,
    String? horaHHmm,
  ) async {
    final box = await _abrir();
    if (horaHHmm == null || horaHHmm.isEmpty) {
      await box.delete(habitId);
      await NotificationService.cancelarRecordatorioHabito(habitId);
      return;
    }
    await box.put(habitId, horaHHmm);
    final (h, m) = _partes(horaHHmm);
    await NotificationService.programarRecordatorioHabito(
      habitId: habitId,
      nombre: nombre,
      hora: h,
      minuto: m,
    );
  }

  /// Quita el recordatorio de un hábito (al eliminarlo).
  static Future<void> quitar(String habitId) async {
    final box = await _abrir();
    await box.delete(habitId);
    await NotificationService.cancelarRecordatorioHabito(habitId);
  }

  /// Reprograma todos los recordatorios guardados al iniciar la app (las
  /// notificaciones no sobreviven a un reinicio del dispositivo).
  static Future<void> reprogramarTodos(List<HabitEntity> habitos) async {
    final box = await _abrir();
    for (final h in habitos) {
      final hora = box.get(h.id) as String?;
      if (hora != null && hora.isNotEmpty) {
        final (hh, mm) = _partes(hora);
        await NotificationService.programarRecordatorioHabito(
          habitId: h.id,
          nombre: h.nombre,
          hora: hh,
          minuto: mm,
        );
      }
    }
  }

  static (int, int) _partes(String hhmm) {
    final p = hhmm.split(':');
    final h = int.tryParse(p.isNotEmpty ? p[0] : '') ?? 8;
    final m = int.tryParse(p.length > 1 ? p[1] : '') ?? 0;
    return (h, m);
  }
}
