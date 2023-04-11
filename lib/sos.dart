import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradproject/profile1.dart';
import 'package:gradproject/style.dart';
import 'package:gradproject/translations/locale_keys.g.dart';

class sosPage extends StatefulWidget {
  const sosPage({super.key});

  @override
  State<sosPage> createState() => _sosPageState();
}

class _sosPageState extends State<sosPage> {
  bool notification = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(LocaleKeys.welcomeback.tr(),
                      style: TextStyle(
                          color: Mycolors.notpressed,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  Text(LocaleKeys.username.tr(),
                      style: TextStyle(
                          color: Mycolors.textcolor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                ],
              ),
              SizedBox(width: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SvgPicture.asset(notification == true
                      ? ("assets/images/notification.svg")
                      : ("assets/images/no notification.svg")),
                  SizedBox(width: 10),
                  CircleAvatar(
                    radius: 25,
                    child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => profileone())));
                        },
                        child: SvgPicture.asset(
                            "assets/images/default profile picture.svg")),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 80),
          Center(
              child: Text(LocaleKeys.clickbuttonbelow.tr(),
                  style: TextStyle(
                      color: Mycolors.notpressed,
                      fontSize: 24,
                      fontWeight: FontWeight.normal))),
          Text(LocaleKeys.duringemerg.tr(),
              style: TextStyle(
                  color: Mycolors.notpressed,
                  fontSize: 24,
                  fontWeight: FontWeight.normal)),
          SizedBox(height: 40),
          RawMaterialButton(
            onPressed: () {},
            elevation: 0.0,
            highlightElevation: 3.0,
            fillColor: Color(0xFFBCDEFA),
            highlightColor: Color(0xFF9AC5F5),
            padding: EdgeInsets.all(15.0),
            shape: CircleBorder(),
            child: Center(
              child: ClipOval(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 125,
                      backgroundColor: Color(0xFF9AC5F5),
                    ),
                    CircleAvatar(
                      radius: 110,
                      backgroundColor: Color(0xFF5695EC),
                    ),
                    CircleAvatar(
                      radius: 95,
                      backgroundColor: Color(0xFF1264E2),
                    ),
                    SvgPicture.asset("assets/images/sos icon.svg")
                  ],
                ),
              ),
            ),
          ),
          Spacer(),
          Container(
            width: double.infinity,
            height: 66,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: Mycolors.splashback,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      SizedBox(height: 4),
                      Stack(
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 30),
                              height: 35,
                              width: 35,
                              child: SvgPicture.asset(
                                  "assets/images/carbon_chat-bot.svg"))
                        ],
                      ),
                      SizedBox(height: 3),
                      Container(
                          margin: EdgeInsets.only(left: 30),
                          child: Text("Chatbot",
                              style: TextStyle(
                                  color: Mycolors.notpressed,
                                  fontWeight: FontWeight.w500))),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      SizedBox(height: 4),
                      Stack(
                        children: [
                          Container(
                              height: 35,
                              width: 35,
                              child: SvgPicture.asset(
                                  "assets/images/Vector (1).svg"))
                        ],
                      ),
                      SizedBox(height: 3),
                      Text("Home",
                          style: TextStyle(
                              color: Mycolors.textcolor,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      SizedBox(height: 4),
                      Stack(
                        children: [
                          Container(
                              margin: EdgeInsets.only(right: 30),
                              height: 35,
                              width: 35,
                              child:
                                  SvgPicture.asset("assets/images/Vector.svg"))
                        ],
                      ),
                      SizedBox(height: 3),
                      Container(
                          margin: EdgeInsets.only(right: 30),
                          child: Text("Maps",
                              style: TextStyle(
                                  color: Mycolors.notpressed,
                                  fontWeight: FontWeight.w500))),
                    ],
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
