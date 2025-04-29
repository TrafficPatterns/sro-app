import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static void init() {
    InitializationSettings initializationSettings =
        const InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"),
            iOS: DarwinInitializationSettings());
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static display(RemoteMessage message) async {
    const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "sro",
          "sro_channel",
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails());
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await _flutterLocalNotificationsPlugin.show(id, message.notification!.title,
        message.notification?.body, notificationDetails);
  }
}
