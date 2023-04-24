import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gradproject/style.dart';

class loadingContainer extends StatelessWidget {
  const loadingContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      color: Mycolors.fillingcolor,
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: Mycolors.splashback,
          color: Mycolors.splashback,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
