import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:gradproject/style.dart';

class TextFieldWidget extends StatefulWidget {
  TextEditingController control;
  final bool obsecure;
  final TextInputType keyboard;
  final String hint;
  final Color fillingcolor;
  final IconData icon;
  final String? Function(String?)? validator;

  TextFieldWidget(
      {required this.control,
      required this.fillingcolor,
      required this.icon,
      required this.validator,
      required this.hint,
      required this.keyboard,
      required this.obsecure});

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        validator: widget.validator,
        controller: widget.control,
        keyboardType: widget.keyboard,
        obscureText: widget.obsecure,
        decoration: InputDecoration(
          hintStyle: TextStyle(
              color: Mycolors.notpressed,
              fontSize: 17,
              fontWeight: FontWeight.w600),
          hintText: widget.hint,
          filled: true,
          fillColor: widget.fillingcolor,
          isDense: true,
          prefixIcon: Padding(
            padding: EdgeInsets.all(10.0),
            child: Icon(
              widget.icon,
              color: Mycolors.notpressed,
              size: 20,
            ), // icon is 48px widget.
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: new BorderSide(color: Mycolors.notpressed, width: 3)),
        ));
  }
}
