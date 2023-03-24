import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gradproject/style.dart';

class cardverify extends StatelessWidget {
  TextEditingController controllerpad;
  cardverify({ required this.controllerpad});

  @override
  Widget build(BuildContext context) {
    return  Container(
      width:60,
      height: 60,
      child: Card(
        elevation: 8,
        color: Mycolors.numpad,
        
        child: Center(child: Container(
          margin: EdgeInsets.only(top: 20),
          
            
            child: TextField(controller:controllerpad ,decoration: InputDecoration(hintText: ("___"),hintStyle: TextStyle(),),style: TextStyle(color: Mycolors.textcolor))))),
      
    );
  }
}