import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _notifications.initialize(settings);
  }

  static Future<void> showOrderSuccess() async {
    const androidDetails = AndroidNotificationDetails(
      'order_channel',
      'Order Notification',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notifications.show(
      0,
      'Order Berhasil 🎉',
      'Pesanan kamu berhasil dibuat dan sedang diproses',
      notificationDetails,
    );
  }
}
