import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gradproject/style.dart';

class PassFormField extends StatefulWidget {
  TextEditingController control;
  final bool  passwordVisible=true;
  final String hint;
  final Color fillingcolor;
  final Color bordercolor;
  PassFormField({required this.control,required this.fillingcolor,required this.bordercolor,required this.hint});
  

  @override
  State<PassFormField> createState() => _PassFormFieldState();
}

class _PassFormFieldState extends State<PassFormField> {
  

  @override
  Widget build(BuildContext context) {
   bool passwordVisible = true;

    return TextFormField(
  
controller: widget.control,
      cursorColor: Colors.black,
      keyboardType:  TextInputType.visiblePassword, 
      obscureText:passwordVisible==true?true:false,
      decoration:InputDecoration(

        hintStyle: TextStyle(color: Mycolors.notpressed,fontSize: 14),
      hintText: widget.hint,
      filled: true,
      fillColor: widget.fillingcolor,
       prefixIcon: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.password,
                          color: Colors.grey,
                        ), // icon is 48px widget.
                      ),
                      suffixIcon:
Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
          

            child: InkWell(
              onTap: (){setState(() {
                passwordVisible =!passwordVisible;
              });},

              child: Icon(
                passwordVisible
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                size: 24,
                color: Colors.grey,
              ),
            ),
          
        ),
                   
                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                      ), 

                      
    


      );
  }
}