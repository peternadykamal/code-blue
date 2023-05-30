

import 'package:flutter/material.dart';
import 'package:gradproject/trip/brand_colors.dart';
import 'package:gradproject/trip/outlinedButton.dart';

class NoDriverDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding:  EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10,),

                Text('No driver found', style: TextStyle(fontSize: 22.0, fontFamily: 'Brand-Bold'),),

                SizedBox(height: 25,),

                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('No available driver close by, we suggest you try again shortly', textAlign: TextAlign.center,),
                ),

                SizedBox(height: 30,),

                Container(
                  width: 200,
                  child: CustomOutlineButton(
                    title: 'CLOSE',
                    color: BrandColors.colorLightGrayFair,
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                ),

                SizedBox(height: 10,),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
