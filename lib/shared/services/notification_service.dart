import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

/// Servicio de notificaciones locales usando awesome_notifications.
/// Maneja recordatorios de rutinas, hábitos y eventos de agenda.
class NotificationService {
  // IDs de los canales de notificación (uno por módulo)
  static const String _canalRutinas = 'glint_rutinas';
  static const String _canalHabitos = 'glint_habitos';
  static const String _canalAgenda = 'glint_agenda';
  static const String _canalGeneral = 'glint_general';

  /// Inicializa awesome_notifications con todos los canales.
  /// Llamar una sola vez en main() antes de runApp().
  static Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      null, // null = ícono por defecto de la app
      [
        // Canal de Rutinas
        NotificationChannel(
          channelKey: _canalRutinas,
          channelName: 'Rutinas diarias',
          channelDescription: 'Recordatorios para completar tus rutinas',
          defaultColor: const Color(0xFF6750A4),
          ledColor: const Color(0xFF6750A4),
          importance: NotificationImportance.High,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
        ),
        // Canal de Hábitos
        NotificationChannel(
          channelKey: _canalHabitos,
          channelName: 'Hábitos',
          channelDescription: 'Recordatorios para completar tus hábitos',
          defaultColor: const Color(0xFF1E88E5),
          ledColor: const Color(0xFF1E88E5),
          importance: NotificationImportance.Default,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
        ),
        // Canal de Agenda
        NotificationChannel(
          channelKey: _canalAgenda,
          channelName: 'Agenda y eventos',
          channelDescription: 'Recordatorios de eventos y tareas pendientes',
          defaultColor: const Color(0xFF43A047),
          ledColor: const Color(0xFF43A047),
          importance: NotificationImportance.High,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
        ),
        // Canal General
        NotificationChannel(
          channelKey: _canalGeneral,
          channelName: 'General',
          channelDescription: 'Notificaciones generales de Glint',
          defaultColor: const Color(0xFF6750A4),
          ledColor: const Color(0xFF6750A4),
          importance: NotificationImportance.Low,
          channelShowBadge: false,
        ),
      ],
      debug: false,
    );
  }

  /// Solicita permiso para enviar notificaciones (Android 13+).
  /// Retorna true si el permiso fue concedido.
  static Future<bool> solicitarPermiso() async {
    final permitido = await AwesomeNotifications().isNotificationAllowed();
    if (!permitido) {
      return await AwesomeNotifications().requestPermissionToSendNotifications();
    }
    return true;
  }

  // ── RUTINAS ───────────────────────────────────────────────────────────────

  /// Programa un recordatorio diario de rutinas a la hora indicada.
  /// [hora] formato "HH:MM", ej: "07:00"
  static Future<void> programarRecordatorioRutinas({
    required String hora,
    required int totalRutinas,
  }) async {
    await cancelarRecordatorioRutinas();

    final partes = hora.split(':');
    final hh = int.tryParse(partes[0]) ?? 7;
    final mm = int.tryParse(partes[1]) ?? 0;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1001,
        channelKey: _canalRutinas,
        title: '☀️ Buenos días, Glint te recuerda',
        body: 'Tienes $totalRutinas rutinas pendientes para hoy. '
            '¡Empieza tu día con energía!',
        notificationLayout: NotificationLayout.Default,
        wakeUpScreen: true,
        category: NotificationCategory.Reminder,
      ),
      schedule: NotificationCalendar(
        hour: hh,
        minute: mm,
        second: 0,
        repeats: true, // se repite todos los días
        allowWhileIdle: true,
      ),
    );
  }

  /// Cancela el recordatorio diario de rutinas
  static Future<void> cancelarRecordatorioRutinas() async {
    await AwesomeNotifications().cancel(1001);
  }

  // ── HÁBITOS ───────────────────────────────────────────────────────────────

  /// Programa un recordatorio diario de hábitos (tarde, por defecto 18:00)
  static Future<void> programarRecordatorioHabitos({
    String hora = '18:00',
  }) async {
    await cancelarRecordatorioHabitos();

    final partes = hora.split(':');
    final hh = int.tryParse(partes[0]) ?? 18;
    final mm = int.tryParse(partes[1]) ?? 0;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1002,
        channelKey: _canalHabitos,
        title: '💪 ¿Ya completaste tus hábitos?',
        body: 'No pierdas tu racha de hoy. '
            'Unos minutos hacen la diferencia.',
        notificationLayout: NotificationLayout.Default,
        wakeUpScreen: false,
        category: NotificationCategory.Reminder,
      ),
      schedule: NotificationCalendar(
        hour: hh,
        minute: mm,
        second: 0,
        repeats: true,
        allowWhileIdle: true,
      ),
    );
  }

  /// Cancela el recordatorio de hábitos
  static Future<void> cancelarRecordatorioHabitos() async {
    await AwesomeNotifications().cancel(1002);
  }

  // ── AGENDA ────────────────────────────────────────────────────────────────

  /// Programa una notificación para un evento específico de la agenda.
  /// Se envía 30 minutos antes del evento.
  static Future<void> programarNotificacionEvento({
    required int id,
    required String titulo,
    required DateTime fechaEvento,
    String? descripcion,
  }) async {
    // Restar 30 minutos al evento
    final fechaNotif = fechaEvento.subtract(const Duration(minutes: 30));

    // No programar si ya pasó
    if (fechaNotif.isBefore(DateTime.now())) return;

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2000 + id,
        channelKey: _canalAgenda,
        title: '📅 En 30 min: $titulo',
        body: descripcion ?? 'Tienes un evento próximamente en tu agenda.',
        notificationLayout: NotificationLayout.Default,
        wakeUpScreen: true,
        category: NotificationCategory.Event,
      ),
      schedule: NotificationCalendar.fromDate(
        date: fechaNotif,
        allowWhileIdle: true,
      ),
    );
  }

  /// Cancela la notificación de un evento específico
  static Future<void> cancelarNotificacionEvento(int id) async {
    await AwesomeNotifications().cancel(2000 + id);
  }

  // ── GENERAL ───────────────────────────────────────────────────────────────

  /// Muestra una notificación inmediata (para pruebas o bienvenida)
  static Future<void> mostrarNotificacionInmediata({
    required String titulo,
    required String cuerpo,
    String canal = _canalGeneral,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch % 100000,
        channelKey: canal,
        title: titulo,
        body: cuerpo,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }

  /// Cancela TODAS las notificaciones programadas
  static Future<void> cancelarTodas() async {
    await AwesomeNotifications().cancelAll();
  }

  /// Verifica si las notificaciones están habilitadas
  static Future<bool> estaHabilitado() async {
    return await AwesomeNotifications().isNotificationAllowed();
  }
}
