import 'package:flutter/material.dart';
import 'package:login/constants/colors.dart';

class textfield extends StatelessWidget {
  const textfield(
      {Key? key,
      required this.controller,
      required this.label,
      required this.secure})
      : super(key: key);

  final TextEditingController controller;
  final String? label;
  final bool secure;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: TextField(
        style: TextStyle(color: textColor),
        cursorColor: textColor,
        obscureText: secure,
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: buttonColor),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: buttonColor),
              borderRadius: BorderRadius.circular(10)),
          labelText: label!,
          labelStyle: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
