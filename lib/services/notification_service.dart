import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math';
import 'package:android_intent_plus/android_intent.dart';

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
    flutterLocalNotificationsPlugin.initialize(initializationSettingsAndroid,
        onDidReceiveNotificationResponse: (NotificationResponse not) {
      if (not.payload != null) {
        String latitude = not.payload!.split(",")[0];
        String longitude = not.payload!.split(",")[1];
        const String label = 'Googleplex';
        final String uri =
            'geo:$latitude,$longitude?q=$latitude,$longitude($label)';

        final AndroidIntent intent = AndroidIntent(
          action: 'action_view',
          data: Uri.encodeFull(uri),
          package: 'com.google.android.apps.maps',
        );
        intent.launch().then((value) => null);
        // convert payload to list of strings
      }
    });
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

  static Future<void> showMapNotification(
      String title, String body, String latitude, String longitude) async {
    if (await requestPermission()) {
      // make channel id depends on time unicode
      int id = Random().nextInt(pow(2, 31).toInt());
      // this notifcation will be used to open google maps
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails('1', 'app notification',
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker',
              category: AndroidNotificationCategory.navigation);
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          id, title, body, platformChannelSpecifics,
          payload: "$latitude,$longitude");
    }
  }
}
