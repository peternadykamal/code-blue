import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gradproject/button.dart';
import 'package:gradproject/style.dart';
import 'package:gradproject/verification.dart';

import 'cardsverify.dart';
import 'keypad.dart';

class VerifyPage2 extends StatefulWidget {
  const VerifyPage2({super.key});

  @override
  State<VerifyPage2> createState() => _VerifyPage2State();
}

class _VerifyPage2State extends State<VerifyPage2> {
      final _padcontroller=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Mycolors.fillingcolor,
        body: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
               IconButton(onPressed:(){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const verifyPage()));} ,icon: Icon(Icons.arrow_back),color: Mycolors.textcolor,iconSize: 30),
                Container(
                  margin: EdgeInsets.only(left: 50),
                  child: Center(child: Text("Verify your phone",style: TextStyle(fontFamily:"Arial",fontSize: 20,fontWeight: FontWeight.bold,color: Mycolors.textcolor)))),
              ],
            ),
            SizedBox(height: 2),


      
     
     
        



        Text("Code is sent to <phone number>",style: TextStyle(color: Mycolors.notpressed,fontWeight: FontWeight.w700)),
        SizedBox(height: 50),
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    
    cardverify(),
    cardverify(),
    cardverify(),
    cardverify()
  ],
),
SizedBox(height: 20),

Center(
  child:   Row(
    mainAxisAlignment: MainAxisAlignment.center,
  
    children: [
  
          Text("Didn't receive code ? ",style: TextStyle(color: Mycolors.notpressed,fontWeight: FontWeight.bold)),
          Text("Request again",style: TextStyle(fontWeight: FontWeight.bold,color: Mycolors.textcolor))
  
    ],
  
  ),
),
SizedBox(height: 20),


        Button(textButton: "Verify and Create Account", onTap: (){}),
        SizedBox(height: 20),
                  NumPad(
            buttonSize: 70,
            buttonColor: Mycolors.numpad,
            iconColor: Mycolors.xbutton,
            controller: _padcontroller,
            delete: () {
              _padcontroller.text = _padcontroller.text
                  .substring(0, _padcontroller.text.length - 1);
            },
            // do something with the input numbers
            onSubmit: () {

        
  })],
        ),
      ),
    );
  }
}
  
