import 'package:flutter/material.dart';

/// Typography styles based on Geist font from design tokens
abstract final class AppTypography {
  static const String _fontFamily = 'Geist';

  // Heading styles - Geist Medium
  static const TextStyle headingXL = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 28,
    height: 32 / 28,
  );

  static const TextStyle headingL = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 24,
    height: 28 / 24,
  );

  static const TextStyle headingM = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 20,
    height: 24 / 20,
  );

  static const TextStyle headingS = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 20 / 16,
  );

  static const TextStyle headingXS = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 20 / 14,
  );

  static const TextStyle headingXXS = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 16 / 12,
  );

  // Body Large styles
  static const TextStyle bodyLRegular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 24 / 16,
  );

  static const TextStyle bodyLMedium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 24 / 16,
  );

  static const TextStyle bodyLSemiBold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 24 / 16,
  );

  // Body Medium styles
  static const TextStyle bodyMRegular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 20 / 14,
  );

  static const TextStyle bodyMMedium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 20 / 14,
  );

  static const TextStyle bodyMSemiBold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    height: 20 / 14,
  );

  // Body Small styles
  static const TextStyle bodySRegular = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 16 / 12,
  );

  static const TextStyle bodySMedium = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 16 / 12,
  );

  static const TextStyle bodySSemiBold = TextStyle(
    fontFamily: _fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 12,
    height: 16 / 12,
  );
}
