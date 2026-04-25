import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

/// Maneja los taps en notificaciones y navega a la ruta correcta
class NotificationHandler {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Configura el listener de taps en notificaciones.
  /// Llamar una vez en main() después de NotificationService.initialize().
  static Future<void> initialize() async {
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: _onActionReceived,
    );
  }

  @pragma('vm:entry-point')
  static Future<void> _onActionReceived(
      ReceivedAction receivedAction) async {
    final ruta = receivedAction.payload?['ruta'];
    if (ruta == null || ruta.isEmpty) return;

    final context = navigatorKey.currentContext;
    if (context == null) return;

    GoRouter.of(context).go(ruta);
  }
}
