import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AppStyles {
  // General Colors
  static Map<String, Color> generalColors = {
    'primary': const Color.fromARGB(255, 253, 220, 148),
    'secondary': const Color.fromARGB(255, 75, 75, 75),
    'tertiary': const Color.fromARGB(255, 255, 255, 255),
    'details': const Color.fromARGB(255, 255, 184, 78),
    'scaffoldBackground': const Color.fromARGB(255, 255, 239, 204),
    'success': const Color.fromARGB(255, 111, 233, 111),
    'cancel': const Color.fromARGB(255, 243, 85, 85),
  };
  // Text Colors
  static Map<String, Color> textColors = {
    'primary': const Color.fromARGB(255, 75, 75, 75),
    'secondary': const Color.fromARGB(255, 255, 255, 255),
    'tertiary': const Color.fromARGB(255, 255, 184, 78),
  };
  // Text Styles
  static TextStyle textStyleH1({required textColor}) => TextStyle(
        color: textColor,
        fontSize: 4.2.w,
        fontWeight: FontWeight.w600,
        letterSpacing: 2,
      );
  static TextStyle textStyleH2({required textColor}) => TextStyle(
        color: textColor,
        fontSize: 4.0.w,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
      );
  static TextStyle textStyleH3({required textColor}) => TextStyle(
        color: textColor,
        fontSize: 3.5.w,
        fontWeight: FontWeight.w400,
        letterSpacing: 1.1,
      );
  static TextStyle textStyleH4({required textColor}) => TextStyle(
        color: textColor,
        fontSize: 2.8.w,
        fontWeight: FontWeight.w400,
        letterSpacing: 1,
      );
  static TextStyle textStyleH5({required textColor}) => TextStyle(
        color: textColor,
        fontSize: 4.2.w,
        fontWeight: FontWeight.w600,
        letterSpacing: 2,
        decoration: TextDecoration.underline,
      );

  // BoxShadows
  static BoxShadow customBoxShadow({required bool downDirection}) => BoxShadow(
        color: generalColors['details']!,
        blurRadius: 12.0,
        spreadRadius: -2.0,
        offset: (downDirection) ? const Offset(0, 2) : const Offset(0, -2),
      );

  // Radius
  static const double smallRadius = 8.0;
  static const double mediumRadius = 18.0;
  static const double bigRadius = 44.0;
  static Map<String, Radius> containerRadius = {
    'small': const Radius.circular(smallRadius),
    'medium': const Radius.circular(mediumRadius),
    'big': const Radius.circular(bigRadius),
  };
  static Radius customRadius(
          {required Radius radius, required double offset}) =>
      Radius.circular(radius.x + offset);

// BoxDecorations
  static BoxDecoration customBoxDecoration({
    required Color backgroundColor,
    required Radius radius,
    required bool shadows,
    required bool shadowDownDirection,
    Color borderColor = Colors.transparent,
  }) =>
      BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(radius),
        border: Border.all(color: borderColor, width: 1.5),
        boxShadow: (shadows)
            ? (shadowDownDirection)
                ? [customBoxShadow(downDirection: true)]
                : [customBoxShadow(downDirection: false)]
            : [],
      );
}
