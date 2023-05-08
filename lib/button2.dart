import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:gradproject/style.dart';

class Button2 extends StatelessWidget {
  final String textButton;
  final Function()? onTap;
  final double width;
  final double height;
  const Button2(
      {required this.textButton,
      required this.onTap,
      required this.width,
      required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: ElevatedButton(
          onPressed: onTap,
          child: Text(textButton, style: TextStyle(fontSize: 11)),
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor:
                  MaterialStateProperty.all<Color>(Mycolors.buttonsos),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Mycolors.buttonsos))))),
    );
    //  return Card( elevation: 3, borderOnForeground: false, shadowColor:
    //   Mycolors.buttoncolor, child: Container( height: 47, width: 240,
    //   decoration: BoxDecoration(color: Mycolors.buttoncolor, borderRadius:
    //   BorderRadius.circular(20), ), child: Center(child:
    //    Text(textButton,style: TextStyle(fontSize: 16,fontWeight:
    //      FontWeight.bold,color: Colors.white))),), );
  }
}
