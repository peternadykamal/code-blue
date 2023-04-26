import 'package:gradproject/repository//user_repository.dart';
import 'package:gradproject/repository/notification_repository.dart';
import 'package:gradproject/repository/request_repository.dart';
import 'package:gradproject/services/auth_service.dart';
import 'package:gradproject/services/sms_service.dart';
import 'package:gradproject/utils/has_network.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gradproject/repository/relation_repository.dart';
import 'package:firebase_database/firebase_database.dart';

Future<void> testThis() async {
  Requests_Repository()
      .sendSMSToServer(Request(patient: 'patient', userID: 'userid'));
  // SMSService.sendSmsMessage(recipients: ['+201204290582'], message: "message");
}
