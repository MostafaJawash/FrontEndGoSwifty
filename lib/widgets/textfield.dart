import 'package:flutter/material.dart';

class CustomFormTextField extends StatelessWidget {
  CustomFormTextField({
    required this.hintText,
    this.onChanged,
    this.obscureText = false,
    required this.lable,
    this.validator, 
  });

  final Function(String)? onChanged;
  final String hintText;
  final String lable;
  final bool? obscureText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(style: TextStyle(color: Colors.white),
      obscureText: obscureText!,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        label: Text(
          lable,
          style: TextStyle(color: Colors.white),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.white)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Color(0xffC47DFF))),
     
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Color(0xffC47DFF)),
        ),
      ),
    );
  }
}