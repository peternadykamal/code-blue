import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gradproject/button.dart';
import 'package:gradproject/style.dart';
import 'package:gradproject/translations/locale_keys.g.dart';
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
       String code = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Mycolors.fillingcolor,
        body: SingleChildScrollView(
          child: Expanded(
            child: Container(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                     IconButton(onPressed:(){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const verifyPage()));} ,icon: Icon(Icons.arrow_back),color: Mycolors.textcolor,iconSize: 30),
                      Container(
                        margin: EdgeInsets.only(left: 50),
                        child: Center(child: Text(LocaleKeys.phoneverification.tr(),style: TextStyle(fontFamily:"Arial",fontSize: 20,fontWeight: FontWeight.bold,color: Mycolors.textcolor)))),
                    ],
                  ),
                  SizedBox(height: 2),
            
            
                  
                 
                 
              
            
            
            
              Text(LocaleKeys.verifycodesentto.tr(),style: TextStyle(color: Mycolors.notpressed,fontWeight: FontWeight.w700)),
              SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                          buildCodeNumberBox(code.length > 0 ? code.substring(0, 1) : ""),
                          buildCodeNumberBox(code.length > 1 ? code.substring(1, 2) : ""),
                          buildCodeNumberBox(code.length > 2 ? code.substring(2, 3) : ""),
                          buildCodeNumberBox(code.length > 3 ? code.substring(3, 4) : ""),

              ],
            ),
            SizedBox(height: 20),
            
            Center(
              child:   Row(
                mainAxisAlignment: MainAxisAlignment.center,
              
                children: [
              
                Text( LocaleKeys.didnotreceive.tr(),style: TextStyle(color: Mycolors.notpressed,fontWeight: FontWeight.bold)),
                Text(LocaleKeys.Requestagain.tr(),style: TextStyle(fontWeight: FontWeight.bold,color: Mycolors.textcolor))
              
                ],
              
              ),
            ),
            SizedBox(height: 20),
            
            
              Button(textButton: LocaleKeys.Verifyandcreate.tr(), onTap: (){}),
              SizedBox(height: 20),
            NumPad(
              onNumberSelected: (_padcontroller) {
                print(_padcontroller);
                setState(() {
                  if(_padcontroller != -1){
                    if(code.length < 4){
                      code = code + _padcontroller.toString();
                    }
                  }
                  else{
                    code = code.substring(0, code.length - 1);
                  }
                  print(code);        
                });
              },
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
            
              
              }),

            
],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
Widget buildCodeNumberBox(String codeNumber) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        width: 60,
        height: 60,
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFF6F5FA),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 25.0,
                  spreadRadius: 1,
                  offset: Offset(0.0, 0.75)
              )
            ],
          ),
          child: Center(
            child: Text(
              codeNumber,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F1F1F),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
