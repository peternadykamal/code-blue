import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gradproject/auth.dart';
import 'package:gradproject/back.dart';
import 'package:gradproject/keypad.dart';
import 'package:gradproject/style.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradproject/verification2.dart';

class verifyPage extends StatefulWidget {
  const verifyPage({super.key});

  @override
  State<verifyPage> createState() => _verifyPageState();
}

class _verifyPageState extends State<verifyPage> {
    final _phonecontroller=TextEditingController();

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
               IconButton(onPressed:(){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const authPage()));} ,icon: Icon(Icons.close),color: Mycolors.textcolor,iconSize: 30),
                Container(
                  margin: EdgeInsets.only(left: 50),
                  child: Center(child: Text("Verify your phone",style: TextStyle(fontFamily:"Arial",fontSize: 20,fontWeight: FontWeight.bold,color: Mycolors.textcolor)))),
              ],
            ),

     Stack(children:[ SvgPicture.asset("assets/images/confirmphonee.svg"),
     Container(
      margin: EdgeInsets.only(top: 120),
      child:Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children:[ Text("You'll receive",style: TextStyle(fontFamily:"Arial",fontSize: 16 ,color: Mycolors.textcolor,fontWeight: FontWeight.bold))
      ,Padding(
        padding: const EdgeInsets.only(left: 7.0),
        child: Text("a 4 digit code",style: TextStyle(fontFamily:"Arial",fontSize: 16 ,color: Mycolors.textcolor,fontWeight: FontWeight.bold)),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 28.0),
        child: Text("to verify.",style: TextStyle(fontFamily:"Arial",fontSize: 16 ,color: Mycolors.textcolor,fontWeight: FontWeight.bold)),
      ),

      
]),
      ),
      
     ]),
     
        
        Container(
          margin: EdgeInsets.only(right:40,left: 40,top: 20),
          child: TextFormField(
            
          
        controller:_phonecontroller ,
        
              keyboardType:TextInputType.none ,
              obscureText:false,
              
              decoration:InputDecoration(
        
          hintStyle: TextStyle(color: Mycolors.notpressed,fontSize: 17,fontWeight: FontWeight.w600),
              hintText: "Phone Number",
              filled: true,
              fillColor: Mycolors.fillingcolor,
              isDense: true,
               prefixIcon: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.perm_phone_msg_outlined,
                            color: Mycolors.notpressed,
                            size: 20,
                          ), // icon is 48px widget.
                        ),
        
                        
            
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: new BorderSide(color: Mycolors.notpressed,width: 3)),
        
          )),

        ),
                  NumPad(
            buttonSize: 70,
            buttonColor: Mycolors.numpad,
            iconColor: Mycolors.xbutton,
            controller: _phonecontroller,
            delete: () {
              _phonecontroller.text = _phonecontroller.text
                  .substring(0, _phonecontroller.text.length - 1);
            },
            // do something with the input numbers
            onSubmit: () {
Navigator.push(context, MaterialPageRoute(builder: (context)=> VerifyPage2()));
        
  })],
        ),
      ),
    );
  }
}