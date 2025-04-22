// lib/core/themes/colors_style.dart

import 'package:flutter/material.dart';


class AppColors {
  // Basic Colors
  static const Color black = Color(0xFF121212);
  static const Color white = Color(0xFFFFFFFF);

  // Grayscale Palette
  static const Color gray900 = Color(0xFF212121);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color textFieldColor = Color(0xFFE0E0E0);
  static const Color gray100 = Color(0xFFF5F5F5);

  // Primary Colors (from Figma)
  static const Color primary = Color(0xFF6A5ACD); // Deep Indigo (Primary)
  static const Color accentYellow = Color(0xFFFFC107); // Secondary Accent

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF121212);

  // Text Colors
  static const Color textPrimary = black;
  static const Color textSecondary = gray700;
  static const Color textLight = white;


}

// Example usage:
// - AppColors.accent → primary brand accent color
// - AppColors.success → indicate success states
// - AppColors.gray500 → neutral content or placeholders
