import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gradproject/utils/has_network.dart';
import 'dart:convert';

class Notification {
  // id getter
  String? id;
  String title;
  String body;
  String targetUserID;
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
  Notification({
    required this.title,
    required this.body,
    required this.targetUserID,
    this.senderUserID,
    this.date,
    this.isSeen = false,
    this.id,
  }) {
    // set senderUserID if it is null
    if (user != null) {
      senderUserID ??= user?.uid;
    }
    // set date if it is null
    date ??= DateTime.now();
  }

  /// convert a map to a notification
  static Notification fromMapToNotification(
      String? id, Iterable<DataSnapshot> map) {
    var title = '';
    var body = '';
    var targetUserID = '';
    var senderUserID = '';
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
      date: date,
      isSeen: isSeen,
    );
  }

  /// convert a notification to a map
  static Map<String, dynamic> fromNotificationToMap(Notification data) {
    return {
      'title': data.title,
      'body': data.body,
      'targetUserID': data.targetUserID,
      'senderUserID': data.senderUserID,
      'date': data.date.toString(),
      'isSeen': data.isSeen,
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

  // get all notifications for a specific user
  Future<List<Notification>> getNotifications(String targetUserID) async {
    final query =
        databaseReference.orderByChild('targetUserID').equalTo(targetUserID);
    // Get the data snapshot for the query result
    final snapshot = await query.get();
    // Convert the snapshot data into a list of maps
    final List<Notification> notifications = [];

    if (snapshot.value != null) {
      for (var value in snapshot.children) {
        notifications
            .add(Notification.fromMapToNotification(value.key, value.children));
      }
    }
    return notifications;
  }

  /// update the seen status of a notification
  /// notificationId can be found in the notification object itself after calling getNotifications method
  /// isSeen is a boolean value
  /// true means the notification is seen
  /// false means the notification is not seen
  Future<void> updateNotificationSeenStatus(
      String notificationID, bool isSeen) async {
    await databaseReference.child(notificationID).update({
      'isSeen': isSeen,
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
  Future<bool> pushNotificationToUser(Notification notification) async {
    //  check if there is a internet connection
    bool isOnline = await hasNetwork();
    if (!isOnline) return false;

    // check if the user is logged in
    if (user == null) return false;

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
    return response.statusCode == 200;
  }
}
