import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gradproject/style.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class loadingContainer extends StatelessWidget {
  const loadingContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      color: Mycolors.splashback,
      child: Center(
        child: LoadingAnimationWidget.threeArchedCircle(
            color: Colors.white, size: 40),
      ),
    );
  }
}
