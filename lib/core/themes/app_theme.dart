// lib/core/themes/app_theme.dart
import 'package:flutter/material.dart';
import '../utils/app_text_style.dart';
import 'colors_style.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      primaryColor: AppColors.accentYellow,
      fontFamily: 'Poppins',

      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: AppColors.accentYellow,
        secondary: AppColors.accentYellow, // or charizard300, if you prefer
      ),

      textTheme: const TextTheme(
        headlineLarge: AppTextStyle.heading0,
        headlineMedium: AppTextStyle.heading1,
        headlineSmall: AppTextStyle.heading2,
        bodyLarge: AppTextStyle.body1,
        bodyMedium: AppTextStyle.body2,
        bodySmall: AppTextStyle.body0, // or whichever mapping you prefer
        labelMedium: AppTextStyle.body3,
      ),

    );
  }
}
