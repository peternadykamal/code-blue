import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gradproject/splashscreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gradproject/translations/codegen_loader.g.dart';
import 'package:gradproject/services/auth_service.dart';
import 'dart:ui'; //for mobile
import 'testing/test_notification.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gradproject/services/notification_service.dart';

Locale deviceLocale = window.locale;
String langCode = deviceLocale.languageCode;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  // the data will be cashed in the device each time you retrieve data from the database
  // so when the device is offline it will still be able to retrieve the data
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  // initialize the auth service
  AuthService().initialize();
  // initialize the notification service
  NotificationService.initialize();
  // load dotenv file
  await dotenv.load(fileName: ".env");
  // disable logging in easy localization package
  EasyLocalization.logger.enableBuildModes = [];
  runApp(EasyLocalization(
      path: "assets/translations",
      supportedLocales: [Locale("ar"), Locale("en")],
      assetLoader: CodegenLoader(),
      fallbackLocale: Locale("en"),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // this function is used for testing methods and features only
    if (kDebugMode) {
      testThis().then((value) => {print("test done")});
    }

    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: splashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
