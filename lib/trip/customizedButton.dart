import 'package:flutter/material.dart';

class customizedButton extends StatelessWidget {
  final String? title;
  final Color color;
  final Function()? onPressed;

  customizedButton({this.title, this.onPressed, required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        primary: color,
        onPrimary: Colors.white,
      ),
      child: Container(
        height: 50,
        child: Center(
          child: Text(
            title!,
            style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
          ),
        ),
      ),
    );
  }
}
