import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gradproject/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: splashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
