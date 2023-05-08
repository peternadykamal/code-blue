import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradproject/main.dart';
import 'package:gradproject/sos.dart';
import 'package:gradproject/splashscreen.dart';
import 'package:gradproject/style.dart';
import 'package:gradproject/translations/locale_keys.g.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gradproject/translations/locale_keys.g.dart';

class onBoardScreen extends StatefulWidget {
  const onBoardScreen({key});

  @override
  State<onBoardScreen> createState() => _onBoardScreenState();
}

class _onBoardScreenState extends State<onBoardScreen> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(bottom: 80),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/backgroundtwo.png"),
                  fit: BoxFit.fill)),
          child: PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() => isLastPage = index == 4);
            },
            children: [
              Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                      child: Text(
                    LocaleKeys.welcomecode.tr() +
                        '\n' +
                        LocaleKeys.codeblue.tr(),
                    style: TextStyle(fontSize: 32, color: Mycolors.textcolor),
                  )),
                  Stack(
                    children: [SvgPicture.asset("assets/images/ambulance.svg")],
                  ),
                  Text(langCode == 'en' ? "SOS BUTTON" : "زر SOS",
                      style:
                          TextStyle(fontSize: 15, color: Mycolors.textcolor)),
                  Center(
                    child: Text(
                        langCode == 'en'
                            ? "With just one press, our SOS button will \n automatically order an ambulance to your current\n location, send your medical card to the \n paramedic, and notify your caregivers via SMS \n and app notification of your critical situation and \n location."
                            : "بضغطة واحدة فقط ، سيطلب زر SOS الخاص بنا \n تلقائيًا سيارة إسعاف إلى موقعك الحالي \n ، ويرسل بطاقتك الطبية إلى \n المسعف ، ويخطر مقدمي الرعاية عبر الرسائل القصيرة \n وإشعار التطبيق بوضعك الحرج و \n موقع.",
                        style: TextStyle(
                          color: Mycolors.textcolor,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center),
                  )
                ],
              )),
              Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                      child: Text(
                    LocaleKeys.welcomecode.tr() +
                        '\n' +
                        LocaleKeys.codeblue.tr(),
                    style: TextStyle(fontSize: 32, color: Mycolors.textcolor),
                  )),
                  Stack(
                    children: [
                      SvgPicture.asset("assets/images/Medicalcard.svg")
                    ],
                  ),
                  Text(langCode == 'en' ? "MEDICAL CARD" : "البطاقة الطبية",
                      style:
                          TextStyle(fontSize: 15, color: Mycolors.textcolor)),
                  Center(
                    child: Text(
                        langCode == 'en'
                            ? "By filling out your medical information in our\n application, paramedics will be able to quickly\n access vital information about your health,\n allergies, medications, and more, potentially \n saving your life."
                            : "بملء معلوماتك الطبية في تطبيقنا \n ، سيتمكن المسعفون من الوصول بسرعة \n إلى المعلومات الحيوية حول صحتك ، \n الحساسية ، والأدوية ، والمزيد ، مما قد ينقذ حياتك.",
                        style: TextStyle(
                            color: Mycolors.textcolor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  )
                ],
              )),
              Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                      child: Text(
                    LocaleKeys.welcomecode.tr() +
                        '\n' +
                        LocaleKeys.codeblue.tr(),
                    style: TextStyle(fontSize: 32, color: Mycolors.textcolor),
                  )),
                  Stack(
                    children: [SvgPicture.asset("assets/images/SMS.svg")],
                  ),
                  Text(
                      langCode == 'en'
                          ? "EMERGENCY SMS BACKUP"
                          : "النسخ الاحتياطي للرسائل القصيرة في حالات الطوارئ",
                      style:
                          TextStyle(fontSize: 15, color: Mycolors.textcolor)),
                  Center(
                    child: Text(
                        langCode == 'en'
                            ? "By enabling this feature, our app will send an SMS \n to the server and all the designated caregivers \n notifying them of the emergency if there is no \n internet connection available."
                            : "من خلال تمكين هذه الميزة ، سيرسل تطبيقنا رسالة نصية قصيرة \n إلى الخادم وجميع مقدمي الرعاية المعينين \n لإعلامهم بحالة الطوارئ في حالة عدم توفر \n اتصال بالإنترنت.",
                        style: TextStyle(
                            color: Mycolors.textcolor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  )
                ],
              )),
              Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                      child: Text(
                    LocaleKeys.welcomecode.tr() +
                        '\n' +
                        LocaleKeys.codeblue.tr(),
                    style: TextStyle(fontSize: 32, color: Mycolors.textcolor),
                  )),
                  Stack(
                    children: [SvgPicture.asset("assets/images/Frame.svg")],
                  ),
                  Text(langCode == 'en' ? "CHATBOT" : "الي الدردشة",
                      style:
                          TextStyle(fontSize: 15, color: Mycolors.textcolor)),
                  Center(
                    child: Text(
                        langCode == 'en'
                            ? " Our chatbot is available in both English and \n Arabic languages, providing first aid information \n and assistance to help you handle a medical \n emergency."
                            : "يتوفر برنامج الدردشة الآلي الخاص بنا باللغتين الإنجليزية و \n العربية ، ويقدم معلومات الإسعافات الأولية \n والمساعدة في التعامل مع \n حالة طبية طارئة.",
                        style: TextStyle(
                            color: Mycolors.textcolor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  )
                ],
              )),
              Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                      child: Text(
                    LocaleKeys.welcomecode.tr() +
                        '\n' +
                        LocaleKeys.codeblue.tr(),
                    style: TextStyle(fontSize: 32, color: Mycolors.textcolor),
                  )),
                  Stack(
                    children: [SvgPicture.asset("assets/images/last.svg")],
                  ),
                  Text(
                      langCode == 'en'
                          ? "NEARBY HOSPITALS & AMBULANCE ORDERING"
                          : "المستشفيات القريبة وطلبات الإسعاف",
                      style:
                          TextStyle(fontSize: 15, color: Mycolors.textcolor)),
                  Center(
                    child: Text(
                        langCode == 'en'
                            ? "You can view nearby hospitals and order an \n ambulance from the location you choose, giving \n you quick and convenient access to medical help."
                            : "يمكنك عرض المستشفيات القريبة وطلب \n سيارة إسعاف من الموقع الذي تختاره ، مما يمنحك \n وصولاً سريعًا ومريحًا إلى المساعدة الطبية.",
                        style: TextStyle(
                            color: Mycolors.textcolor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  )
                ],
              )),
            ],
          ),
        ),
        bottomSheet: Container(
          color: Mycolors.splashback,
          height: 80,
          child: Column(
            children: [
              Center(
                child: SmoothPageIndicator(
                  onDotClicked: (index) => controller.animateToPage(index,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn),
                  controller: controller,
                  count: 5,
                  effect: WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      activeDotColor: Mycolors.buttonsos,
                      dotColor: Mycolors.fillingcolor),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () => controller.jumpToPage(4),
                        child: Text(langCode == 'en' ? "SKIP" : "تخطي",
                            style: TextStyle(
                                color: Mycolors.notpressed, fontSize: 16))),
                    InkWell(
                        onTap: () async {
                          // final Prefs = await SharedPreferences.getInstance();
                          // Prefs.setBool('showHome', true);
                          isLastPage
                              ? Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => splashScreen()))
                              : controller.nextPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInOut);
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 20),
                          height: 34,
                          width: 96,
                          decoration: BoxDecoration(
                              color: Mycolors.buttonsos,
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                langCode == 'en' ? "Next" : "القادم",
                                style: TextStyle(
                                    color: Mycolors.fillingcolor, fontSize: 16),
                              ),
                              Icon(Icons.chevron_right_sharp,
                                  color: Mycolors.fillingcolor)
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
