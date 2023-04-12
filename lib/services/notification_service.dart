import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';

/// to use this class
/// first call initialize() method in main.dart
/// then call showNotification() method to show notification in any class
class NotificationService {
  // to make this class a singleton class
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    final InitializationSettings initializationSettingsAndroid =
        InitializationSettings(
            android: AndroidInitializationSettings('app_icon'));
    flutterLocalNotificationsPlugin.initialize(initializationSettingsAndroid);
  }

  /// to request permission for notification
  /// return true if permission granted
  /// return false if permission not granted
  static Future<bool> requestPermission() async {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> showNotification(String title, String body) async {
    if (await requestPermission()) {
      // make channel id depends on time unicode
      int id = Random().nextInt(pow(2, 31).toInt());
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails('1', 'app notification',
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker');
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          id, title, body, platformChannelSpecifics);
    }
  }
}
