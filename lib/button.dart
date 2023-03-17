import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:gradproject/style.dart';

class Button extends StatelessWidget {
  final String textButton;
  final Function()? onTap;
  const Button({required this.textButton ,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 50,
      child: ElevatedButton(onPressed: onTap, child:  Text(
          textButton.toUpperCase(),
          style: TextStyle(fontSize: 14)
          
        ),
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(10),
         
    
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(Mycolors.buttoncolor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Mycolors.buttoncolor)
            )
          ))),
    );
    //  return Card(
    //   elevation: 3,
    //   borderOnForeground: false,
    //   shadowColor: Mycolors.buttoncolor,
    //    child: Container(
    //      height: 47,
    //      width: 240,
    //      decoration: BoxDecoration(color: Mycolors.buttoncolor,
    //      borderRadius: BorderRadius.circular(20),
    //      ),
    //      child: Center(child: Text(textButton,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white))),),
    //  );
    
  }
}