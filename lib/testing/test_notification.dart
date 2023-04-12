import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gradproject/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradproject/repository/notification_repository.dart';
import 'package:gradproject/services/notification_service.dart';

testThis() async {
  // // create new notification
  Notification notification = Notification(
    title: "title",
    body: "body",
    targetUserID: "9qaGc8zaFHPDxPCwHlX4dqUr5oj1",
    // senderUserID: "ZidAyWx9HVafLj48IqBLtuMAqTp2",
  );
  // NotificationService.showNotification("title", 'body', 3);
  // // send notification
  // print(await NotificationRepository().pushNotificationToUser(notification));
  // send five messages
  // for (int i = 0; i < 5; i++) {
  //   await NotificationRepository().createNotification(notification);
  // }
  // get all notifications
  // final list = await NotificationRepository()
  //     .getNotifications("ZidAyWx9HVafLj48IqBLtuMAqTp2");
  // list.forEach((element) {
  //   print(element.date);
  // });
  // to get the token
  // User? user = FirebaseAuth.instance.currentUser;
  // print(user?.uid);
  // String? idToken = await user?.getIdToken();
  // print(idToken);
  // to sign out
  // AuthService().signOut();
}
