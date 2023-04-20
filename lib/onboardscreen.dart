import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gradproject/sos.dart';
import 'package:gradproject/splashscreen.dart';
import 'package:gradproject/style.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                    "Welcome to \n Code Blue",
                    style: TextStyle(fontSize: 32, color: Mycolors.textcolor),
                  )),
                  Stack(
                    children: [SvgPicture.asset("assets/images/ambulance.svg")],
                  ),
                  Text("SOS BUTTON",
                      style:
                          TextStyle(fontSize: 15, color: Mycolors.textcolor)),
                  Center(
                    child: Text(
                        "With just one press, our SOS button will \n automatically order an ambulance to your current\n location, send your medical card to the \n paramedic, and notify your caregivers via SMS \n and app notification of your critical situation and \n location.",
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
                    "Welcome to \n Code Blue",
                    style: TextStyle(fontSize: 32, color: Mycolors.textcolor),
                  )),
                  Stack(
                    children: [
                      SvgPicture.asset("assets/images/Medicalcard.svg")
                    ],
                  ),
                  Text("MEDICAL CARD",
                      style:
                          TextStyle(fontSize: 15, color: Mycolors.textcolor)),
                  Center(
                    child: Text(
                        "By filling out your medical information in our\n application, paramedics will be able to quickly\n access vital information about your health,\n allergies, medications, and more, potentially \n saving your life.",
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
                    "Welcome to \n Code Blue",
                    style: TextStyle(fontSize: 32, color: Mycolors.textcolor),
                  )),
                  Stack(
                    children: [SvgPicture.asset("assets/images/SMS.svg")],
                  ),
                  Text("EMERGENCY SMS BACKUP",
                      style:
                          TextStyle(fontSize: 15, color: Mycolors.textcolor)),
                  Center(
                    child: Text(
                        "By enabling this feature, our app will send an SMS \n to the server and all the designated caregivers \n notifying them of the emergency if there is no \n internet connection available.",
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
                    "Welcome to \n Code Blue",
                    style: TextStyle(fontSize: 32, color: Mycolors.textcolor),
                  )),
                  Stack(
                    children: [SvgPicture.asset("assets/images/Frame.svg")],
                  ),
                  Text("CHATBOT",
                      style:
                          TextStyle(fontSize: 15, color: Mycolors.textcolor)),
                  Center(
                    child: Text(
                        " Our chatbot is available in both English and \n Arabic languages, providing first aid information \n and assistance to help you handle a medical \n emergency.",
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
                    "Welcome to \n Code Blue",
                    style: TextStyle(fontSize: 32, color: Mycolors.textcolor),
                  )),
                  Stack(
                    children: [SvgPicture.asset("assets/images/last.svg")],
                  ),
                  Text("NEARBY HOSPITALS & AMBULANCE ORDERING",
                      style:
                          TextStyle(fontSize: 15, color: Mycolors.textcolor)),
                  Center(
                    child: Text(
                        "You can view nearby hospitals and order an \n ambulance from the location you choose, giving \n you quick and convenient access to medical help.",
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
                        child: Text("SKIP",
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
                                "Next",
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
