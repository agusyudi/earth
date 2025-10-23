import 'package:flutter/material.dart';

class Themes {
  final lightTheme = ThemeData.light().copyWith(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: const Color(0xFFFF4A6D),
    canvasColor: Colors.white,
    focusColor: const Color(0xFFF1F5FC),
    disabledColor: const Color.fromARGB(255, 232, 238, 239),
    cardColor: const Color(0xFFF1F5FC),
    shadowColor: const Color(0xFF028DDB),
    highlightColor: Colors.white,
    secondaryHeaderColor: const Color(0xFF7DAE83),
    textTheme: TextTheme(
      bodyMedium: const TextStyle(color: Color(0xFF0C0C0C)),
      bodySmall: TextStyle(color: const Color(0xFF88888B)),
    ),
  );

  final darkTheme = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF232428),
    primaryColor: const Color(0xFFFF4A6D),
    canvasColor: Colors.black87,
    focusColor: const Color.fromARGB(255, 60, 61, 65),
    disabledColor: const Color(0xFF2C2C2E),
    cardColor: const Color(0xFF000000),
    shadowColor: Colors.black87,
    highlightColor: const Color(0xFF232428),
    secondaryHeaderColor: const Color(0xFF565745),
    textTheme: TextTheme(
      bodyMedium: const TextStyle(color: Color(0xFFF3F7FC)),
      bodySmall: TextStyle(color: const Color(0xFFB4B6B8)),
    ),
  );
}
