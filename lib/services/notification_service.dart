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

// TODO: if the notification type is navigation open google maps with the location instead of opening the app
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

// static Future<void> showNotification(String title, String body, {double latitude, double longitude}) async {
//   if (await requestPermission()) {
//     int id = Random().nextInt(pow(2, 31).toInt());

//     AndroidNotificationDetails androidPlatformChannelSpecifics;

//     if (latitude != null && longitude != null) {
//       // Intent to open Google Maps with the specified latitude and longitude
//       final String intentData = 'geo:$latitude,$longitude?q=$latitude,$longitude';
//       final AndroidIntent intent = AndroidIntent(
//         action: 'action_view',
//         data: Uri.parse(intentData),
//         package: 'com.google.android.apps.maps',
//       );

//       // Notification channel with the Google Maps intent
//       androidPlatformChannelSpecifics = AndroidNotificationDetails(
//         'maps_channel',
//         'Google Maps',
//         'Notifications that open Google Maps when clicked',
//         importance: Importance.max,
//         priority: Priority.high,
//         ticker: 'ticker',
//         category: 'navigation',
//         fullScreenIntent: true,
//         playSound: true,
//         sound: RawResourceAndroidNotificationSound('notification'),
//         channelShowBadge: true,
//         channelAction: AndroidNotificationChannelAction.createAction(
//           intent: intent,
//           label: 'Open in Google Maps',
//         ),
//       );
//     } else {
//       // Notification channel without the Google Maps intent
//       androidPlatformChannelSpecifics = AndroidNotificationDetails(
//         'default_channel',
//         'Default Channel',
//         'Notifications without Google Maps intent',
//         importance: Importance.max,
//         priority: Priority.high,
//         ticker: 'ticker',
//       );
//     }

//     NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//         id, title, body, platformChannelSpecifics);
//   }
// }
