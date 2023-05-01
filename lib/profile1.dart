import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradproject/auth.dart';
import 'package:gradproject/button.dart';
import 'package:gradproject/button2.dart';
import 'package:gradproject/buttonselevated.dart';
import 'package:gradproject/loadingcontainer.dart';
import 'package:gradproject/medicalCard.dart';
import 'package:gradproject/repository/user_repository.dart';
import 'package:gradproject/searchpage.dart';
import 'package:gradproject/sos.dart';
import 'package:gradproject/style.dart';
import 'package:gradproject/utils/has_network.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paginated_search_bar/paginated_search_bar_state_property.dart';
import 'package:path/path.dart';
import 'package:gradproject/services/auth_service.dart';
import 'package:paginated_search_bar/paginated_search_bar.dart';

class Profileone extends StatefulWidget {
  const Profileone({super.key});

  @override
  State<Profileone> createState() => _ProfileoneState();
}

class _ProfileoneState extends State<Profileone> {
  bool selectMedical = true;
  bool selectCare = false;
  UserProfile? user;
  User? firebaseUser;
  Image? userProfileImage;

  @override
  void initState() {
    super.initState();
    getuser();
  }

  void getuser() async {
    final fetchedUser = await UserRepository().getUserProfile();
    final fetchedFirebaseUser = FirebaseAuth.instance.currentUser;
    final fetchedUserProfileImage = await UserRepository().getProfileImage();
    setState(() {
      user = fetchedUser;
      firebaseUser = fetchedFirebaseUser;
      userProfileImage = fetchedUserProfileImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null || firebaseUser == null || userProfileImage == null) {
      return loadingContainer();
    } else {
      return WillPopScope(
        onWillPop: () async {
          // Do something here
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => sosPage()));
          return false;
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Mycolors.splashback,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => sosPage()));
                          },
                          child: Icon(
                            Icons.close,
                            size: 30,
                            color: Mycolors.textcolor,
                          ),
                        ),
                        PopupMenuButton(
                          iconSize: 28,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: "logout",
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Log Out",
                                    style: TextStyle(
                                      color: Mycolors.buttoncolor,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Icon(
                                    Icons.logout,
                                    color: Mycolors.buttoncolor,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: "settings",
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Settings",
                                    style: TextStyle(
                                      color: Mycolors.buttoncolor,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Icon(
                                    Icons.settings,
                                    color: Mycolors.buttoncolor,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) async {
                            if (value == "logout") {
                              await AuthService().signOut();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => authPage(),
                                ),
                              );
                            } else if (value == "settings") {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => profile2(),
                                ),
                              );
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 30),
                            height: 25,
                            width: 25,
                            child: SvgPicture.asset(
                                "assets/images/Vector (2).svg"),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: userProfileImage!.image,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              XFile? image = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              UserRepository().changeProfile(image!);
                            },
                            child: CircleAvatar(
                              radius: 15,
                              child: Icon(Icons.camera_alt_outlined,
                                  color: Mycolors.textcolor),
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(user!.email,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Mycolors.textcolor,
                                  fontWeight: FontWeight.bold)),
                          Padding(
                            padding: const EdgeInsets.only(right: 50),
                            child: Text(firebaseUser?.phoneNumber ?? "",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Mycolors.notpressed,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 300,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Mycolors.buttoncolor),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: InkWell(
                                onTap: () {
                                  setState(() {
                                    selectMedical = true;
                                    selectCare = false;
                                  });
                                },
                                child: elevButtons(
                                    text: "Medical Card",
                                    elevcolor: selectMedical
                                        ? Colors.white
                                        : Mycolors.buttoncolor,
                                    bordercolor: selectMedical
                                        ? Mycolors.textcolor
                                        : Mycolors.buttoncolor)),
                          ),
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              setState(() {
                                selectMedical = false;
                                selectCare = true;
                              });
                            },
                            child: elevButtons(
                                text: "Care Givers",
                                elevcolor: selectCare
                                    ? Colors.white
                                    : Mycolors.buttoncolor,
                                bordercolor: selectCare
                                    ? Mycolors.textcolor
                                    : Mycolors.buttoncolor),
                          )),
                        ]),
                  ),
                  SizedBox(height: 20),
                  (() {
                    if (selectMedical) {
                      if (user!.age == null &&
                          user!.allergies == null &&
                          user!.medicalCondition == null &&
                          user!.medications == null &&
                          user!.remarks == null &&
                          user!.gender == null &&
                          user!.birthDate == null &&
                          user!.bloodType == null &&
                          user!.rhBloodType == null) {
                        return Card(
                          elevation: 100,
                          shape: CircleBorder(),
                          borderOnForeground: false,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            height: 401,
                            width: 320,
                            child: Column(
                              children: [
                                SizedBox(height: 20),
                                Button2(
                                    textButton: "Fill Out Your Medical Info",
                                    onTap: () async {
                                      if (await isNetworkAvailable != true) {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    profile2()));
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "No Internet connection",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor:
                                                Mycolors.splashback,
                                            textColor: Mycolors.textcolor,
                                            fontSize: 16.0);
                                      }
                                    },
                                    width: 220,
                                    height: 60),
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                      "In case of an emergency, paramedics will be able to quickly access vital information about your health, allergies, medications, and more, potentially saving your life.",
                                      style: TextStyle(
                                          color: Mycolors.notpressed,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                      return Card(
                        elevation: 100,
                        shape: CircleBorder(),
                        borderOnForeground: false,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          height: 420,
                          width: 300,
                          child: SingleChildScrollView(
                            child: Column(children: [
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 110.0),
                                    child: Center(
                                      child: Text(
                                          user!.gender == null
                                              ? ""
                                              : user!.gender?.name == "male"
                                                  ? "M( " +
                                                      user!.age.toString() +
                                                      " y/o)"
                                                  : "F(" +
                                                      user!.age.toString() +
                                                      " y/o)",
                                          style: TextStyle(
                                              color: Mycolors.textcolor,
                                              fontSize: 20)),
                                    ),
                                  ),
                                  Stack(
                                    children: [
                                      SvgPicture.asset(
                                          "assets/images/Group 26.svg")
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                                "assets/images/Vector (5).svg"),
                                            Text("Height",
                                                style: TextStyle(
                                                    color: Mycolors.textcolor,
                                                    fontSize: 15))
                                          ],
                                        ),
                                        Text(
                                            user!.height == null
                                                ? ""
                                                : user!.height.toString() +
                                                    " Cm",
                                            style: TextStyle(
                                                color: Mycolors.textcolor,
                                                fontSize: 24))
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                                "assets/images/Vector (3).svg"),
                                            Text("weight",
                                                style: TextStyle(
                                                    color: Mycolors.textcolor,
                                                    fontSize: 15))
                                          ],
                                        ),
                                        Text(
                                            user!.weight == null
                                                ? ""
                                                : user!.weight.toString() +
                                                    " Kg",
                                            style: TextStyle(
                                                color: Mycolors.textcolor,
                                                fontSize: 24))
                                      ],
                                    ),
                                  ]),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 70.0, left: 40),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                              "assets/images/Vector (4).svg"),
                                          Text("Blood Type",
                                              style: TextStyle(
                                                  color: Mycolors.textcolor,
                                                  fontSize: 20))
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                              user!.bloodType == null
                                                  ? ""
                                                  : user!.bloodType!.name,
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  color: Mycolors.textcolor)),
                                          Text(
                                              user!.rhBloodType == null
                                                  ? ""
                                                  : user!.rhBloodType!.name ==
                                                          "positive"
                                                      ? "+"
                                                      : "-",
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  color: Mycolors.textcolor)),
                                        ],
                                      ),
                                    ]),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Divider(
                                  color: Mycolors.numpad,
                                  thickness: 1.0,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 210.0),
                                child: Text("Health".toUpperCase(),
                                    style: TextStyle(
                                        color: Mycolors.notpressed,
                                        fontSize: 11)),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(right: 125.0),
                                child: Text("MEDICAL CONDITIONS",
                                    style: TextStyle(
                                        color: Mycolors.buttonsos,
                                        fontSize: 12)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 23.0),
                                child: Text(
                                    textAlign: TextAlign.start,
                                    user!.medicalCondition == null
                                        ? ""
                                        : user!.medicalCondition.toString(),
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Mycolors.textcolor,
                                        fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(right: 175.0),
                                child: Text("MEDICATIONS",
                                    style: TextStyle(
                                        color: Mycolors.buttonsos,
                                        fontSize: 12)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 23.0),
                                child: Text(
                                    textAlign: TextAlign.start,
                                    user!.medications == null
                                        ? ""
                                        : user!.medications.toString(),
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Mycolors.textcolor,
                                        fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(right: 190.0),
                                child: Text("ALLERGIES",
                                    style: TextStyle(
                                        color: Mycolors.buttonsos,
                                        fontSize: 12)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 23.0),
                                child: Text(
                                    textAlign: TextAlign.start,
                                    user!.allergies == null
                                        ? ""
                                        : user!.allergies.toString(),
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Mycolors.textcolor,
                                        fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(right: 197.0),
                                child: Text("REMARKS",
                                    style: TextStyle(
                                        color: Mycolors.buttonsos,
                                        fontSize: 12)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 23.0),
                                child: Text(
                                    textAlign: TextAlign.start,
                                    user!.remarks == null
                                        ? ""
                                        : user!.remarks.toString(),
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Mycolors.textcolor,
                                        fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(height: 20)
                            ]),
                          ),
                        ),
                      );
                    }

                    return Card(
                      elevation: 100,
                      shape: CircleBorder(),
                      borderOnForeground: false,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        height: 401,
                        width: 320,
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => searchPage()));
                                },
                                child: Container(
                                    width: 300,
                                    height: 33,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Icon(Icons.search),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 140.0),
                                          child: Text("Search for a caregiver",
                                              style: TextStyle(
                                                  color: Mycolors.notpressed,
                                                  fontSize: 12)),
                                        ),
                                      ],
                                    )),
                              ),
                            ),
                            SizedBox(height: 10),
                            // SizedBox(height: 30),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                  "We understand that emergencies can be overwhelming, which is why it's important to have a support system in place. By adding a loved one or caregiver to be notified in case of an emergency.",
                                  style: TextStyle(
                                      color: Mycolors.notpressed,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                            ),
                            // SizedBox(height: 170),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 11.0, bottom: 11.0),
                              child: RichText(
                                text: TextSpan(
                                  text: "Here's how it works:  ",
                                  style: TextStyle(
                                    color: Mycolors.textcolor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          "if you ever press the SOS button in our application, we'll send an SMS and app notification to your caregivers. This will let them know that you need help and provide them with your location information.",
                                      style: TextStyle(
                                        color: Mycolors.notpressed,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }())
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
