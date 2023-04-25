import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradproject/auth.dart';
import 'package:gradproject/repository/user_repository.dart';
import 'package:gradproject/services/auth_service.dart';
import 'package:gradproject/sos.dart';
import 'package:gradproject/style.dart';
import 'package:gradproject/translations/locale_keys.g.dart';
import 'package:gradproject/utils/has_network.dart';
import 'package:gradproject/verify.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ContinueWithPhone extends StatefulWidget {
  final String email;
  final String pass;
  final String username;
  ContinueWithPhone(
      {required this.email, required this.pass, required this.username});
  @override
  _ContinueWithPhoneState createState() => _ContinueWithPhoneState();
}

class _ContinueWithPhoneState extends State<ContinueWithPhone> {
  String phoneNumber = "";
  TextEditingController phoneController = TextEditingController();
  String actualphoneNumber = "";
  int maxLength = 10;
  String _verificationId = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => authPage())),
            child: Icon(
              Icons.close,
              size: 30,
              color: Mycolors.textcolor,
            ),
          ),
          title: Text(LocaleKeys.phoneverification.tr(),
              style: TextStyle(
                  fontFamily: "Arial",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Mycolors.textcolor)),
          backgroundColor: Mycolors.fillingcolor,
          elevation: 0,
          centerTitle: true,
          textTheme: Theme.of(context).textTheme,
        ),
        body: SafeArea(
            child: Column(children: <Widget>[
          Expanded(
            child: Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(children: [
                  Center(
                      child:
                          SvgPicture.asset("assets/images/confirmphonee.svg")),
                  Container(
                    margin: EdgeInsets.only(top: 120, right: 120),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(LocaleKeys.yourec.tr(),
                                style: TextStyle(
                                    fontFamily: "Arial",
                                    fontSize: 16,
                                    color: Mycolors.textcolor,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 7.0),
                            child: Text(LocaleKeys.fourcode.tr(),
                                style: TextStyle(
                                    fontFamily: "Arial",
                                    fontSize: 16,
                                    color: Mycolors.textcolor,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 28.0),
                            child: Text(LocaleKeys.toverify.tr(),
                                style: TextStyle(
                                    fontFamily: "Arial",
                                    fontSize: 16,
                                    color: Mycolors.textcolor,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ]),
                  ),
                ]),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Container(
                    width: 230,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IntlPhoneField(
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(),
                              ),
                            ),
                            controller: phoneController,
                            initialCountryCode: 'EG',
                            onChanged: (phone) {
                              actualphoneNumber = phone.completeNumber;
                            },
                            onCountryChanged: (Country) {
                              maxLength = Country.maxLength;
                            },
                          ),
                          SizedBox(height: 30),
                          GestureDetector(
                              onTap: () async {
                                if (int.parse(phoneController.text) <
                                    maxLength) {
                                  return;
                                }
                                try {
                                  await FirebaseAuth.instance.verifyPhoneNumber(
                                    phoneNumber: actualphoneNumber,
                                    verificationCompleted:
                                        (PhoneAuthCredential credential) async {
                                      UserProfile user = UserProfile(
                                        email: widget.email,
                                        username: widget.username,
                                        phoneNumber: actualphoneNumber,
                                      );
                                      if (await isNetworkAvailable()) {
                                        await AuthService().signUpWithEmail(
                                          email: widget.email,
                                          password: widget.pass,
                                        );
                                        await FirebaseAuth.instance.currentUser
                                            ?.linkWithCredential(credential);
                                        await FirebaseAuth.instance.currentUser
                                            ?.updateDisplayName(
                                                widget.username);
                                        await UserRepository()
                                            .updateUserProfile(user);
                                      }
                                      if (mounted) {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    sosPage()));
                                      }
                                    },
                                    verificationFailed:
                                        (FirebaseAuthException e) {
                                      Fluttertoast.showToast(
                                          msg: e.message.toString());
                                    },
                                    codeSent: (String verificationId,
                                        [int? forceResendingToken]) async {
                                      setState(() {
                                        _verificationId = verificationId;
                                      });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => VerifyPhone(
                                                verificationId: verificationId,
                                                forceResendingToken:
                                                    forceResendingToken,
                                                phoneNumber: actualphoneNumber,
                                                email: widget.email,
                                                pass: widget.pass,
                                                username: widget.username)),
                                      );
                                    },
                                    codeAutoRetrievalTimeout:
                                        (String verificationId) {},
                                  );
                                } catch (e) {
                                  Fluttertoast.showToast(msg: e.toString());
                                }
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
                                          color: Mycolors.fillingcolor),
                                    ),
                                  )))
                        ]),
                  ),
                ),
              ],
            )),
          )
        ])));
  }
}
