import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gradproject/button.dart';
import 'package:gradproject/continuewithphone.dart';
import 'package:gradproject/main.dart';
import 'package:gradproject/passwordFormField.dart';
import 'package:gradproject/repository/user_repository.dart';
import 'package:gradproject/sos.dart';
import 'package:gradproject/splashscreen.dart';
import 'package:gradproject/style.dart';
import 'package:gradproject/emailFormField.dart';
import 'package:gradproject/translations/locale_keys.g.dart';
import 'dart:ui';
import 'package:gradproject/services/auth_service.dart';

class authPage extends StatefulWidget {
  const authPage({super.key});

  @override
  State<authPage> createState() => _authPageState();
}

class _authPageState extends State<authPage> {
  String email = "";
  String password = "";
  String username = "";
  final _emailcontrollerlogin = TextEditingController();
  final _emailcontrollersignUp = TextEditingController();
  final _passcontrollerlogin = TextEditingController();
  final _passcontrollersignUp = TextEditingController();
  final _confirmpasscontrollersignUp = TextEditingController();
  final _usernamecontrollersignUp = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool selectlogin = true;
  bool selectSignUp = false;
  String emailstate = LocaleKeys.email.tr();
  String passstate = LocaleKeys.password.tr();
  String errorMessage = '';

  bool passwordVisible = true;
  bool confirmpasswordVisible = true;
  bool selectError = true;

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
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.6),
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
                                child: Text(LocaleKeys.Login.tr(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Mycolors.textcolor,
                                        fontFamily: 'Arial')))
                            : Text(LocaleKeys.Login.tr(),
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
                                child: Text(LocaleKeys.Signup.tr(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Mycolors.textcolor,
                                        fontFamily: 'Arial')))
                            : Text(LocaleKeys.Signup.tr(),
                                style: TextStyle(
                                    fontSize: 14, color: Mycolors.notpressed))),
                  ],
                ),
              ),
              (() {
                if (selectlogin) {
                  String? validateEmail(String? formEmail) {
                    if (formEmail == null || formEmail.isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(formEmail)) {
                      return "Please enter a valid email address";
                    }
                  }

                  ;

                  String? validatePass(String? formPass) {
                    if (formPass == null || formPass.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  }

                  Future<void> _saveForm() async {
                    //returns true lw kol el returns mel validator is null
                    final is_valid = _key.currentState?.validate();
                    if (!is_valid!) {
                      setState(() {});
                      return;
                    }
                    _key.currentState!.save();
                    User? user = await AuthService().signInWithEmail(
                        email: _emailcontrollerlogin.text.trim(),
                        password: _passcontrollerlogin.text.trim());
                  }

                  ;
                  return Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.only(top: 120),
                        child: Form(
                          key: _key,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 90.0),
                                child: Text(LocaleKeys.welcome.tr(),
                                    style: TextStyle(
                                        fontSize: 35,
                                        color: Mycolors.textcolor,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Arial')),
                              ),
                              Text(LocaleKeys.glad.tr(),
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
                                      icon: Icons.email,
                                      control: _emailcontrollerlogin,
                                      fillingcolor: Mycolors.fillingcolor,
                                      hint: emailstate,
                                      validator: validateEmail,
                                      keyboard: TextInputType.emailAddress,
                                      obsecure: false)),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 40, right: 37, top: 10),
                                child: TextFormField(
                                  controller: _passcontrollerlogin,
                                  validator: validatePass,
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
                                    hintText: passstate,
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
                                      // TODO: implement forget password
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ContinueWithPhone(
                                                      email:
                                                          _emailcontrollersignUp
                                                              .text,
                                                      pass:
                                                          _passcontrollersignUp
                                                              .text,
                                                      username:
                                                          _usernamecontrollersignUp
                                                              .text)));
                                    },
                                    child: Text(LocaleKeys.forgetpass.tr(),
                                        style: TextStyle(
                                            fontFamily: 'Arial',
                                            color: Mycolors.textcolor,
                                            fontSize: 13))),
                              ),
                              SizedBox(height: 100),
                              selectError == true
                                  ? Text("")
                                  : Text("Invalid email or password",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 12)),
                              SizedBox(height: 20),
                              Button(
                                  textButton: LocaleKeys.Login.tr(),
                                  onTap: () async {
                                    if (_key.currentState!.validate()) {
                                      _saveForm();

                                      String email =
                                          _emailcontrollerlogin.text.trim();
                                      String password =
                                          _passcontrollerlogin.text.trim();

                                      // Check if either field is empty.

                                      // Check if the user already has an
                                      // account.
                                      User? user = await AuthService()
                                          .signInWithEmail(
                                              email: email, password: password);

                                      if (user == null) {
                                        // make text appear
                                        selectError = false;
                                        setState(() {});
                                        return;
                                      }
                                      if (mounted) {
                                        // TODO: navigate to home page
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => sosPage()),
                                        );
                                      }
                                    }
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }

                String? validateEmail(String? formEmail) {
                  if (formEmail == null || formEmail.isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(formEmail)) {
                    return "Please enter a valid email address";
                  }
                }

                ;
                Future<void> _saveForm() async {
                  //returns true lw kol el returns mel validator is null
                  final is_valid = _form.currentState?.validate();
                  if (!is_valid!) {
                    setState(() {});
                    return;
                  }
                  _form.currentState!.save();
                  String email = _emailcontrollersignUp.text.trim();
                  String password = _passcontrollersignUp.text.trim();
                  String username = _usernamecontrollersignUp.text.trim();
                  String confirmpassword =
                      _confirmpasscontrollersignUp.text.trim();
                  User? user = await AuthService()
                      .signUpWithEmail(email: email, password: password);
                  UserProfile profile = UserProfile(
                      email: _emailcontrollersignUp.text,
                      username: _usernamecontrollersignUp.text);
                  await UserRepository().updateUserProfile(profile);
                }

                ;
                //sign up page
                return Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(top: 120),
                      child: Form(
                        key: _form,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(LocaleKeys.createacc.tr(),
                                style: TextStyle(
                                    fontSize: 35,
                                    color: Mycolors.textcolor,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Arial')),
                            Text(LocaleKeys.getstarted.tr(),
                                style: TextStyle(
                                    fontSize: 35,
                                    color: Mycolors.textcolor,
                                    fontWeight: FontWeight.w400)),
                            // SizedBox(height: 20),
                            Container(
                                margin: EdgeInsets.only(
                                    right: 40, left: 40, top: 40),
                                child: TextFieldWidget(
                                    control: _emailcontrollersignUp,
                                    validator: validateEmail,
                                    fillingcolor: Mycolors.fillingcolor,
                                    hint: LocaleKeys.email.tr(),
                                    icon: Icons.email,
                                    keyboard: TextInputType.emailAddress,
                                    obsecure: false)),
                            Container(
                                margin: EdgeInsets.only(
                                    right: 40, left: 40, top: 10),
                                child: TextFieldWidget(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Username is required';
                                      }
                                      if (value.length > 20) {
                                        return ("username is too long");
                                      }
                                    },
                                    icon: Icons.person,
                                    control: _usernamecontrollersignUp,
                                    fillingcolor: Mycolors.fillingcolor,
                                    hint: LocaleKeys.usernameone.tr(),
                                    keyboard: TextInputType.emailAddress,
                                    obsecure: false)),
                            Container(
                              margin:
                                  EdgeInsets.only(left: 40, right: 37, top: 10),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password is required';
                                  }
                                },
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
                                  hintText: LocaleKeys.password.tr(),
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

                            Container(
                              margin:
                                  EdgeInsets.only(left: 40, right: 34, top: 10),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Confirm pass is required';
                                  }
                                  if (value != _passcontrollersignUp.text) {
                                    return "password not match";
                                  }
                                },
                                controller: _confirmpasscontrollersignUp,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: confirmpasswordVisible == true
                                    ? true
                                    : false,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintStyle: TextStyle(
                                      color: Mycolors.notpressed,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700),
                                  hintText: LocaleKeys.confirmpass.tr(),
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
                                          color: Mycolors.notpressed,
                                          width: 3)),
                                ),
                              ),
                            ),
                            SizedBox(height: 90),
                            Button(
                                textButton: LocaleKeys.Signup.tr(),
                                onTap: () async {
                                  _saveForm();
                                  // until you make the text field for user name i
                                  // created _usernamecontrollersignUp in the top
                                  // of _authPageState class you can't sign up
                                  // until user fill all text fields and password
                                  // and confirm password match TODO : make new
                                  // text field for user name TODO : make an error
                                  // text that render error messages to the user

                                  if (_emailcontrollersignUp.text.isEmpty ||
                                      _passcontrollersignUp.text.isEmpty ||
                                      _confirmpasscontrollersignUp
                                          .text.isEmpty ||
                                      _usernamecontrollersignUp.text.isEmpty) {
                                    print("empty");
                                    return;
                                  }
                                  // make sure that user name is less than 20
                                  // characters
                                  if (username.length > 20) {
                                    print("username is too long");
                                    return;
                                  }
                                  if (_passcontrollersignUp.text !=
                                      _confirmpasscontrollersignUp.text) {
                                    print("password not match");
                                    return;
                                  }
                                  User? user = await AuthService()
                                      .signUpWithEmail(
                                          email: email, password: password);
                                  UserProfile profile = UserProfile(
                                      email: _emailcontrollersignUp.text,
                                      username: _usernamecontrollersignUp.text);
                                  await UserRepository()
                                      .updateUserProfile(profile);
                                  if (user != null) {
                                    // if user is not null then we can update user
                                    // profile using UserRepository class
                                    UserProfile profile = UserProfile(
                                        email: email, username: username);
                                    await UserRepository()
                                        .updateUserProfile(profile);
                                    // after updating user profile we can navigate
                                    // to home page
                                    if (mounted) {
                                      email = _emailcontrollersignUp.text;
                                      password = _passcontrollersignUp.text;
                                      username = _usernamecontrollersignUp.text;
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ContinueWithPhone(
                                                      email: email,
                                                      pass: password,
                                                      username: username)));
                                    }
                                  }
                                })
                          ],
                        ),
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
