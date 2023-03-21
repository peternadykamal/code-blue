import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gradproject/button.dart';
import 'package:gradproject/passwordFormField.dart';
import 'package:gradproject/splashscreen.dart';
import 'package:gradproject/style.dart';
import 'package:gradproject/emailFormField.dart';
import 'package:gradproject/verification.dart';

class authPage extends StatefulWidget {
  const authPage({super.key});

  @override
  State<authPage> createState() => _authPageState();
}

class _authPageState extends State<authPage> {
  final _emailcontrollerlogin = TextEditingController();
  final _emailcontrollersignUp = TextEditingController();
  final _passcontrollerlogin = TextEditingController();
  final _passcontrollersignUp = TextEditingController();
  final _confirmpasscontrollersignUp = TextEditingController();
  bool selectlogin = true;
  bool selectSignUp = false;

  bool passwordVisible = true;
  bool confirmpasswordVisible = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/pattern.png"),
                  fit: BoxFit.fill)),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 220),
                child: Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            selectlogin = true;
                            selectSignUp = false;
                          });
                        },
                        child: selectlogin
                            ? Container(
                                padding: EdgeInsets.only(bottom: 3),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                  color: Mycolors.splashback,
                                  width: 3.0,
                                ))),
                                child: Text("Login",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Mycolors.textcolor,
                                        fontFamily: 'Arial')))
                            : Text("Login",
                                style: TextStyle(
                                    fontSize: 14, color: Mycolors.notpressed))),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            selectlogin = false;
                            selectSignUp = true;
                          });
                        },
                        child: selectSignUp
                            ? Container(
                                padding: EdgeInsets.only(bottom: 3),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                  color: Mycolors.splashback,
                                  width: 3.0,
                                ))),
                                child: Text("Sign up",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Mycolors.textcolor,
                                        fontFamily: 'Arial')))
                            : Text("Sign up",
                                style: TextStyle(
                                    fontSize: 14, color: Mycolors.notpressed))),
                  ],
                ),
              ),
              (() {
                if (selectlogin) {
                  return Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.only(top: 120),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 90.0),
                              child: Text("Welcome ,",
                                  style: TextStyle(
                                      fontSize: 35,
                                      color: Mycolors.textcolor,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Arial')),
                            ),
                            Text("Glad To See You ",
                                style: TextStyle(
                                    fontSize: 35,
                                    color: Mycolors.textcolor,
                                    fontWeight: FontWeight.w400)),
                            SizedBox(height: 30),
                            Container(
                                margin: EdgeInsets.only(
                                    right: 40, left: 40, top: 20),
                                padding: EdgeInsets.only(top: 3),
                                child: TextFieldWidget(
                                    control: _emailcontrollerlogin,
                                    fillingcolor: Mycolors.fillingcolor,
                                    hint: "Email",
                                    keyboard: TextInputType.emailAddress,
                                    obsecure: false)),
                            Container(
                              margin:
                                  EdgeInsets.only(left: 40, right: 37, top: 10),
                              child: TextFormField(
                                controller: _passcontrollerlogin,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText:
                                    passwordVisible == true ? true : false,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintStyle: TextStyle(
                                      color: Mycolors.notpressed,
                                      fontSize: 17,
                                      fontFamily: 'Arial',
                                      fontWeight: FontWeight.w700),
                                  hintText: "Password",
                                  filled: true,
                                  fillColor: Mycolors.fillingcolor,
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.password,
                                      color: Mycolors.notpressed,
                                      size: 20,
                                    ), // icon is 48px widget.
                                  ),
                                  suffixIcon: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          passwordVisible = !passwordVisible;
                                        });
                                      },
                                      child: Icon(
                                        passwordVisible
                                            ? Icons.visibility_rounded
                                            : Icons.visibility_off_rounded,
                                        size: 24,
                                        color: Mycolors.notpressed,
                                      ),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: Mycolors.notpressed,
                                          width: 3)),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(left: 170.0),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                const verifyPage()));
                                  },
                                  child: Text("forget password?",
                                      style: TextStyle(
                                          fontFamily: 'Arial',
                                          color: Mycolors.textcolor,
                                          fontSize: 13))),
                            ),
                            SizedBox(height: 100),
                            Button(textButton: "Login", onTap: () {})
                          ],
                        ),
                      ),
                    ),
                  );
                }

                //sign up page
                return Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(top: 120),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Create Account ,",
                              style: TextStyle(
                                  fontSize: 35,
                                  color: Mycolors.textcolor,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Arial')),
                          Text("To Get Started Now!",
                              style: TextStyle(
                                  fontSize: 35,
                                  color: Mycolors.textcolor,
                                  fontWeight: FontWeight.w400)),
                          // SizedBox(height: 20),
                          Container(
                              margin:
                                  EdgeInsets.only(right: 40, left: 40, top: 40),
                              child: TextFieldWidget(
                                  control: _emailcontrollersignUp,
                                  fillingcolor: Mycolors.fillingcolor,
                                  hint: "Email",
                                  keyboard: TextInputType.emailAddress,
                                  obsecure: false)),
                          Container(
                            margin:
                                EdgeInsets.only(left: 40, right: 37, top: 10),
                            child: TextFormField(
                              controller: _passcontrollersignUp,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText:
                                  passwordVisible == true ? true : false,
                              decoration: InputDecoration(
                                isDense: true,
                                hintStyle: TextStyle(
                                    color: Mycolors.notpressed,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700),
                                hintText: "Password",
                                filled: true,
                                fillColor: Mycolors.fillingcolor,
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.password,
                                    color: Mycolors.notpressed,
                                    size: 20,
                                  ), // icon is 48px widget.
                                ),
                                suffixIcon: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                    child: Icon(
                                      passwordVisible
                                          ? Icons.visibility_rounded
                                          : Icons.visibility_off_rounded,
                                      size: 24,
                                      color: Mycolors.notpressed,
                                    ),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Mycolors.notpressed, width: 3)),
                              ),
                            ),
                          ),

                          Container(
                            margin:
                                EdgeInsets.only(left: 40, right: 34, top: 10),
                            child: TextFormField(
                              controller: _confirmpasscontrollersignUp,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText:
                                  confirmpasswordVisible == true ? true : false,
                              decoration: InputDecoration(
                                isDense: true,
                                hintStyle: TextStyle(
                                    color: Mycolors.notpressed,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700),
                                hintText: "Confirm Password",
                                filled: true,
                                fillColor: Mycolors.fillingcolor,
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Icon(
                                    Icons.verified_outlined,
                                    color: Mycolors.notpressed,
                                    size: 20,
                                  ), // icon is 48px widget.
                                ),
                                suffixIcon: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        confirmpasswordVisible =
                                            !confirmpasswordVisible;
                                      });
                                    },
                                    child: Icon(
                                      confirmpasswordVisible
                                          ? Icons.visibility_rounded
                                          : Icons.visibility_off_rounded,
                                      size: 24,
                                      color: Mycolors.notpressed,
                                    ),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Mycolors.notpressed, width: 3)),
                              ),
                            ),
                          ),
                          SizedBox(height: 90),
                          Button(
                              textButton: "Sign up",
                              onTap: () {
                                FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: _emailcontrollersignUp.text,
                                        password: _passcontrollersignUp.text)
                                    .then((value) {
                                  print("account created");
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              splashScreen()));
                                }).onError((error, stackTrace) {
                                  print("error");
                                });
                              })
                        ],
                      ),
                    ),
                  ),
                );
                ;
              }()),
            ],
          ),
        ),
      ),
    );
  }
}
