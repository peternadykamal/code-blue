import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gradproject/loadingcontainer.dart';
import 'package:gradproject/main.dart';
import 'package:gradproject/profile1.dart';
import 'package:gradproject/repository/user_repository.dart';
import 'package:gradproject/repository/user_repository.dart';
import 'package:gradproject/style.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:gradproject/utils/has_network.dart';
import 'package:gradproject/utils/no_inernet_toast.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:horizontal_picker/horizontal_picker.dart';
import 'package:age_calculator/age_calculator.dart';

class profile2 extends StatefulWidget {
  final UserProfile user;
  final Map<String, dynamic> relations;
  const profile2({required this.user, required this.relations, super.key});

  @override
  State<profile2> createState() => _profile2State();
}

class _profile2State extends State<profile2> {
  DateTime? date;
  TextEditingController _date = TextEditingController();
  final _medicalCond = TextEditingController();
  final _medications = TextEditingController();
  final _allergies = TextEditingController();
  final _remarks = TextEditingController();
  double? height;
  double? weight;
  Gender? g;
  BloodType? B;
  RhBloodType? RH;
  int? duration;

  static String enumToString(value) {
    return value.toString().split('.').last;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Mycolors.fillingcolor,
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              width: double.infinity,
              height: 49,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                color: Mycolors.splashback,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Profileone(
                                        user: widget.user,
                                        relations: widget.relations,
                                      )));
                        },
                        child: Padding(
                          padding: langCode == 'en'
                              ? const EdgeInsets.only(left: 8.0)
                              : const EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.arrow_back,
                              size: 30, color: Mycolors.textcolor),
                        )),
                    Text(langCode == 'en' ? "Medical Card" : "البطاقة الطبية",
                        style:
                            TextStyle(color: Mycolors.textcolor, fontSize: 20)),
                    GestureDetector(
                        onTap: () async {
                          if (await isNetworkAvailable() == false) {
                            noInternetToast();
                            return;
                          }
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return loadingContainer(); // Show loading screen
                            },
                          );
                          UserProfile currentUser =
                              await UserRepository().getUserProfile();
                          String email = currentUser.email;
                          String username = currentUser.username;
                          await UserRepository().updateUserProfile(
                            UserProfile(
                              email: email,
                              username: username,
                              phoneNumber: FirebaseAuth
                                  .instance.currentUser!.phoneNumber!,
                              gender: g,
                              bloodType: B,
                              rhBloodType: RH,
                              height: height,
                              weight: weight,
                              allergies: _allergies.text == ""
                                  ? null
                                  : _allergies.text,
                              medicalCondition: _medicalCond.text == ""
                                  ? null
                                  : _medicalCond.text,
                              medications: _medications.text == ""
                                  ? null
                                  : _medications.text,
                              remarks:
                                  _remarks.text == "" ? null : _remarks.text,
                              birthDate: date,
                            ),
                          );
                          Navigator.of(context, rootNavigator: true).pop();
                          final fetchedUser =
                              await UserRepository().getUserProfile();
                          print(fetchedUser.age);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Profileone(
                                        user: fetchedUser,
                                        relations: widget.relations,
                                      )));
                        },
                        child: Padding(
                          padding: langCode == 'en'
                              ? const EdgeInsets.only(right: 8.0)
                              : const EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.done,
                              size: 30, color: Mycolors.textcolor),
                        ))
                  ]),
            ),
            SizedBox(height: 10),
            Padding(
              padding: langCode == 'en'
                  ? const EdgeInsets.only(right: 280.0)
                  : const EdgeInsets.only(left: 270.0),
              child: Text(
                langCode == 'en'
                    ? "Basic info".toUpperCase()
                    : "معلومات أساسية",
                style: TextStyle(color: Mycolors.buttonsos, fontSize: 12),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: langCode == 'en'
                      ? const EdgeInsets.only(right: 97.0)
                      : const EdgeInsets.only(left: 97.0),
                  child: Text(langCode == 'en' ? "Gender" : "الجنس",
                      style:
                          TextStyle(color: Mycolors.textcolor, fontSize: 15)),
                ),
                CustomRadioButton(
                  height: 29,
                  enableShape: true,
                  radius: 20,
                  buttonTextStyle: ButtonTextStyle(
                    selectedColor: Mycolors.fillingcolor,
                    unSelectedColor: Mycolors.textcolor,
                    textStyle: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  unSelectedColor: Mycolors.numpad,
                  buttonLables: [
                    langCode == 'en' ? "Male" : "ذكر",
                    langCode == 'en' ? "Female" : "انثى"
                  ],
                  buttonValues: [Gender.male, Gender.female],
                  radioButtonValue: (values) {
                    g = values;
                  },
                  selectedBorderColor: Mycolors.buttoncolor,
                  unSelectedBorderColor: Mycolors.numpad,
                  spacing: 0,
                  horizontal: false,
                  enableButtonWrap: false,
                  width: 75,
                  absoluteZeroSpacing: false,
                  selectedColor: Mycolors.buttoncolor,
                  padding: 10,
                )
              ],
            ),
            SizedBox(height: 30),
            Container(
              width: 280,
              height: 33,
              child: TextField(
                controller: _date,
                keyboardType: TextInputType.none,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                      color: Mycolors.notpressed,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                  contentPadding: EdgeInsets.only(top: 7),
                  hintText: langCode == 'en' ? 'dd/mm/yyyy' : "يوم-شهر-سنة",
                  filled: true,
                  fillColor: Mycolors.fillingcolor,
                  isDense: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.cake,
                      color: Mycolors.notpressed,
                      size: 20,
                    ), // icon is 48px widget.
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          new BorderSide(color: Mycolors.notpressed, width: 3)),
                ),
                onTap: () async {
                  date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1930),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      _date.text = DateFormat('dd-MM-yyyy').format(date!);
                    });
                  }
                },
              ),
            ),
            SizedBox(height: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: langCode == 'en'
                      ? const EdgeInsets.only(right: 290.0)
                      : const EdgeInsets.only(left: 290.0),
                  child: Text(langCode == 'en' ? "Height " : "الطول",
                      style:
                          TextStyle(color: Mycolors.textcolor, fontSize: 15)),
                ),
                SizedBox(height: 3),
                Container(
                  width: 280,
                  child: HorizontalPicker(
                    backgroundColor: Mycolors.fillingcolor,
                    cursorColor: Mycolors.textcolor,
                    activeItemTextColor: Mycolors.buttoncolor,
                    initialPosition: InitialPosition.center,
                    suffix: "cm",
                    minValue: 120,
                    maxValue: 210,
                    divisions: 420,
                    height: 70,
                    onChanged: (value) {
                      setState(() {
                        height = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: langCode == 'en'
                      ? const EdgeInsets.only(right: 290.0)
                      : const EdgeInsets.only(left: 290.0),
                  child: Text(langCode == 'en' ? "Weight " : "الوزن",
                      style:
                          TextStyle(color: Mycolors.textcolor, fontSize: 15)),
                ),
                SizedBox(height: 3),
                Container(
                  width: 280,
                  child: HorizontalPicker(
                    backgroundColor: Mycolors.fillingcolor,
                    cursorColor: Mycolors.textcolor,
                    activeItemTextColor: Mycolors.buttoncolor,
                    initialPosition: InitialPosition.center,
                    minValue: 50,
                    maxValue: 180,
                    divisions: 260,
                    suffix: "kg",
                    height: 70,
                    onChanged: (value) {
                      setState(() {
                        weight = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(langCode == 'en' ? "Blood Type" : "الفصيلة",
                    style: TextStyle(color: Mycolors.textcolor, fontSize: 15)),
                CustomRadioButton(
                  height: 29,
                  enableShape: true,
                  radius: 20,
                  buttonTextStyle: ButtonTextStyle(
                    selectedColor: Mycolors.fillingcolor,
                    unSelectedColor: Mycolors.textcolor,
                    textStyle: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  unSelectedColor: Mycolors.numpad,
                  buttonLables: [
                    "A",
                    "B",
                    "O",
                    "AB",
                  ],
                  buttonValues: [
                    BloodType.a,
                    BloodType.b,
                    BloodType.o,
                    BloodType.ab
                  ],
                  radioButtonValue: (values) {
                    B = values;
                  },
                  selectedBorderColor: Mycolors.xbutton,
                  unSelectedBorderColor: Mycolors.numpad,
                  spacing: 0,
                  horizontal: false,
                  enableButtonWrap: false,
                  width: langCode == 'en' ? 55 : 57,
                  absoluteZeroSpacing: false,
                  selectedColor: Mycolors.xbutton,
                  padding: 10,
                )
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: langCode == 'en'
                      ? const EdgeInsets.only(right: 27.0)
                      : const EdgeInsets.only(left: 27.0),
                  child: Text(
                      langCode == 'en' ? "RH Blood Type" : "نوع الفصيلة",
                      style:
                          TextStyle(color: Mycolors.textcolor, fontSize: 15)),
                ),
                CustomRadioButton(
                  height: 29,
                  enableShape: true,
                  radius: 20,
                  buttonTextStyle: ButtonTextStyle(
                    selectedColor: Mycolors.fillingcolor,
                    unSelectedColor: Mycolors.textcolor,
                    textStyle: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  unSelectedColor: Mycolors.numpad,
                  buttonLables: [
                    langCode == 'en' ? "Positive" : "موجب",
                    langCode == 'en' ? "Negative" : "سالب",
                  ],
                  buttonValues: [RhBloodType.positive, RhBloodType.negative],
                  radioButtonValue: (values) {
                    RH = values;
                  },
                  selectedBorderColor: Mycolors.xbutton,
                  unSelectedBorderColor: Mycolors.numpad,
                  spacing: 0,
                  horizontal: false,
                  enableButtonWrap: false,
                  width: 75,
                  absoluteZeroSpacing: false,
                  selectedColor: Mycolors.xbutton,
                  padding: 10,
                )
              ],
            ),
            SizedBox(height: 30),
            Divider(
              color: Mycolors.numpad,
              height: 25,
              thickness: 2,
              indent: 5,
              endIndent: 5,
            ),
            SizedBox(height: 20),
            Padding(
              padding: langCode == 'en'
                  ? const EdgeInsets.only(right: 290.0)
                  : const EdgeInsets.only(left: 290.0),
              child: Text(
                langCode == 'en' ? "Health".toUpperCase() : "الصحة",
                style: TextStyle(color: Mycolors.buttonsos, fontSize: 12),
              ),
            ),
            SizedBox(height: 30),
            Container(
              width: 320,
              child: TextFormField(
                  maxLines: 3,
                  controller: _medicalCond,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                        color: Mycolors.notpressed,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                    hintText:
                        langCode == 'en' ? "MEDICAL CONDITION" : "حالتك الطبية",
                    filled: true,
                    fillColor: Mycolors.fillingcolor,
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: new BorderSide(
                            color: Mycolors.notpressed, width: 3)),
                  )),
            ),
            SizedBox(height: 30),
            Container(
              width: 320,
              child: TextFormField(
                  maxLines: 3,
                  controller: _medications,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                        color: Mycolors.notpressed,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                    hintText: langCode == 'en' ? "MEDICATIONS" : "الأدوية",
                    filled: true,
                    fillColor: Mycolors.fillingcolor,
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: new BorderSide(
                            color: Mycolors.notpressed, width: 3)),
                  )),
            ),
            SizedBox(height: 30),
            Container(
              width: 320,
              child: TextFormField(
                  maxLines: 3,
                  controller: _allergies,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                        color: Mycolors.notpressed,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                    hintText: langCode == 'en' ? "ALLERGIES" : "الحساسية",
                    filled: true,
                    fillColor: Mycolors.fillingcolor,
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: new BorderSide(
                            color: Mycolors.notpressed, width: 3)),
                  )),
            ),
            SizedBox(height: 30),
            Container(
              width: 320,
              child: TextFormField(
                  maxLines: 3,
                  controller: _remarks,
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                        color: Mycolors.notpressed,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                    hintText: langCode == 'en' ? "REMARKS" : "ملاحظات",
                    filled: true,
                    fillColor: Mycolors.fillingcolor,
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: new BorderSide(
                            color: Mycolors.notpressed, width: 3)),
                  )),
            ),
            SizedBox(height: 30)
          ]),
        ),
      ),
    );
  }
}
