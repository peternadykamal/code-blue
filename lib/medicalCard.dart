import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gradproject/style.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:horizontal_picker/horizontal_picker.dart';

class profile2 extends StatefulWidget {
  const profile2({super.key});

  @override
  State<profile2> createState() => _profile2State();
}

class _profile2State extends State<profile2> {
  var _listGenderText = ["Male", "Female"];
  var _listBloodType = ["Positive", "Negative"];
  var _tabSelectedIndexSelected = 0;
  var _bloodSelectedIndexSelected = 0;
  TextEditingController _date = TextEditingController();
  TextEditingController medicalCond = TextEditingController();
  double height = 0;
  double width = 0;

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
                    Icon(Icons.arrow_back, size: 30, color: Mycolors.textcolor),
                    Text("Medical Card",
                        style:
                            TextStyle(color: Mycolors.textcolor, fontSize: 20)),
                    Icon(Icons.done, size: 30, color: Mycolors.textcolor)
                  ]),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 260.0),
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
                  padding: const EdgeInsets.only(right: 57.0),
                  child: Text("Gender",
                      style:
                          TextStyle(color: Mycolors.textcolor, fontSize: 15)),
                ),
                FlutterToggleTab(
                  width: 50,
                  height: 24,
                  borderRadius: 15,
                  selectedBackgroundColors: [Mycolors.splashback],
                  unSelectedBackgroundColors: [Mycolors.buttoncolor],
                  selectedTextStyle: TextStyle(
                      color: Mycolors.textcolor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  unSelectedTextStyle: TextStyle(
                      color: Mycolors.fillingcolor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  labels: _listGenderText,
                  selectedIndex: _tabSelectedIndexSelected,
                  selectedLabelIndex: (index) {
                    setState(() {
                      _tabSelectedIndexSelected = index;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: 300,
              child: TextField(
                controller: _date,
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
            SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 270.0),
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
                  minValue: 0,
                  maxValue: 220,
                  divisions: 20,
                  height: 70,
                  onChanged: (value) {
                    setState(() {
                      height = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 270.0),
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
                  minValue: 0,
                  maxValue: 220,
                  divisions: 20,
                  height: 70,
                  onChanged: (value) {
                    setState(() {
                      width = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Blood Type",
                    style: TextStyle(color: Mycolors.textcolor, fontSize: 15)),
                CustomCheckBoxGroup(
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
                  buttonValuesList: ["A", "B", "O", "AB"],
                  checkBoxButtonValues: (values) {
                    print(values);
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
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 27.0),
                  child: Text("RH Blood Type",
                      style:
                          TextStyle(color: Mycolors.textcolor, fontSize: 15)),
                ),
                FlutterToggleTab(
                  width: 50,
                  height: 24,
                  borderRadius: 15,
                  selectedBackgroundColors: [Mycolors.xbutton],
                  unSelectedBackgroundColors: [Mycolors.numpad],
                  selectedTextStyle: TextStyle(
                      color: Mycolors.fillingcolor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  unSelectedTextStyle: TextStyle(
                      color: Mycolors.textcolor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  labels: _listBloodType,
                  selectedIndex: _bloodSelectedIndexSelected,
                  selectedLabelIndex: (index) {
                    setState(() {
                      _bloodSelectedIndexSelected = index;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(
              color: Mycolors.numpad,
              height: 25,
              thickness: 2,
              indent: 5,
              endIndent: 5,
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 280.0),
              child: Text(
                "Health".toUpperCase(),
                style: TextStyle(color: Mycolors.buttonsos, fontSize: 12),
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 300,
              child: TextFormField(
                  maxLines: 3,
                  controller: medicalCond,
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
            SizedBox(height: 20),
            Container(
              width: 300,
              child: TextFormField(
                  maxLines: 3,
                  controller: medicalCond,
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
            SizedBox(height: 20),
            Container(
              width: 300,
              child: TextFormField(
                  maxLines: 3,
                  controller: medicalCond,
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
            SizedBox(height: 20),
            Container(
              width: 300,
              child: TextFormField(
                  maxLines: 3,
                  controller: medicalCond,
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
            )
          ]),
        ),
      ),
    );
  }
}
