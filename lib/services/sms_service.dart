import 'package:flutter_sms/flutter_sms.dart';
import 'package:permission_handler/permission_handler.dart';

class SMSService {
  static Future<bool> _requestSMSPermission() async {
    var status = await Permission.sms.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> sendSmsMessage(
      {required List<String> recipients, required String message}) async {
    bool result = false;
    if (await _requestSMSPermission()) {
      try {
        // open the sms message sending app
        // result = await sendSMS(message: message, recipients: recipients)
        //     .then((value) => true);
        // send directly without opening the app
        // result = await sendSMS(message: message, recipients: recipients, sendDirect: true).then((value) => true);
      } catch (e) {
        print(e.toString());
        result = false;
      }
    }
    return result;
  }
}
