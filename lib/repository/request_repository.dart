import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gradproject/repository/user_repository.dart';
import 'package:gradproject/repository/relation_repository.dart';
import 'package:gradproject/repository/notification_repository.dart';
import 'package:gradproject/utils/has_network.dart';
import 'package:gradproject/utils/user_geolocation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/sms_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum RequestStatus { pending, completed, canceled }

class Request {
  String userID;
  String patient;
  String? latitude;
  String? longitude;
  DateTime? dateTime;
  RequestStatus? status;

  Request(
      {required this.userID,
      required this.patient,
      this.dateTime,
      this.latitude,
      this.longitude,
      this.status = RequestStatus.pending}) {
    dateTime ??= DateTime.now();
  }

  static Map<String, dynamic> fromRequestToMap(Request data) {
    Map<String, dynamic> updateData = {
      'userID': data.userID,
      'patient': data.patient,
      'dataTime': data.dateTime.toString(),
      'status': data.status?.index,
    };
    if (data.latitude != null) {
      updateData['latitude'] = data.latitude;
    }
    if (data.longitude != null) {
      updateData['longitude'] = data.longitude;
    }
    return updateData;
  }

  static Request fromMapToRequest(Iterable<DataSnapshot> map) {
    var userID = '';
    var patient = '';
    var status = RequestStatus.pending;
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
        case 'status':
          status = RequestStatus.values[snapshot.value as int];
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
      status: status,
    );
  }
}

class RequestRepository {
  final DatabaseReference requestsRef =
      FirebaseDatabase.instance.ref().child('requests');
  User? user = FirebaseAuth.instance.currentUser;

  /// create an order request for another user which means you need to specify the location of that user
  /// '''dart
  /// String requestId = await createRequest('31.2', '31.2');
  /// '''
  Future<String> createRequest(
      String latitude, String longitude, bool sendSMS) async {
    //create request instance
    Request request = Request(
        userID: user!.uid,
        patient: "unknown",
        latitude: latitude,
        longitude: longitude);
    // push request into database
    if (await isNetworkAvailable()) {
      return await _pushRequest(request);
    } else {
      if (sendSMS) {
        sendSMSToServer(request);
        throw Exception("sending request via sms because there is no network");
      }
      throw Exception("no network");
    }
  }

  /// create an order for the current user which means you need to specify the location of the current user
  /// '''dart
  /// await createRequestAndNotifyCaregivers();
  /// '''
  Future<void> createRequestAndNotifyCaregivers(bool sendSMS) async {
    //create request instance
    Position? position = await getCurrentPosition();
    // get current user location
    if (position != null) {
      Request request = Request(
          userID: user!.uid,
          patient: user!.displayName.toString(),
          latitude: position.latitude.toString(),
          longitude: position.longitude.toString());
      // push request into database
      try {
        String requestId = await _pushRequest(request);
        _notifyCaregivers(requestId, request, sendSMS);
      } catch (e) {
        throw Exception("failed to push request");
      }
    } else {
      throw Exception("failed to get current location");
    }
  }

  Future<void> _notifyCaregivers(
      String requestID, Request request, bool sendSMS) async {
    //send notification to caregivers of the logged-in user if there is a network connection
    if (await isNetworkAvailable()) {
      List<Relation> careGivers = (await RelationRepository()
          .getRelationsForCurrentUser())['relations'];
      List<String> phoneNums = [];
      careGivers.forEach((element) async {
        Notification notification = Notification(
            title: "${user?.displayName} needs your help!",
            body: "press to see the user location",
            notificationType: "request",
            notificationTypeId: requestID,
            targetUserID: element.userId2);
        NotificationRepository().pushNotificationToUser(notification);
        UserProfile userProf =
            await UserRepository().getUserById(element.userId2);
        phoneNums.add(userProf.phoneNumber);
      });
      if (sendSMS) {
        sendSMSToCaregivers(phoneNums);
      }
    }
    //send SMS in case no internet
    else {
      if (sendSMS) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        List<String> phoneNums =
            prefs.getStringList('caregiversPhoneNumbers') ?? [];
        if (phoneNums.isNotEmpty) sendSMSToCaregivers(phoneNums);
        sendSMSToServer(request);
      }
    }
  }

  Future<String> _pushRequest(Request request) async {
    //push request into database
    final newRequest = requestsRef.push();
    await newRequest.set(Request.fromRequestToMap(request));
    return newRequest.key.toString();
  }

  Future<void> deleteRequest(String requestID) async {
    try {
      await requestsRef.child(requestID).remove();
    } catch (e) {
      throw Exception("failed to delete request");
    }
  }

  // get request by id
  Future<Request> getRequestById(String requestID) async {
    final snapshot = await requestsRef.child(requestID).get();
    if (snapshot.exists) {
      return Request.fromMapToRequest(snapshot.children);
    } else {
      throw Exception("request not found");
    }
  }

  Future<void> sendSMSToCaregivers(List<String> recipients) async {
    await SMSService.sendSmsMessage(
        recipients: recipients,
        message:
            "${user!.displayName} needs your help!, please try to contact them as soon as possible");
  }

  // change request status
  Future<void> changeRequestStatus(
      String requestID, RequestStatus requestStatus) async {
    await requestsRef.child(requestID).update({'status': requestStatus.index});
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
