import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  static final _local = FlutterLocalNotificationsPlugin();
  static final _firebase = FirebaseMessaging.instance;
  static final _supabase = Supabase.instance.client;

  // ================= INIT =================
  static Future<void> init() async {
    // 🔔 Permission
    await _firebase.requestPermission(alert: true, badge: true, sound: true);

    // 📱 Local notification init (FIX ICON)
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _local.initialize(settings);

    // 🔑 Get & save FCM token
    final token = await _firebase.getToken();
    debugPrint('🔥 FCM TOKEN: $token');

    if (token != null) {
      await _saveTokenToSupabase(token);
    }

    // 🔔 Foreground message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(
        message.notification?.title ?? 'Notification',
        message.notification?.body ?? '',
      );
    });
  }

  // ================= SAVE TOKEN =================
  static Future<void> _saveTokenToSupabase(String token) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await _supabase
        .from('profiles')
        .update({'fcm_token': token})
        .eq('id', user.id);
  }

  // ================= SHOW NOTIFICATION =================
  static Future<void> showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'General Notification',
      channelDescription: 'App notifications',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const details = NotificationDetails(android: androidDetails);

    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }
}
