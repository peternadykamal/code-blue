import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradproject/numericpad.dart';
import 'package:gradproject/style.dart';
import 'package:gradproject/translations/locale_keys.g.dart';
import 'package:gradproject/verify.dart';


class ContinueWithPhone extends StatefulWidget {
  @override
  _ContinueWithPhoneState createState() => _ContinueWithPhoneState();
}

class _ContinueWithPhoneState extends State<ContinueWithPhone> {

  String phoneNumber = "";

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.close,
          size: 30,
          color: Mycolors.textcolor,
        ),
          title: Text(
LocaleKeys.phoneverification.tr(),style: TextStyle(fontFamily:"Arial",fontSize: 20,fontWeight: FontWeight.bold,color: Mycolors.textcolor)
          ),
        backgroundColor: Mycolors.fillingcolor,
        elevation: 0,
        centerTitle: true,
        textTheme: Theme.of(context).textTheme,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[

            Expanded(
              child: Container(

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

   

                        Stack(children:[ SvgPicture.asset("assets/images/confirmphonee.svg"),
                 Container(
                  margin: EdgeInsets.only(top: 120,right: 120),
                  child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children:[ Text(LocaleKeys.yourec.tr(),style: TextStyle(fontFamily:"Arial",fontSize: 16 ,color: Mycolors.textcolor,fontWeight: FontWeight.bold))
                  ,Padding(
              padding: const EdgeInsets.only(left: 7.0),
              child: Text(LocaleKeys.fourcode.tr(),style: TextStyle(fontFamily:"Arial",fontSize: 16 ,color: Mycolors.textcolor,fontWeight: FontWeight.bold)),
                  ),
                  Padding(
              padding: const EdgeInsets.only(right: 28.0),
              child: Text(LocaleKeys.toverify.tr(),style: TextStyle(fontFamily:"Arial",fontSize: 16 ,color: Mycolors.textcolor,fontWeight: FontWeight.bold)),
                  ),
            
                  
            ]),
                  ),
                  
                 ]),

                  ],
                ),
              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height * 0.13,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: <Widget>[

                    Container(
                      width: 230,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          Text(
                            LocaleKeys.Enteryourphone.tr(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey//Colors.grey,
                            ),
                          ),

                          SizedBox(
                            height: 8,
                          ),

                          Text(
                            phoneNumber,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                        ],
                      ),
                    ),

                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => VerifyPhone(phoneNumber: phoneNumber)),
                          );
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Mycolors.buttoncolor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              LocaleKeys.Continue.tr(),
                              style: TextStyle(
                    
                                fontSize: 14,
                                color: Mycolors.fillingcolor
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),

            NumericPad(
              onNumberSelected: (value) {
                setState(() {
                  if(value != -1){
                    phoneNumber = phoneNumber + value.toString();
                  }
                  else{
                    phoneNumber = phoneNumber.substring(0, phoneNumber.length - 1);
                  }                  
                });
              },
            ),

          ],
        )
      ),
    );
  }
}