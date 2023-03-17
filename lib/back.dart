import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gradproject/style.dart';

class backBtn extends StatelessWidget {
  final void Function()? onPressing;
  final Icon icon2;
  const backBtn({required this.onPressing , required this.icon2});




  @override
  Widget build(BuildContext context) {
return new Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: AppBar(
                    title: Text(''),// You can add title here
                    leading: new IconButton(
                      icon: Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15) ,color: Mycolors.textcolor),
                        child: new Icon(icon2 as IconData?, color: Mycolors.textcolor)),
                        onPressed:onPressing   ,
                    ),
                    backgroundColor: Colors.transparent, //You can make this transparent
                    elevation: 0.0, 
                  ),);
      

    
  }
}