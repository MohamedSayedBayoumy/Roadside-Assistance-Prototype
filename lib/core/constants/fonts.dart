import 'package:flutter/material.dart';

abstract class AppFonts {
  static String enFamily = "main";

  static TextStyle get style12 => TextStyle(
    fontSize: 12,
    color: Colors.black,
    fontFamily: enFamily,
    fontWeight: FontWeight.w300,
  );

  static TextStyle get style15 => TextStyle(
    fontSize: 15,
    color: Colors.black,
    fontFamily: enFamily,
    fontWeight: FontWeight.w300,
  );

  static TextStyle get styleLight25 => TextStyle(
    fontSize: 32,
    color: Colors.black,
    fontFamily: enFamily,
    fontWeight: FontWeight.w300,
  );
}
