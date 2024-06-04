import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyColors {
  static const Color primary = Color(0xFF72140C);
  static const Color primaryDark = Color(0xFF460805);
  static const Color primaryLight = Color(0xFFEA6259);
  static const Color accent = Color(0xFFFF4081);
  static const Color accentDark = Color(0xFFF50057);
  static const Color accentLight = Color(0xFFFF80AB);

  static const Color grey_3 = Color(0xFFf7f7f7);
  static const Color grey_5 = Color(0xFFf2f2f2);
  static const Color grey_10 = Color(0xFFe6e6e6);
  static const Color grey_20 = Color(0xFFcccccc);
  static const Color grey_40 = Color(0xFF999999);
  static const Color grey_60 = Color(0xFF666666);
  static const Color grey_80 = Color(0xFF37474F);
  static const Color grey_90 = Color(0xFF263238);
  static const Color grey_95 = Color(0xFF1a1a1a);
  static const Color grey_100_ = Color(0xFF0d0d0d);

  static const Color overlay_light_5 = Color(0xDFFFFFF);
  static const Color overlay_light_10 = Color(0x1AFFFFFF);
  static const Color overlay_light_20 = Color(0x33FFFFFF);
  static const Color overlay_light_30 = Color(0x4DFFFFFF);
  static const Color overlay_light_40 = Color(0x66FFFFFF);
  static const Color overlay_light_50 = Color(0x80FFFFFF);

  static const Color overlay_dark_5 = Color(0xD000000);
  static const Color overlay_dark_10 = Color(0x1A000000);
  static const Color overlay_dark_20 = Color(0x33000000);
  static const Color overlay_dark_30 = Color(0x4D000000);
  static const Color overlay_dark_40 = Color(0x66000000);
  static const Color overlay_dark_50 = Color(0x80000000);

  static getTheme() {
    return ThemeData(
      primaryColor: primary,
      primaryColorDark: primaryDark,
      primaryColorLight: primaryLight,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: primary,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: primary,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        elevation: 0,
        actionsIconTheme: IconThemeData(
          color: Colors.white,
        ),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      fontFamily: 'Poppins',
      textTheme: TextTheme(
        headline1: TextStyle(
          fontSize: 96.0,
          fontWeight: FontWeight.w300,
          color: Colors.black,
        ),
        headline2: TextStyle(
          fontSize: 60.0,
          fontWeight: FontWeight.w300,
          color: Colors.black,
        ),
        headline3: TextStyle(
          fontSize: 48.0,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        headline4: TextStyle(
          fontSize: 34.0,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        headline5: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        headline6: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        subtitle1: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        subtitle2: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        bodyText1: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        bodyText2: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        button: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        caption: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        overline: TextStyle(
          fontSize: 10.0,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
    );
  }
}
