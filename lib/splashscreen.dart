import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradproject/main.dart';
import 'package:gradproject/repository/relation_repository.dart';
import 'package:gradproject/repository/user_repository.dart';
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
    if (FirebaseAuth.instance.currentUser == null) {
      Timer(
          Duration(seconds: 2),
          () async => {
                await context.setLocale(Locale(langCode)),
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => authPage()))
              });
    } else {
      jumpToSOS();
    }
  }

  void jumpToSOS() async {
    final fetchedUser = await UserRepository().getUserProfile();
    final fetchedRelations = await UserRepository().getCareGivers();

    Timer(
        Duration(seconds: 2),
        () async => {
              await context.setLocale(Locale(langCode)),
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => sosPage(
                            user: fetchedUser,
                            relations: fetchedRelations,
                          )))
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
            Center(
                child:
                    SvgPicture.asset("assets/images/logo-updated-only 1.svg")),
            SizedBox(height: 130),
            LoadingAnimationWidget.threeArchedCircle(
                color: Colors.white, size: 40),
          ],
        ),
      ),
    );
  }
}
