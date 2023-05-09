import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradproject/main.dart';
import 'package:gradproject/repository/invite_repository.dart';
import 'package:gradproject/repository/request_repository.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class Notification {
  // id getter
  String? id;
  String title;
  String body;
  String targetUserID;
  String notificationType;
  String notificationTypeId;
  String? senderUserID;
  // set date to the current date
  DateTime? date;
  bool isSeen;
  User? user = FirebaseAuth.instance.currentUser;

  /// create a new notification
  /// you don't need to set id, date, senderUserID
  /// id will be set automatically when geting getting notification of specific user when calling notificationRepository.getNotifications()
  /// if you didn't set date, it will be set to the current date
  /// if you didn't set senderUserID, it will be set to the current user id
  Notification(
      {required this.title,
      required this.body,
      required this.targetUserID,
      required this.notificationType,
      required this.notificationTypeId,
      this.senderUserID,
      this.date,
      this.isSeen = false,
      this.id,
      langCode}) {
    // set senderUserID if it is null
    if (user != null) {
      senderUserID ??= user?.uid;
    }
    // set date if it is null
    date ??= DateTime.now();

    // depending on lang code, set the title and body
    if (langCode != null) {
      if (notificationType == 'invite') {
        Map<String, String> mapList =
            InviteRepository().formatInviteNotification(title, body);
        title = mapList['title']!;
        body = mapList['body']!;
      } else if (notificationType == 'request') {
        Map<String, String> mapList =
            RequestRepository().formatRequestNotification(title, body);
        title = mapList['title']!;
        body = mapList['body']!;
      }
    }
  }

  /// convert a map to a notification
  static Notification fromMapToNotification(
      String? id, Iterable<DataSnapshot> map) {
    var title = '';
    var body = '';
    var targetUserID = '';
    var senderUserID = '';
    var notificationType = '';
    var notificationTypeId = '';
    DateTime? date;
    bool isSeen = false;
    for (var snapshot in map) {
      switch (snapshot.key) {
        case 'title':
          title = snapshot.value.toString();
          break;
        case 'body':
          body = snapshot.value.toString();
          break;
        case 'targetUserID':
          targetUserID = snapshot.value.toString();
          break;
        case 'senderUserID':
          senderUserID = snapshot.value.toString();
          break;
        case 'notificationType':
          notificationType = snapshot.value.toString();
          break;
        case 'notificationTypeId':
          notificationTypeId = snapshot.value.toString();
          break;
        case 'date':
          date = DateTime.parse(snapshot.value.toString());
          break;
        case 'isSeen':
          isSeen = snapshot.value.toString() == 'true' ? true : false;
          break;
      }
    }
    return Notification(
      id: id,
      title: title,
      body: body,
      targetUserID: targetUserID,
      senderUserID: senderUserID,
      notificationType: notificationType,
      notificationTypeId: notificationTypeId,
      date: date,
      isSeen: isSeen,
      langCode: langCode,
    );
  }

  /// convert a notification to a map
  static Map<String, dynamic> fromNotificationToMap(Notification data) {
    return {
      'title': data.title,
      'body': data.body,
      'targetUserID': data.targetUserID,
      'senderUserID': data.senderUserID,
      'notificationType': data.notificationType,
      'notificationTypeId': data.notificationTypeId,
      'date': data.date.toString(),
      'isSeen': data.isSeen.toString(),
    };
  }
}

class NotificationRepository {
  // create a reference to the database
  final databaseReference =
      FirebaseDatabase.instance.ref().child('notifications');
  User? user = FirebaseAuth.instance.currentUser;

  //create a new notification and return the id of the new notification
  Future<String> createNotification(Notification notification) async {
    final newNotification = databaseReference.push();
    await newNotification.set(Notification.fromNotificationToMap(notification));
    return newNotification.key.toString();
  }

  // get a notification by id
  Future<Notification?> getNotificationById(String notificationID) async {
    final snapshot = await databaseReference.child(notificationID).get();
    if (snapshot.value != null) {
      return Notification.fromMapToNotification(
          snapshot.key, snapshot.children);
    }
  }

  // get all notifications for a specific user
  Future<Map<String, dynamic>> _getNotifications(String targetUserID) async {
    final query =
        databaseReference.orderByChild('targetUserID').equalTo(targetUserID);
    // Get the data snapshot for the query result
    final snapshot = await query.get();
    // Convert the snapshot data into a list of maps
    final List<Notification> notifications = [];
    final List<String> notificationsIds = [];
    if (snapshot.value != null) {
      for (var value in snapshot.children) {
        notificationsIds.add(value.key.toString());
        notifications
            .add(Notification.fromMapToNotification(value.key, value.children));
      }
    }
    // sort notifications by date and ids the newest first
    notificationsIds.sort((a, b) {
      final aIndex = notificationsIds.indexOf(a);
      final bIndex = notificationsIds.indexOf(b) == -1
          ? notificationsIds.length - 1
          : notificationsIds.indexOf(b);
      final aDate =
          aIndex < notifications.length ? notifications[aIndex].date : null;
      final bDate =
          bIndex < notifications.length ? notifications[bIndex].date : null;
      return bDate?.compareTo(aDate!) ?? -1;
    });
    notifications.sort((a, b) => b.date!.compareTo(a.date!));

    return {
      'notifications': notifications,
      'notificationsIds': notificationsIds
    };
  }

  /// get all notifications for the current user in form of a list of objects as invites and requests are notifications
  /// ```dart
  /// final notificationsMap = await notificationRepository.getNotifications();
  /// final notifications = notificationsMap['notifications'];
  /// final notificationsIds = notificationsMap['notificationsIds'];
  /// final notificationsObjects = notificationsMap['notificationsObjects'];
  /// for (var notification in notificationsObjects) {
  ///   if(notification is Invite){
  ///     print(notification.inviteSenderID);
  ///     print(notification.inviteReceiverID);
  ///   }
  ///   else if(notification is Request){
  ///     print(notification.latitude);
  ///     print(notification.longitude);
  ///   }
  /// }
  /// ```
  Future<Map<String, dynamic>> getNotifications() async {
    Map<String, dynamic> notificationsMap = await _getNotifications(user!.uid);
    List<Notification> notifications = notificationsMap['notifications'];
    final List<dynamic> notificationsObjects = [];

    for (var notification in notifications) {
      switch (notification.notificationType) {
        case 'invite':
          notificationsObjects.add(await InviteRepository()
              .getInviteById(notification.notificationTypeId));
          break;
        case 'request':
          notificationsObjects.add(await RequestRepository()
              .getRequestById(notification.notificationTypeId));
          break;
      }
    }
    return {
      'notificationsObjects': notificationsObjects,
      'notificationsIds': notificationsMap['notificationsIds'],
      "notifications": notificationsMap['notifications']
    };
  }

  /// mark all notifications as seen
  /// ```dart
  /// await notificationRepository.markAllNotificationsAsSeen();
  /// ```
  Future<void> markAllNotificationsAsSeen(
      List<Notification> notifications, List<String> notificationsIds) async {
    for (int i = 0; i < notifications.length; i++) {
      if (!notifications[i].isSeen) {
        await updateNotificationSeenStatus(notificationsIds[i], true);
      } else {
        break;
      }
    }
  }

  /// check if there is any new notification for the current user
  /// ```dart
  /// final hasNewNotification = await notificationRepository.hasNewNotification();
  /// ```
  Future<bool> hasNewNotification() async {
    Map<String, dynamic> notificationsMap = await _getNotifications(user!.uid);
    List<Notification> notifications = notificationsMap['notifications'];
    for (var notification in notifications) {
      if (!notification.isSeen) {
        return true;
      }
    }
    return false;
  }

  /// update the seen status of a notification
  /// notificationId can be found in the notification object itself after calling getNotifications method
  /// isSeen is a boolean value
  /// true means the notification is seen
  /// false means the notification is not seen
  Future<void> updateNotificationSeenStatus(
      String notificationID, bool isSeen) async {
    await databaseReference.child(notificationID).update({
      'isSeen': isSeen.toString(),
    });
  }

  // delete a notification
  Future<void> deleteNotification(String notificationID) async {
    await databaseReference.child(notificationID).remove();
  }

  /// this function
  /// 1. create a new entry in notifications table
  /// 2. send a request to the server to send a notification to the user (works only if the user is online)
  ///  return true if the server return 200 status code and if the user is online
  /// return false if the server return a code other than 200 or if the user is offline
  /// ```dart
  /// final result = await pushNotificationToUser(notification);
  /// if (result['success']) {
  ///     final notificationId = result['notificationId'];
  ///     // do something with the notificationId
  /// }
  /// ```
  Future<Map<String, dynamic>> pushNotificationToUser(
      Notification notification) async {
    // check if the user is logged in
    if (user == null) return {'success': false};

    // create a new notification
    String notificationId = await createNotification(notification);

    // send a request to the server to send a notification to the user
    final url =
        Uri.parse('${dotenv.env['FIREBASE_SERVER_URL']!}/push-notification');
    String idToken = await user!.getIdToken();
    final headers = {'Content-Type': 'application/json'};
    final body =
        jsonEncode({'idToken': idToken, 'notificationId': notificationId});
    final response = await http.post(url, headers: headers, body: body);

    // there is no reason to completely delete the notification if we failed to push to the other device
    //as it will appear in the notification list
    // if (response.statusCode != 200) {
    //   // delete the notification if the server return a code other than 200
    //   await deleteNotification(notificationId);
    //   notificationId = '';
    // }

    return {
      'success': response.statusCode == 200,
      'notificationId': notificationId
    };
  }
}
