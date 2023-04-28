import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gradproject/repository/notification_repository.dart';
import 'package:gradproject/repository/request_repository.dart';
import 'package:gradproject/repository/user_repository.dart';
import 'package:gradproject/services/auth_service.dart';
import 'package:gradproject/services/notification_service.dart';

// Future<void> backgroundMessageHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   FirebaseDatabase.instance.setPersistenceEnabled(true);
//   FirebaseDatabase.instance.setPersistenceCacheSizeBytes(10000000);
//   DatabaseReference reference = FirebaseDatabase.instance.ref();
//   reference.keepSynced(true);
//   // initialize the auth service
//   AuthService().initialize();
//   // initialize the notification service
//   NotificationService.initialize();
//   // load dotenv file
//   await dotenv.load(fileName: ".env");

//   await messageHandler(message);
// }

Future<void> messageHandler(RemoteMessage message) async {
  if (message.data['targetUserID'] == UserRepository().user?.uid) {
    // make sure title, body and notification is not null
    String? title = message.notification?.title;
    String? body = message.notification?.body;
    if (title != null && body != null) {
      String notificationId = message.data['notificationId'];
      Notification? notification =
          await NotificationRepository().getNotificationById(notificationId);
      if (notification != null) {
        if (notification.notificationType == 'request') {
          try {
            Request request = await RequestRepository()
                .getRequestById(notification.notificationTypeId);
            NotificationService.showMapNotification(
                title, body, request.latitude!, request.longitude!);
          } catch (e) {
            print(e);
          }
        } else if (notification.notificationType == 'invite') {
          NotificationService.showNotification(title, body);
        }
      }
    }
  }
}

// https://firebase.google.com/docs/cloud-messaging/flutter/receive
class FcmService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      messageHandler(initialMessage);
    }
    FirebaseMessaging.onMessage.listen(messageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(messageHandler);
    _firebaseMessaging.getToken().then((token) {
      print("FCM token: $token");
      UserRepository().updateFcmToken(token!);
    });
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      print("FCM token refreshed: $newToken");
      UserRepository().updateFcmToken(newToken);
    });
  }
}
