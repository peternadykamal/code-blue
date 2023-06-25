import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
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
import 'package:gradproject/main.dart';
import 'package:gradproject/medicalCard.dart';
import 'package:gradproject/repository/relation_repository.dart';
import 'package:gradproject/repository/user_repository.dart';
import 'package:gradproject/searchpage.dart';
import 'package:gradproject/settings.dart';
import 'package:gradproject/sos.dart';
import 'package:gradproject/style.dart';
import 'package:gradproject/translations/locale_keys.g.dart';
import 'package:gradproject/utils/has_network.dart';
import 'package:gradproject/utils/no_inernet_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paginated_search_bar/paginated_search_bar_state_property.dart';
import 'package:path/path.dart';
import 'package:gradproject/services/auth_service.dart';
import 'package:paginated_search_bar/paginated_search_bar.dart';

class Profileone extends StatefulWidget {
  final UserProfile user;
  Map<String, dynamic> relations;

  Profileone({required this.user, required this.relations, super.key});

  @override
  State<Profileone> createState() => _ProfileoneState();
}

class _ProfileoneState extends State<Profileone> {
  bool selectMedical = true;
  bool selectCare = false;
  UserProfile? user;
  User? firebaseUser;
  Image? userProfileImage;
  List<UserProfile> _careGivers = [];
  List<String> _relations = [];
  bool hasCareGivers = false;

  @override
  void initState() {
    super.initState();
    _getuser();
    _getCareGivers();
  }

  Future<void> _getCareGivers() async {
    try {
      final Map<String, dynamic> result = widget.relations;
      setState(() {
        _careGivers = result['careGivers'];
        _relations = result['relations'];
        hasCareGivers = _relations.isNotEmpty;
      });
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _deleteRelation(int index) async {
    try {
      final relationId = _relations[index];
      await RelationRepository().deleteRelation(relationId);
      widget.relations = await UserRepository().getCareGivers();
      setState(() {
        _careGivers.removeAt(index);
        _relations.removeAt(index);
      });
    } catch (e) {
      // Handle error
    }
  }

  void _getuser() async {
    final fetchedUser = widget.user;
    final fetchedFirebaseUser = FirebaseAuth.instance.currentUser;
    final fetchedUserProfileImage = widget.user.profileImage;
    setState(() {
      user = fetchedUser;
      firebaseUser = fetchedFirebaseUser;
      userProfileImage = fetchedUserProfileImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (firebaseUser == null || userProfileImage == null) {
      return loadingContainer();
    } else {
      return WillPopScope(
        onWillPop: () async {
          // Do something here
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => sosPage(
                        user: widget.user,
                        relations: widget.relations,
                      )));
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
                                    builder: (context) => sosPage(
                                          user: widget.user,
                                          relations: widget.relations,
                                        )));
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
                                    LocaleKeys.logout.tr(),
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
                                    LocaleKeys.settings.tr(),
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
                                    builder: (context) => settingsPage(),
                                  ));
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
                              if (await isNetworkAvailable() == false) {
                                noInternetToast();
                                return;
                              }
                              XFile? image = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              if (image != null) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return loadingContainer(); // Show loading screen
                                  },
                                );
                                await UserRepository().changeProfile(image);
                                Image fetchedUserProfileImage =
                                    await UserRepository().getProfileImage();
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                setState(() {
                                  userProfileImage = fetchedUserProfileImage;
                                  widget.user.profileImage =
                                      fetchedUserProfileImage;
                                });
                              }
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
                                    text: LocaleKeys.medicalcard.tr(),
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
                                text: LocaleKeys.caregivers.tr(),
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
                                    textButton: LocaleKeys.fillout.tr(),
                                    onTap: () async {
                                      if (await isNetworkAvailable() == false) {
                                        noInternetToast();
                                        return;
                                      }
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => profile2(
                                                    user: widget.user,
                                                    relations: widget.relations,
                                                  )));
                                    },
                                    width: 220,
                                    height: 60),
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(LocaleKeys.emergencycase.tr(),
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
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        height: 420,
                        width: 300,
                        child: SingleChildScrollView(
                          child: Column(children: [
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: langCode == 'en'
                                      ? const EdgeInsets.only(left: 110.0)
                                      : const EdgeInsets.only(right: 100.0),
                                  child: Center(
                                    child: Text(
                                        user!.gender == null
                                            ? ""
                                            : user!.gender?.name == "male"
                                                ? langCode == 'en'
                                                    ? "M( " +
                                                        user!.age.toString() +
                                                        " y/o)"
                                                    : "(ذكر " +
                                                        user!.age.toString() +
                                                        " سنة )"
                                                : langCode == 'en'
                                                    ? "F( " +
                                                        user!.age.toString() +
                                                        " y/o)"
                                                    : "(انثى " +
                                                        user!.age.toString() +
                                                        " سنة )",
                                        style: TextStyle(
                                            color: Mycolors.textcolor,
                                            fontSize: 20)),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (await isNetworkAvailable() == false) {
                                      noInternetToast();
                                      return;
                                    }
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => (profile2(
                                                  user: widget.user,
                                                  relations: widget.relations,
                                                ))));
                                  },
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Mycolors.fillingcolor
                                              .withOpacity(0.2),
                                          spreadRadius: 1,
                                          blurRadius: 1,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Center(
                                        child: CircleAvatar(
                                            backgroundColor:
                                                Mycolors.splashback,
                                            radius: 18,
                                            child: SvgPicture.asset(
                                                "assets/images/updateMedicalCard.svg")),
                                      ),
                                    ),
                                  ),
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
                                          Text(
                                              langCode == 'en'
                                                  ? "Height"
                                                  : "الطول",
                                              style: TextStyle(
                                                  color: Mycolors.textcolor,
                                                  fontSize: 15))
                                        ],
                                      ),
                                      Text(
                                          user!.height == null
                                              ? ""
                                              : langCode == 'en'
                                                  ? user!.height.toString() +
                                                      " Cm"
                                                  : user!.height.toString() +
                                                      " سم",
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
                                          Text(
                                              langCode == 'en'
                                                  ? "weight"
                                                  : "الوزن",
                                              style: TextStyle(
                                                  color: Mycolors.textcolor,
                                                  fontSize: 15))
                                        ],
                                      ),
                                      Text(
                                          user!.weight == null
                                              ? ""
                                              : langCode == 'en'
                                                  ? user!.weight.toString() +
                                                      " Kg"
                                                  : user!.weight.toString() +
                                                      " كج",
                                          style: TextStyle(
                                              color: Mycolors.textcolor,
                                              fontSize: 24))
                                    ],
                                  ),
                                ]),
                            SizedBox(height: 10),
                            Padding(
                              padding: langCode == 'en'
                                  ? const EdgeInsets.only(right: 70.0, left: 40)
                                  : const EdgeInsets.only(
                                      right: 40.0, left: 70),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                            "assets/images/Vector (4).svg"),
                                        Text(
                                            langCode == 'en'
                                                ? "Blood Type"
                                                : "فصيلة الدم",
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Divider(
                                color: Mycolors.numpad,
                                thickness: 1.0,
                              ),
                            ),
                            Padding(
                              padding: langCode == 'en'
                                  ? const EdgeInsets.only(right: 210.0)
                                  : const EdgeInsets.only(left: 210.0),
                              child: Text(
                                  langCode == 'en'
                                      ? "Health".toUpperCase()
                                      : "الصحة",
                                  style: TextStyle(
                                      color: Mycolors.notpressed,
                                      fontSize: 11)),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: langCode == 'en'
                                  ? const EdgeInsets.only(right: 125.0)
                                  : const EdgeInsets.only(left: 180.0),
                              child: Text(
                                  langCode == 'en'
                                      ? "MEDICAL CONDITIONS"
                                      : "حالات طبية",
                                  style: TextStyle(
                                      color: Mycolors.buttonsos, fontSize: 12)),
                            ),
                            Padding(
                              padding: langCode == 'en'
                                  ? const EdgeInsets.only(left: 23.0)
                                  : const EdgeInsets.only(right: 23.0),
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
                              padding: langCode == 'en'
                                  ? const EdgeInsets.only(right: 175.0)
                                  : const EdgeInsets.only(left: 200.0),
                              child: Text(
                                  langCode == 'en' ? "MEDICATIONS" : "الأدوية",
                                  style: TextStyle(
                                      color: Mycolors.buttonsos, fontSize: 12)),
                            ),
                            Padding(
                              padding: langCode == 'en'
                                  ? const EdgeInsets.only(left: 23.0)
                                  : const EdgeInsets.only(right: 23.0),
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
                              padding: langCode == 'en'
                                  ? const EdgeInsets.only(right: 190.0)
                                  : const EdgeInsets.only(left: 190.0),
                              child: Text(
                                  langCode == 'en' ? "ALLERGIES" : "الحساسية",
                                  style: TextStyle(
                                      color: Mycolors.buttonsos, fontSize: 12)),
                            ),
                            Padding(
                              padding: langCode == 'en'
                                  ? const EdgeInsets.only(left: 23.0)
                                  : const EdgeInsets.only(right: 23.0),
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
                              padding: langCode == 'en'
                                  ? const EdgeInsets.only(right: 197.0)
                                  : const EdgeInsets.only(left: 197.0),
                              child: Text(
                                  langCode == 'en' ? "REMARKS" : "ملاحظات",
                                  style: TextStyle(
                                      color: Mycolors.buttonsos, fontSize: 12)),
                            ),
                            Padding(
                              padding: langCode == 'en'
                                  ? const EdgeInsets.only(left: 23.0)
                                  : const EdgeInsets.only(right: 23.0),
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
                      );
                    }

                    return hasCareGivers == false
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            height: 420,
                            width: 300,
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    margin: EdgeInsets.only(
                                        left: 10, right: 10, bottom: 5),
                                    child: Container(
                                        width: 300,
                                        height: 40,
                                        child: InkWell(
                                            onTap: () async {
                                              if (await isNetworkAvailable() ==
                                                  false) {
                                                noInternetToast();
                                                return;
                                              }
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          searchPage()));
                                            },
                                            child: langCode == 'en'
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: .0),
                                                        child:
                                                            Icon(Icons.search),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 130.0),
                                                        child: Text(
                                                            LocaleKeys
                                                                .searchcaregiver
                                                                .tr(),
                                                            style: TextStyle(
                                                                color: Mycolors
                                                                    .notpressed,
                                                                fontSize: 12)),
                                                      ),
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 130.0),
                                                        child: Text(
                                                            LocaleKeys
                                                                .searchcaregiver
                                                                .tr(),
                                                            style: TextStyle(
                                                                color: Mycolors
                                                                    .notpressed,
                                                                fontSize: 12)),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0),
                                                        child:
                                                            Icon(Icons.search),
                                                      ),
                                                    ],
                                                  )))),
                                SizedBox(height: 10),
                                // SizedBox(height: 30),
                                Padding(
                                  padding: langCode == 'en'
                                      ? EdgeInsets.only(left: 8.0)
                                      : EdgeInsets.only(right: 8.0),
                                  child: Text(LocaleKeys.overwhelming.tr(),
                                      style: TextStyle(
                                          color: Mycolors.notpressed,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                ),
                                // SizedBox(height: 170),
                                Spacer(),
                                Padding(
                                  padding: langCode == 'en'
                                      ? const EdgeInsets.only(
                                          left: 11.0, bottom: 11.0)
                                      : const EdgeInsets.only(
                                          right: 11.0, bottom: 11.0),
                                  child: RichText(
                                    text: TextSpan(
                                      text: LocaleKeys.herehow.tr(),
                                      style: TextStyle(
                                        color: Mycolors.textcolor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: LocaleKeys.wesendsms.tr(),
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
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            height: 420,
                            width: 300,
                            child: SingleChildScrollView(
                              child: Column(children: [
                                SizedBox(height: 10),
                                Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    margin: EdgeInsets.only(
                                        left: 10, right: 10, bottom: 5),
                                    child: Container(
                                        width: 300,
                                        height: 40,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        searchPage()));
                                          },
                                          child: langCode == 'en'
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: Icon(Icons.search),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 120.0),
                                                      child: Text(
                                                          LocaleKeys
                                                              .searchcaregiver
                                                              .tr(),
                                                          style: TextStyle(
                                                              color: Mycolors
                                                                  .notpressed,
                                                              fontSize: 12)),
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 130.0),
                                                      child: Text(
                                                          LocaleKeys
                                                              .searchcaregiver
                                                              .tr(),
                                                          style: TextStyle(
                                                              color: Mycolors
                                                                  .notpressed,
                                                              fontSize: 12)),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
                                                      child: Icon(Icons.search),
                                                    ),
                                                  ],
                                                ),
                                        ))),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _careGivers.length,
                                  itemBuilder: (context, index) {
                                    final careGiver = _careGivers[index];
                                    return Container(
                                      padding: EdgeInsets.only(left: 10),
                                      margin: EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          bottom: 4,
                                          top: 4),
                                      decoration: BoxDecoration(
                                          color: Mycolors.numpad,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      width: 200,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CircleAvatar(
                                            radius: 17,
                                            backgroundImage:
                                                careGiver.profileImage!.image,
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 40.0, left: 10),
                                              child: Text(
                                                careGiver.email,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Mycolors.textcolor,
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                              icon: Icon(Icons.remove_circle),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      content: Text(
                                                          "Are you sure you want to remove this caregiver?"),
                                                      actions: [
                                                        TextButton(
                                                          child: Text("Cancel",
                                                              style: TextStyle(
                                                                  color: Mycolors
                                                                      .textcolor)),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        ElevatedButton(
                                                          style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStatePropertyAll(
                                                                      Mycolors
                                                                          .buttoncolor)),
                                                          child: Text("Remove"),
                                                          onPressed: () {
                                                            _deleteRelation(
                                                                index);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }),
                                        ],
                                      ),
                                    );
                                    ;
                                  },
                                )
                              ]),
                            ));
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
