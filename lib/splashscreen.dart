import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gradproject/main.dart';
import 'package:gradproject/sos.dart';
import 'package:gradproject/style.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'auth.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () async => {
              await context.setLocale(Locale(langCode)),
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FirebaseAuth.instance.currentUser == null
                              ? authPage()
                              : sosPage()))
            });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Mycolors.splashback,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Image.asset("assets/images/codeblueslogo1.png")),
            SizedBox(height: 180),
            LoadingAnimationWidget.threeArchedCircle(
                color: Colors.white, size: 40),
          ],
        ),
      ),
    );
  }
}
