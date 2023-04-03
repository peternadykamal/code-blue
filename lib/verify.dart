import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gradproject/button.dart';
import 'package:gradproject/numericpad.dart';
import 'package:gradproject/sos.dart';
import 'package:gradproject/style.dart';
import 'package:gradproject/translations/locale_keys.g.dart';


class VerifyPhone extends StatefulWidget {

  final String phoneNumber;

  VerifyPhone({required this.phoneNumber});

  @override
  _VerifyPhoneState createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {

  String code = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.black,
          ),
        ),
        title: Text(
          "Verify phone",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Mycolors.textcolor,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        textTheme: Theme.of(context).textTheme,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        "Code is sent to " + widget.phoneNumber,
                        style: TextStyle(
                          fontSize: 22,
                          color: Color(0xFF818181),
                        ),
                      ),
                    ),

                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[

                          buildCodeNumberBox(code.length > 0 ? code.substring(0, 1) : ""),
                          buildCodeNumberBox(code.length > 1 ? code.substring(1, 2) : ""),
                          buildCodeNumberBox(code.length > 2 ? code.substring(2, 3) : ""),
                          buildCodeNumberBox(code.length > 3 ? code.substring(3, 4) : ""),
                          buildCodeNumberBox(code.length > 4 ? code.substring(4, 5) : ""),
                          buildCodeNumberBox(code.length > 5 ? code.substring(5, 6) : ""),

                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          
                          Text(
                            "Didn't recieve code? ",
                            style: TextStyle(
                              fontSize: 18,
                              color: Mycolors.notpressed,
                            ),
                          ),
                          
                          SizedBox(
                            width: 8,
                          ),

                          GestureDetector(
                            onTap: () {
                              print("Resend the code to the user");
                            },
                            child: Text(
                              "Request again",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700
                              ),
                            ),
                          ),
                          
                        ],
                      ),
                    ),
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


                    Container
                    (
                      margin: EdgeInsets.only(right: 20,left: 20),
                      child: Button(textButton: LocaleKeys.Verifyandcreate.tr(), onTap: (){

                        Navigator.pushReplacement(context, MaterialPageRoute(builder: ((context) => sosPage())));
                      }))

                  ],
                ),
              ),
            ),

            NumericPad(
              onNumberSelected: (value) {
                print(value);
                setState(() {
                  if(value != -1){
                    if(code.length < 6){
                      code = code + value.toString();
                    }
                  }
                  else{
                    code = code.substring(0, code.length - 1);
                  }
                  print(code);        
                });
              },
            ),

          ],
        )
      ),
    );
  }

  Widget buildCodeNumberBox(String codeNumber) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        width: 43,
        height: 43,
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
}