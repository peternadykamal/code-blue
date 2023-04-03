import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gradproject/style.dart';

class profileone extends StatefulWidget {
  const profileone({super.key});

  @override
  State<profileone> createState() => _profileoneState();
}

class _profileoneState extends State<profileone> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mycolors.splashback,
    );
  }
}