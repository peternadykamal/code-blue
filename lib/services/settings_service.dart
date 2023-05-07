import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  // Send SMS getters and setters
  static Future<bool> getSendSms() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('sendSMS') ?? false;
  }

  static Future<void> setSendSms(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('sendSMS', value);
  }

  // language getters and setters
  static Future<String> getLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('language') ?? 'en';
  }

  static Future<void> setLanguage(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('language', value);
  }

  // get all phoneNumbers stored on the phone
  static Future<List<String>> getAllPhoneNumbers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> phoneNums =
        prefs.getStringList('caregiversPhoneNumbers') ?? [];
    // add nonCaregiversPhoneNumbers
    prefs.getStringList('nonCaregiversPhoneNumbers')?.forEach((element) {
      if (!phoneNums.contains(element)) phoneNums.add(element);
    });
    return phoneNums;
  }

  // get nonCaregiversPhoneNumbers only
  static Future<List<String>> getNonCaregiversPhoneNumbers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('nonCaregiversPhoneNumbers') ?? [];
  }

  // add to nonCaregiversPhoneNumbers
  static Future<void> addNonCaregiversPhoneNumbers(String phoneNumber) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> phoneNums =
        prefs.getStringList('nonCaregiversPhoneNumbers') ?? [];
    if (!phoneNums.contains(phoneNumber)) {
      phoneNums.add(phoneNumber);
      await prefs.setStringList('nonCaregiversPhoneNumbers', phoneNums);
    }
  }

  // remove from nonCaregiversPhoneNumbers
  static Future<void> removeNonCaregiversPhoneNumbers(
      String phoneNumber) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> phoneNums =
        prefs.getStringList('nonCaregiversPhoneNumbers') ?? [];
    if (phoneNums.contains(phoneNumber)) {
      phoneNums.remove(phoneNumber);
      await prefs.setStringList('nonCaregiversPhoneNumbers', phoneNums);
    }
  }
}
