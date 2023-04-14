import 'package:gradproject/services/sms_service.dart';

Future<void> testThis() async {
  print(SMSService.sendSmsMessage(
      recipients: ['+201222906083'], message: "message"));
}
