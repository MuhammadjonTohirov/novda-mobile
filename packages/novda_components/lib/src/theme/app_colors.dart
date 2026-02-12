import 'package:flutter/material.dart';

/// Color primitives extracted from design tokens
abstract final class AppColorPrimitives {
  // Green
  static const Color green50 = Color(0xFFF2F8F2);
  static const Color green100 = Color(0xFFD6EBD6);
  static const Color green200 = Color(0xFFB9DFB9);
  static const Color green300 = Color(0xFF9CD39C);
  static const Color green400 = Color(0xFF7FC87F);
  static const Color green500 = Color(0xFF62BC62);
  static const Color green600 = Color(0xFF49AB49);
  static const Color green700 = Color(0xFF3E8E3E);
  static const Color green800 = Color(0xFF347034);
  static const Color green900 = Color(0xFF1C3329);

  // Greyscale
  static const Color grey50 = Color(0xFFF5F5F5);
  static const Color grey100 = Color(0xFFE0E0E0);
  static const Color grey200 = Color(0xFFCCCCCC);
  static const Color grey300 = Color(0xFFB8B8B8);
  static const Color grey400 = Color(0xFFA3A3A3);
  static const Color grey500 = Color(0xFF8F8F8F);
  static const Color grey600 = Color(0xFF707070);
  static const Color grey700 = Color(0xFF464649);
  static const Color grey800 = Color(0xFF2C2C2E);
  static const Color grey900 = Color(0xFF222225);

  // Neutral
  static const Color dark = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  // Orange
  static const Color orange50 = Color(0xFFFCF5EE);
  static const Color orange100 = Color(0xFFF8E1C9);
  static const Color orange200 = Color(0xFFF6CCA2);
  static const Color orange300 = Color(0xFFF5B87A);
  static const Color orange400 = Color(0xFFF5A451);
  static const Color orange500 = Color(0xFFF59029);
  static const Color orange600 = Color(0xFFE97B0C);
  static const Color orange700 = Color(0xFFC0670C);
  static const Color orange800 = Color(0xFF95520E);
  static const Color orange900 = Color(0xFF332516);

  // Primary (Blue)
  static const Color primary50 = Color(0xFFEDF4FC);
  static const Color primary100 = Color(0xFFC8DDF9);
  static const Color primary200 = Color(0xFF9FC6F9);
  static const Color primary300 = Color(0xFF76AFF9);
  static const Color primary400 = Color(0xFF4C98FB);
  static const Color primary500 = Color(0xFF2281FB);
  static const Color primary600 = Color(0xFF056BF0);
  static const Color primary700 = Color(0xFF014398);
  static const Color primary800 = Color(0xFF01377D);
  static const Color primary900 = Color(0xFF1C2B41);

  // Red
  static const Color red50 = Color(0xFFFCEEED);
  static const Color red100 = Color(0xFFFACAC7);
  static const Color red200 = Color(0xFFF9A49F);
  static const Color red300 = Color(0xFFFA7C75);
  static const Color red400 = Color(0xFFFC544A);
  static const Color red500 = Color(0xFFFD2C21);
  static const Color red600 = Color(0xFFF21003);
  static const Color red700 = Color(0xFFC70F05);
  static const Color red800 = Color(0xFF9B1008);
  static const Color red900 = Color(0xFF331716);

  // Yellow
  static const Color yellow50 = Color(0xFFFCF8EE);
  static const Color yellow100 = Color(0xFFF7EDCA);
  static const Color yellow200 = Color(0xFFF5E2A3);
  static const Color yellow300 = Color(0xFFF3D87C);
  static const Color yellow400 = Color(0xFFF3CE54);
  static const Color yellow500 = Color(0xFFF2C42C);
  static const Color yellow600 = Color(0xFFE6B40F);
  static const Color yellow700 = Color(0xFFBD950F);
  static const Color yellow800 = Color(0xFF937510);
  static const Color yellow900 = Color(0xFF6A5511);

  // Fills (with opacity)
  static const Color fillOpacity8 = Color(0x14747480);
  static const Color fillOpacity12 = Color(0x1F747480);
  static const Color fillOpacity16 = Color(0x29747480);
  static const Color fillOpacity20 = Color(0x33747480);

  // Fills Dark (with opacity)
  static const Color fillDarkOpacity8 = Color(0x2E747480);
  static const Color fillDarkOpacity12 = Color(0x3D747480);
  static const Color fillDarkOpacity16 = Color(0x52747480);
  static const Color fillDarkOpacity20 = Color(0x5C747480);

  // Semantic colors from tokens
  static const Color error = Color(0xFFE51C00);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color border = Color(0xFFEEEEEE);
  static const Color tabDisabled = Color(0xFF9E9E9E);
}

/// Theme variant colors for warm orange theme
abstract final class WarmOrangeColors {
  static const Color accent = Color(0xFFC65038);
  static const Color border = Color(0xFFEEEEEE);
  static const Color bgBarOnProgress = Color(0xFFEEADA0);
  static const Color bgPrimary = Color(0xFFFFFFFF);
  static const Color bgSecondary = Color(0xFFF5F5F5);
  static const Color bgSoft = Color(0xFFF6D2CB);
  static const Color buttonDisabled = Color(0xFFF5F5F5);
  static const Color buttonPressing = Color(0xFFEEADA0);
  static const Color buttonPrimary = Color(0xFFF6D2CB);
  static const Color iconBoy = Color(0xFF4C73C8);
  static const Color iconGirl = Color(0xFFDE634A);
  static const Color tabActive = Color(0xFFC65038);
  static const Color tabDisabled = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Color(0xFF4E190E);
  static const Color textOnly = Color(0xFFC65038);
}

/// Theme variant colors for soft blue theme
abstract final class SoftBlueColors {
  static const Color accent = Color(0xFF4C73C8);
  static const Color border = Color(0xFFEEEEEE);
  static const Color bgBarOnProgress = Color(0xFFB7C7E9);
  static const Color bgPrimary = Color(0xFFFFFFFF);
  static const Color bgSecondary = Color(0xFFF5F5F5);
  static const Color bgSoft = Color(0xFFDBE3F4);
  static const Color buttonDisabled = Color(0xFFF5F5F5);
  static const Color buttonPressing = Color(0xFFB7C7E9);
  static const Color buttonPrimary = Color(0xFFC9D5EF);
  static const Color iconBoy = Color(0xFF4C73C8);
  static const Color iconGirl = Color(0xFFDE634A);
  static const Color tabActive = Color(0xFF4C73C8);
  static const Color tabDisabled = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Color(0xFF1E2E50);
  static const Color textOnly = Color(0xFF4C73C8);
}

/// Theme variant colors for gray theme
abstract final class GrayColors {
  static const Color accent = Color(0xFF212121);
  static const Color border = Color(0xFFEEEEEE);
  static const Color bgBarOnProgress = Color(0xFF212121);
  static const Color bgPrimary = Color(0xFFFFFFFF);
  static const Color bgSecondary = Color(0xFFF5F5F5);
  static const Color bgSoft = Color(0xFFEEEEEE);
  static const Color buttonDisabled = Color(0xFFF5F5F5);
  static const Color buttonPressing = Color(0xFF424242);
  static const Color buttonPrimary = Color(0xFF212121);
  static const Color iconBoy = Color(0xFF4C73C8);
  static const Color iconGirl = Color(0xFFDE634A);
  static const Color tabActive = Color(0xFF212121);
  static const Color tabDisabled = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnly = Color(0xFF212121);
}

/// App color scheme that can be themed
class AppColorScheme {
  const AppColorScheme({
    required this.accent,
    required this.border,
    required this.bgBarOnProgress,
    required this.bgPrimary,
    required this.bgSecondary,
    required this.bgSoft,
    required this.buttonDisabled,
    required this.buttonPressing,
    required this.buttonPrimary,
    required this.iconBoy,
    required this.iconGirl,
    required this.tabActive,
    required this.tabDisabled,
    required this.textOnPrimary,
    required this.textOnly,
    required this.textPrimary,
    required this.textSecondary,
    required this.error,
  });

  final Color accent;
  final Color border;
  final Color bgBarOnProgress;
  final Color bgPrimary;
  final Color bgSecondary;
  final Color bgSoft;
  final Color buttonDisabled;
  final Color buttonPressing;
  final Color buttonPrimary;
  final Color iconBoy;
  final Color iconGirl;
  final Color tabActive;
  final Color tabDisabled;
  final Color textOnPrimary;
  final Color textOnly;
  final Color textPrimary;
  final Color textSecondary;
  final Color error;

  static const warmOrange = AppColorScheme(
    accent: WarmOrangeColors.accent,
    border: WarmOrangeColors.border,
    bgBarOnProgress: WarmOrangeColors.bgBarOnProgress,
    bgPrimary: WarmOrangeColors.bgPrimary,
    bgSecondary: WarmOrangeColors.bgSecondary,
    bgSoft: WarmOrangeColors.bgSoft,
    buttonDisabled: WarmOrangeColors.buttonDisabled,
    buttonPressing: WarmOrangeColors.buttonPressing,
    buttonPrimary: WarmOrangeColors.buttonPrimary,
    iconBoy: WarmOrangeColors.iconBoy,
    iconGirl: WarmOrangeColors.iconGirl,
    tabActive: WarmOrangeColors.tabActive,
    tabDisabled: WarmOrangeColors.tabDisabled,
    textOnPrimary: WarmOrangeColors.textOnPrimary,
    textOnly: WarmOrangeColors.textOnly,
    textPrimary: AppColorPrimitives.textPrimary,
    textSecondary: AppColorPrimitives.textSecondary,
    error: AppColorPrimitives.error,
  );

  static const softBlue = AppColorScheme(
    accent: SoftBlueColors.accent,
    border: SoftBlueColors.border,
    bgBarOnProgress: SoftBlueColors.bgBarOnProgress,
    bgPrimary: SoftBlueColors.bgPrimary,
    bgSecondary: SoftBlueColors.bgSecondary,
    bgSoft: SoftBlueColors.bgSoft,
    buttonDisabled: SoftBlueColors.buttonDisabled,
    buttonPressing: SoftBlueColors.buttonPressing,
    buttonPrimary: SoftBlueColors.buttonPrimary,
    iconBoy: SoftBlueColors.iconBoy,
    iconGirl: SoftBlueColors.iconGirl,
    tabActive: SoftBlueColors.tabActive,
    tabDisabled: SoftBlueColors.tabDisabled,
    textOnPrimary: SoftBlueColors.textOnPrimary,
    textOnly: SoftBlueColors.textOnly,
    textPrimary: AppColorPrimitives.textPrimary,
    textSecondary: AppColorPrimitives.textSecondary,
    error: AppColorPrimitives.error,
  );

  static const gray = AppColorScheme(
    accent: GrayColors.accent,
    border: GrayColors.border,
    bgBarOnProgress: GrayColors.bgBarOnProgress,
    bgPrimary: GrayColors.bgPrimary,
    bgSecondary: GrayColors.bgSecondary,
    bgSoft: GrayColors.bgSoft,
    buttonDisabled: GrayColors.buttonDisabled,
    buttonPressing: GrayColors.buttonPressing,
    buttonPrimary: GrayColors.buttonPrimary,
    iconBoy: GrayColors.iconBoy,
    iconGirl: GrayColors.iconGirl,
    tabActive: GrayColors.tabActive,
    tabDisabled: GrayColors.tabDisabled,
    textOnPrimary: GrayColors.textOnPrimary,
    textOnly: GrayColors.textOnly,
    textPrimary: AppColorPrimitives.textPrimary,
    textSecondary: AppColorPrimitives.textSecondary,
    error: AppColorPrimitives.error,
  );
}
