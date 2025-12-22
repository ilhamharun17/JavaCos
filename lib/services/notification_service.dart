import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static Future<void> init() async {
    final fm = FirebaseMessaging.instance;
    await fm.requestPermission();
  }
}
