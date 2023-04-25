import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gradproject/profile1.dart';
import 'package:gradproject/repository/user_repository.dart';
import 'package:gradproject/repository/user_repository.dart';
import 'package:gradproject/style.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:horizontal_picker/horizontal_picker.dart';
import 'package:age_calculator/age_calculator.dart';

class profile2 extends StatefulWidget {
  const profile2({super.key});

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
                                  builder: (context) => profileone()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.arrow_back,
                              size: 30, color: Mycolors.textcolor),
                        )),
                    Text("Medical Card",
                        style:
                            TextStyle(color: Mycolors.textcolor, fontSize: 20)),
                    GestureDetector(
                        onTap: () async {
                          UserProfile currentUser =
                              await UserRepository().getUserProfile();
                          String email = currentUser.email;
                          String username = currentUser.username;
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => profileone()));

                          UserRepository().updateUserProfile(
                            UserProfile(
                              email: email,
                              username: username,
                              gender: g,
                              bloodType: B,
                              rhBloodType: RH,
                              height: height,
                              weight: weight,
                              allergies: _allergies.text,
                              medicalCondition: _medicalCond.text,
                              medications: _medications.text,
                              remarks: _remarks.text,
                              birthDate: date,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.done,
                              size: 30, color: Mycolors.textcolor),
                        ))
                  ]),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 280.0),
              child: Text(
                "Basic info".toUpperCase(),
                style: TextStyle(color: Mycolors.buttonsos, fontSize: 12),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 97.0),
                  child: Text("Gender",
                      style:
                          TextStyle(color: Mycolors.textcolor, fontSize: 15)),
                ),
                CustomRadioButton(
                  height: 29,
                  enableShape: true,
                  radius: 20,
                  buttonTextStyle: ButtonTextStyle(
                    selectedColor: Mycolors.textcolor,
                    unSelectedColor: Mycolors.fillingcolor,
                    textStyle: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  unSelectedColor: Mycolors.buttoncolor,
                  buttonLables: ["Male", "Female"],
                  buttonValues: [Gender.male, Gender.female],
                  radioButtonValue: (values) {
                    g = values;
                    print(g);
                  },
                  selectedBorderColor: Mycolors.splashback,
                  unSelectedBorderColor: Mycolors.buttoncolor,
                  spacing: 0,
                  horizontal: false,
                  enableButtonWrap: false,
                  width: 75,
                  absoluteZeroSpacing: false,
                  selectedColor: Mycolors.splashback,
                  padding: 10,
                )
              ],
            ),
            SizedBox(height: 30),
            Container(
              width: 300,
              child: TextField(
                controller: _date,
                keyboardType: TextInputType.none,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                      color: Mycolors.notpressed,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                  hintText: 'dd/mm/yyyy',
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
                  DateTime? pickeddate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1930),
                    lastDate: DateTime.now(),
                  );
                  if (pickeddate != null) {
                    setState(() {
                      _date.text = DateFormat('dd-MM-yyyy').format(pickeddate);
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
                  padding: const EdgeInsets.only(right: 290.0),
                  child: Text("Height ",
                      style:
                          TextStyle(color: Mycolors.textcolor, fontSize: 15)),
                ),
                SizedBox(height: 3),
                HorizontalPicker(
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
              ],
            ),
            SizedBox(height: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 290.0),
                  child: Text("Weight ",
                      style:
                          TextStyle(color: Mycolors.textcolor, fontSize: 15)),
                ),
                SizedBox(height: 3),
                HorizontalPicker(
                  backgroundColor: Mycolors.fillingcolor,
                  cursorColor: Mycolors.textcolor,
                  activeItemTextColor: Mycolors.buttoncolor,
                  initialPosition: InitialPosition.center,
                  minValue: 50,
                  maxValue: 362,
                  divisions: 624,
                  suffix: "kg",
                  height: 70,
                  onChanged: (value) {
                    setState(() {
                      weight = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Blood Type",
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
                  width: 55,
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
                  padding: const EdgeInsets.only(right: 27.0),
                  child: Text("RH Blood Type",
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
                    "Positive",
                    "Negative",
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
              padding: const EdgeInsets.only(right: 290.0),
              child: Text(
                "Health".toUpperCase(),
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
                    hintText: "medical conditions".toUpperCase(),
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
                    hintText: "Medications".toUpperCase(),
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
                    hintText: "Allergies".toUpperCase(),
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
                    hintText: "Remarks".toUpperCase(),
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
