import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradproject/repository/user_repository.dart';
import 'package:gradproject/repository/relations_repository.dart';
import 'package:gradproject/repository/notification_repository.dart';

class Request {
  String? requestID;
  String userID;
  String patient;
  DateTime? time;
  Request(
      {required this.userID,
      required this.patient,
      required this.time,
      this.requestID});

  static Map<String, dynamic> fromRequestToMap(Request data) {
    return {
      'userID': data.userID,
      'patient': data.patient,
      'time': data.time.toString(),
      'requestID': data.requestID,
    };
  }

  static Request fromMapToRequest(String? id, Iterable<DataSnapshot> map) {
    var userID = '';
    var patient = '';
    var requestID = '';
    DateTime? time;
    for (var snapshot in map) {
      switch (snapshot.key) {
        case 'userID':
          userID = snapshot.value.toString();
          break;
        case 'patient':
          patient = snapshot.value.toString();
          break;
        case 'time':
          time = DateTime.parse(snapshot.value.toString());
          break;
      }
    }
    return Request(
      userID: userID,
      patient: patient,
      time: time,
      requestID: id,
    );
  }
}

class Requests_Repository {
  final DatabaseReference requestsRef =
      FirebaseDatabase.instance.ref().child('requests');
  User? user = FirebaseAuth.instance.currentUser;

  createRequest() async {
    //create request
    UserProfile userp = await UserRepository().getUserProfile();
    print(userp.username);
    Request x = Request(
        userID: user!.uid, patient: userp.username, time: DateTime.now());
    pushRequest(x);
  }

  requestConfirmation() async {
    //send notification to caregivers of the logged-in user
    List<Relation> y = await RelationRepository().getRelationsForCurrentUser();
    y.forEach((element) {
      Notification x = Notification(
          title: "Request Confirmation",
          body: "Successfully received request!",
          targetUserID: element.userId2);
      NotificationRepository().pushNotificationToUser(x);
    });
  }

  Future<String> pushRequest(Request request) async {
    //push request into database
    final newRequest = requestsRef.push();
    await newRequest.set(Request.fromRequestToMap(request));
    return newRequest.key.toString();
  }

  Future<void> deleteRequest(String requestID) async {
    await requestsRef.child(requestID).remove();
  }

  smsConfirmation() async {
    // send SMSs to caregivers // SMSService.sendSmsMessage( recipients:
    //['+201222906083'], message: "message")
  }

  smsNoInternet() async {
    //send SMS in case no internet //SMSService.sendSmsMessage( recipients:
    //['+201222906083'], message: "message")
  }
}
