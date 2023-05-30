
import 'package:flutter/material.dart';
import 'package:gradproject/trip/brand_colors.dart';



class CustomOutlineButton extends StatelessWidget {
  final String? title;
  final Function()? onPressed;
  final Color color;

  CustomOutlineButton({this.title, this.onPressed, required this.color});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        backgroundColor: color,
        primary: BrandColors.colorText,
      ),
      onPressed: onPressed,
      child: Container(
        height: 50.0,
        child: Center(
          child: Text(title!,
              style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Brand-Bold',
                  color: BrandColors.colorText)),
        ),
      ),
    );
  }
}
