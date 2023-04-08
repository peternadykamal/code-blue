import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gradproject/repository/user_repository.dart';

class FcmService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void initialize() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: ${message.data}");
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
