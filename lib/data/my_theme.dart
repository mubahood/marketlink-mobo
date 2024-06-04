import 'package:flutter/material.dart';

class MyTheme {
  static const String lightTheme = 'light';
  static const String darkTheme = 'dark';

  static inputStyle1(String label) {
    return InputDecoration(
      labelText: label,
      hintText: 'Enter $label',
      hintStyle: TextStyle(color: Colors.red[200]),
      labelStyle: TextStyle(color: Colors.red[100]),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red[100]!, width: 1),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red[100]!, width: 2),
      ),
    );
  }
}
