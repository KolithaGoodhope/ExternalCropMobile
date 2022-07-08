import 'package:flutter/material.dart';

class Constants {
  // Name
  static String appName = "Rhinestone";

  // Material Design Color
  static Color lightPrimary = Color(0xfffcfcff);
  static Color lightAccent = Color(0xFF3B72FF);
  static Color lightBackground = Color(0xfffcfcff);

  static Color darkPrimary = Colors.black;
  static Color darkAccent = Color(0xFF3B72FF);
  static Color darkBackground = Colors.black;

  static Color grey = Color(0xff707070);
  static Color textPrimary = Color(0xFF486581);
  static Color textDark = Color(0xFF102A43);

  static Color backgroundColor = Color(0xFFF5F5F7);

  // Green
  static Color darkGreen = Color(0xFF3ABD6F);
  static Color lightGreen = Color(0xFFA1ECBF);
  static Color green = Color(0xFF28824d);

  // Yellow
  static Color darkYellow = Color(0xFFddf542);
  static Color lightYellow = Color(0xFFFFDA7A);

  // Blue
  static Color darkBlue = Color(0xFF3B72FF);
  static Color lightBlue = Color(0xFF3EC6FF);

  // Orange
  static Color darkOrange = Color(0xFFFFB74D);
  static Color lightOrange = Color(0xFFE5C46E);

  static Color lightBrown = Color(0xFFB38C62);

  static const Color transparent = Color(0x00000000);
  static const Color layerOneBg = Color(0x80FFFFFF);
  static const Color layerTwoBg = Color(0xFFE9FFF6);

  static const Color forgotPasswordText = Color(0xFF024335);
  static const Color signInButton = Color(0xFF024335);

  static const Color checkbox = Color(0xFF024335);
  static const Color signInBox = Color(0xFF024335);

  static const Color hintText = Color(0xFFB4B4B4);
  static const Color inputBorder = Color(0xFF707070);

  static ThemeData lighTheme(BuildContext context) {
    return ThemeData(
      backgroundColor: lightBackground,
      primaryColor: lightPrimary,
      accentColor: lightAccent,
      cursorColor: lightAccent,
      scaffoldBackgroundColor: lightBackground,
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(
          color: lightAccent,
        ),
      ),
    );
  }

//  static double headerHeight = 228.5;
  static double paddingSide = 10.0;

  static int FUNCTION_KEY =1;
  static int FUNCTION_KEY_REGISTRATION =1;
  static int FUNCTION_KEY_EXTERNAL_CROP_DATA =2;
  static int FUNCTION_KEY_CONFIRMATION =3;
  static int FUNCTION_KEY_REPORT =4;
}