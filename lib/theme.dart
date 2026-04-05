import 'package:flutter/material.dart';

class FlorTheme {
  // Colors
  static const Color background = Color(0xFFFDFAF5);
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textAccent = Color.fromARGB(255, 255, 183, 0);
  static const Color yellow = Color(0xFFF9E4A0);
  static const Color pink = Color(0xFFF5C4D0);
  static const Color green = Color(0xFFC4DDB8);
  static const Color blue = Color(0xFFBDD7EE);
  static const Color neutral = Color(0xFFE8E3DC);

  // Text
  static const TextStyle heading = TextStyle(
    color: textAccent,
    fontSize: 30,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
  );

  static const TextStyle subheading = TextStyle(
    color: textDark,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle body = TextStyle(
    color: textDark,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle caption = TextStyle(
    color: Color(0xFF888888),
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
}
