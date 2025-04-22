// lib/core/app_text/app_text_tyle.dart
// lib/core/themes/app_text_style.dart

import 'package:flutter/material.dart';

/// Poppins-based text styles aligned with your Figma design.
///
/// Figma references (approx):
/// - Heading 0 (48) - semibold / regular / light
/// - Heading 1 (32) - semibold / regular / light
/// - Heading 2 (24) - semibold / regular / light
/// - Body 0 (18) - medium / regular / light
/// - Body 1 (16) - medium / regular / light
/// - Body 2 (14) - medium / regular / light
/// - Body 3 (12) - medium / regular / light
///
/// Below are just one weight variant per size for simplicity.
class AppTextStyle {
  // Heading 0: 48, Semibold
  static const TextStyle heading0 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 48,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  // Heading 1: 32, Semibold
  static const TextStyle heading1 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );

  // Heading 2: 24, Semibold
  static const TextStyle heading2 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // Body 0: 18, Medium
  static const TextStyle body0 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  // Body 1: 16, Medium
  static const TextStyle body1 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  // Body 2: 14, Medium
  static const TextStyle body2 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  // Body 3: 12, Medium
  static const TextStyle body3 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );
}

