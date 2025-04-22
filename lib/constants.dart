// constants.dart
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

// Отступы
class AppPadding {
  static double small = 8.w;
  static double medium = 16.w;
  static double large = 24.w;
}

// Размеры шрифта
class FontSize {
  static double small = 12.sp;
  static double medium = 16.sp;
  static double large = 20.sp;
}

// Текстовые стили
class AppTextStyle {
  static TextStyle regular = TextStyle(
    fontSize: FontSize.medium,
    fontWeight: FontWeight.normal,
  );

  static TextStyle bold = TextStyle(
    fontSize: FontSize.large,
    fontWeight: FontWeight.bold,
  );

  static TextStyle error = TextStyle(
    fontSize: FontSize.medium,
    fontWeight: FontWeight.w600,
    color: Colors.red,
  );
}
