import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gradproject/style.dart';

class elevButtons extends StatelessWidget {
  
  final String text;
  final Color elevcolor;
  final Color bordercolor;
   elevButtons({required this.text , required this.elevcolor,required this.bordercolor});

  @override
  Widget build(BuildContext context) {
    return Container(width: 150,height: 40,

    decoration:BoxDecoration(
      border: Border.all(color:bordercolor,width: 3 ),
      borderRadius: BorderRadius.circular(10),color:elevcolor) ,
    child: Center(child: Text(text,style: TextStyle(color: Mycolors.textcolor,fontWeight: FontWeight.normal))),
      
    );
    
  }
}