import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gradproject/repository/user_repository.dart';
import 'package:gradproject/services/notification_service.dart';

class FcmService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void initialize() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data['targetUserID'] == UserRepository().user?.uid) {
        // make sure title, body and notification is not null
        String? title = message.notification?.title;
        String? body = message.notification?.body;
        if (title != null && body != null) {
          NotificationService.showNotification(title, body);
        }
      }
    });
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
