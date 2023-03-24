// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> ar = {
  "Signup": "الاشتراك",
  "Login": "الدخول",
  "welcome": "مرحبا،",
  "glad": "سعيد برؤيتك",
  "email": "ايميل",
  "forgetpass": "نسيت كلمة المرور؟",
  "password": "كلمة السر",
  "confirmpass": "تأكيد كلمة السر",
  "createacc": "إنشاء حساب ،",
  "getstarted": "لتبدأ الآن!",
  "phoneverification": "تحقق من هاتفك",
  "yourec": "سوف تتلقى",
  "fourcode": "رمز مكون من اربعة أرقام",
  "toverify": "للتحقق.",
  "phonenumber": "رقم التليفون",
  "verifycodesentto": "تم إرسال الرمز إلى <رقم الهاتف>",
  "didnotreceive": "لم تتلق رمز؟",
  "Requestagain": "اطلب مرة أخرى",
  "Verifyandcreate": "التحقق وانشاء حساب"
};
static const Map<String,dynamic> en = {
  "Signup": "Sign Up",
  "Login": "Login",
  "welcome": "Welcome ,",
  "glad": "Glad To See You",
  "email": "Email",
  "forgetpass": "forget password?",
  "password": "password",
  "confirmpass": "confirm password",
  "createacc": "Create Account ,",
  "getstarted": "To Get Started Now!",
  "phoneverification": "Verify your phone",
  "yourec": "you'll receive",
  "fourcode": "a 4 digit code",
  "toverify": "to verify.",
  "phonenumber": "Phone number",
  "verifycodesentto": "Code is sent to <phone number>",
  "didnotreceive": "Didn't receive code ?",
  "Requestagain": "Request again",
  "Verifyandcreate": "VERIFY AND CREATE ACCOUNT"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"ar": ar, "en": en};
}
