import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gradproject/splashscreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:gradproject/translations/codegen_loader.g.dart';
import 'dart:ui'; //for mobile


Locale deviceLocale = window.locale;
String langCode = deviceLocale.languageCode;

Future <void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  runApp(EasyLocalization(
    path: "assets/translations",
     supportedLocales: [
      Locale("ar" ),
      Locale("en")
     ],
     assetLoader: CodegenLoader(),
     fallbackLocale: Locale("en"),
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
