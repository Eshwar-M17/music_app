import 'package:c_lient/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Pallete.backgroundColor,
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Pallete.backgroundColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(27),
      enabledBorder: _border(Pallete.borderColor),
      focusedBorder: _border(Pallete.gradient1),
    ),
  );

  static OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: 3),
    );
  }
}
