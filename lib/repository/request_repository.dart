import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gradproject/repository/user_repository.dart';
import 'package:gradproject/repository/relation_repository.dart';
import 'package:gradproject/repository/notification_repository.dart';
import 'package:gradproject/utils/has_network.dart';
import 'package:gradproject/utils/user_geolocation.dart';
import '../services/sms_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Request {
  String userID;
  String patient;
  String? latitude;
  String? longitude;
  DateTime? dateTime;
  Request(
      {required this.userID,
      required this.patient,
      this.dateTime,
      this.latitude,
      this.longitude}) {
    dateTime ??= DateTime.now();
  }

  static Map<String, dynamic> fromRequestToMap(Request data) {
    Map<String, dynamic> updateData = {
      'userID': data.userID,
      'patient': data.patient,
      'dataTime': data.dateTime.toString(),
    };
    if (data.latitude != null) {
      updateData['latitude'] = data.latitude;
    }
    if (data.longitude != null) {
      updateData['longitude'] = data.longitude;
    }
    return updateData;
  }

  static Request fromMapToRequest(String? id, Iterable<DataSnapshot> map) {
    var userID = '';
    var patient = '';
    DateTime? dateTime;
    String? latitude;
    String? longitude;
    for (var snapshot in map) {
      switch (snapshot.key) {
        case 'userID':
          userID = snapshot.value.toString();
          break;
        case 'patient':
          patient = snapshot.value.toString();
          break;
        case 'dateTime':
          dateTime = DateTime.parse(snapshot.value.toString());
          break;
        case 'latitude':
          latitude = snapshot.value.toString();
          break;
        case 'longitude':
          longitude = snapshot.value.toString();
          break;
        default:
          break;
      }
    }
    return Request(
      userID: userID,
      patient: patient,
      dateTime: dateTime,
      latitude: latitude,
      longitude: longitude,
    );
  }
}

class Requests_Repository {
  final DatabaseReference requestsRef =
      FirebaseDatabase.instance.ref().child('requests');
  User? user = FirebaseAuth.instance.currentUser;

  /// create an order request for another user which means you need to specify the location of that user
  /// '''dart
  /// String requestId = await createRequest('31.2', '31.2');
  /// '''
  Future<String> createRequest(String latitude, String longitude) async {
    //create request instance
    Request request = Request(
        userID: user!.uid,
        patient: "unknown",
        latitude: latitude,
        longitude: longitude);
    // push request into database
    try {
      return await _pushRequest(request);
    } catch (e) {
      throw Exception("failed to push request");
    }
  }

  /// create an order for the current user which means you need to specify the location of the current user
  /// '''dart
  /// await createRequestAndNotifyCaregivers();
  /// '''
  Future<void> createRequestAndNotifyCaregivers() async {
    //create request instance
    Position? position = await getCurrentPosition();
    // get current user location
    if (position != null) {
      Request x = Request(
          userID: user!.uid,
          patient: user!.displayName.toString(),
          latitude: position.latitude.toString(),
          longitude: position.longitude.toString());
      // push request into database
      try {
        String requestId = await _pushRequest(x);
        _notifyCaregivers(requestId);
      } catch (e) {
        throw Exception("failed to push request");
      }
    } else {
      throw Exception("failed to get current location");
    }
  }

  Future<void> _notifyCaregivers(String requestID) async {
    //send notification to caregivers of the logged-in user if there is a network connection
    if (await isNetworkAvailable()) {
      List<Relation> careGivers =
          await RelationRepository().getRelationsForCurrentUser();
      List<String> phoneNums = [];
      careGivers.forEach((element) async {
        Notification x = Notification(
            title: "${user?.displayName} needs your help!",
            body: "press to see the user location",
            notificationType: "request",
            notificationTypeId: requestID,
            targetUserID: element.userId2);
        NotificationRepository().pushNotificationToUser(x);
        UserProfile m = await UserRepository().getUserById(element.userId2);
        phoneNums.add(m.phoneNumber);
      });
      // TODO: check user settings and send sms if enabled
      sendSMSToCaregivers(phoneNums);
    }
    //send SMS in case no internet
    else {
      // TODO: retrive data from shared preferences and send SMS
    }
  }

  Future<String> _pushRequest(Request request) async {
    //push request into database
    final newRequest = requestsRef.push();
    await newRequest.set(Request.fromRequestToMap(request));
    return newRequest.key.toString();
  }

  Future<void> deleteRequest(String requestID) async {
    await requestsRef.child(requestID).remove();
  }

  Future<void> sendSMSToCaregivers(List<String> recipients) async {
    SMSService.sendSmsMessage(
        recipients: recipients, message: "Request Received");
  }

  Future<void> sendSMSToServer(Request request) async {
    // format request and specify location in format of json string
    String encodedRequest = json.encode(Request.fromRequestToMap(request));
    //send SMS in case no internet
    await SMSService.sendSmsMessage(
        recipients: [dotenv.env['SERVER_PHONE_NUMBER']!],
        message: encodedRequest);
  }
}
