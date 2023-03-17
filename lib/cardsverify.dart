import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gradproject/style.dart';

class cardverify extends StatelessWidget {
  const cardverify({super.key});

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
          child: Text("_____",style: TextStyle(color: Mycolors.textcolor)))),
      ),
    );
  }
}