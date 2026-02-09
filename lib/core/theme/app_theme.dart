import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

export 'app_colors.dart';
export 'app_typography.dart';

/// Theme variant type
enum ThemeVariant { warmOrange, softBlue, gray }

/// Extension to access AppColorScheme from ThemeVariant
extension ThemeVariantExtension on ThemeVariant {
  AppColorScheme get colorScheme {
    return switch (this) {
      ThemeVariant.warmOrange => AppColorScheme.warmOrange,
      ThemeVariant.softBlue => AppColorScheme.softBlue,
      ThemeVariant.gray => AppColorScheme.gray,
    };
  }
}

/// App theme configuration
class AppTheme {
  const AppTheme._();

  static ThemeData create(ThemeVariant variant) {
    final colors = variant.colorScheme;

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Geist',
      brightness: Brightness.light,
      scaffoldBackgroundColor: colors.bgPrimary,
      colorScheme: ColorScheme.light(
        primary: colors.accent,
        onPrimary: colors.textOnPrimary,
        secondary: colors.bgSoft,
        onSecondary: colors.textPrimary,
        surface: colors.bgPrimary,
        onSurface: colors.textPrimary,
        error: colors.error,
        onError: AppColorPrimitives.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.bgPrimary,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.headingS.copyWith(
          color: colors.textPrimary,
        ),
      ),
      textTheme: _createTextTheme(colors),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.buttonPrimary,
          foregroundColor: colors.textOnPrimary,
          disabledBackgroundColor: colors.buttonDisabled,
          disabledForegroundColor: colors.textSecondary,
          textStyle: AppTypography.bodyLMedium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.textOnly,
          textStyle: AppTypography.bodyMMedium,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.textPrimary,
          side: BorderSide(color: colors.border),
          textStyle: AppTypography.bodyMMedium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.bgSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.error, width: 2),
        ),
        labelStyle: AppTypography.bodyMRegular.copyWith(
          color: colors.textSecondary,
        ),
        hintStyle: AppTypography.bodyMRegular.copyWith(
          color: colors.textSecondary,
        ),
        errorStyle: AppTypography.bodySRegular.copyWith(
          color: colors.error,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.bgPrimary,
        selectedItemColor: colors.tabActive,
        unselectedItemColor: colors.tabDisabled,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: AppTypography.bodySMedium,
        unselectedLabelStyle: AppTypography.bodySRegular,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: colors.tabActive,
        unselectedLabelColor: colors.tabDisabled,
        indicatorColor: colors.tabActive,
        labelStyle: AppTypography.bodyMMedium,
        unselectedLabelStyle: AppTypography.bodyMRegular,
      ),
      dividerTheme: DividerThemeData(
        color: colors.border,
        thickness: 1,
      ),
      cardTheme: CardThemeData(
        color: colors.bgPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colors.border),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.accent,
        linearTrackColor: colors.bgBarOnProgress,
      ),
    );
  }

  static CupertinoThemeData createCupertino(ThemeVariant variant) {
    final colors = variant.colorScheme;

    return CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: colors.accent,
      primaryContrastingColor: colors.textOnPrimary,
      barBackgroundColor: colors.bgPrimary,
      scaffoldBackgroundColor: colors.bgPrimary,
      textTheme: CupertinoTextThemeData(
        primaryColor: colors.accent,
        textStyle:
            AppTypography.bodyMRegular.copyWith(color: colors.textPrimary),
        actionTextStyle:
            AppTypography.bodyLMedium.copyWith(color: colors.accent),
        tabLabelTextStyle: AppTypography.headingXXS,
        navTitleTextStyle:
            AppTypography.headingS.copyWith(color: colors.textPrimary),
        navLargeTitleTextStyle:
            AppTypography.headingL.copyWith(color: colors.textPrimary),
        pickerTextStyle:
            AppTypography.bodyMRegular.copyWith(color: colors.textPrimary),
        dateTimePickerTextStyle:
            AppTypography.bodyMRegular.copyWith(color: colors.textPrimary),
      ),
    );
  }

  static TextTheme _createTextTheme(AppColorScheme colors) {
    return TextTheme(
      displayLarge: AppTypography.headingXL.copyWith(color: colors.textPrimary),
      displayMedium: AppTypography.headingL.copyWith(color: colors.textPrimary),
      displaySmall: AppTypography.headingM.copyWith(color: colors.textPrimary),
      headlineLarge: AppTypography.headingL.copyWith(color: colors.textPrimary),
      headlineMedium:
          AppTypography.headingM.copyWith(color: colors.textPrimary),
      headlineSmall: AppTypography.headingS.copyWith(color: colors.textPrimary),
      titleLarge: AppTypography.headingS.copyWith(color: colors.textPrimary),
      titleMedium: AppTypography.headingXS.copyWith(color: colors.textPrimary),
      titleSmall: AppTypography.headingXXS.copyWith(color: colors.textPrimary),
      bodyLarge: AppTypography.bodyLRegular.copyWith(color: colors.textPrimary),
      bodyMedium:
          AppTypography.bodyMRegular.copyWith(color: colors.textPrimary),
      bodySmall: AppTypography.bodySRegular.copyWith(color: colors.textPrimary),
      labelLarge: AppTypography.bodyLMedium.copyWith(color: colors.textPrimary),
      labelMedium:
          AppTypography.bodyMMedium.copyWith(color: colors.textPrimary),
      labelSmall: AppTypography.bodySMedium.copyWith(color: colors.textPrimary),
    );
  }
}

/// InheritedWidget to provide AppColorScheme down the widget tree
class AppThemeProvider extends InheritedWidget {
  const AppThemeProvider({
    super.key,
    required this.colorScheme,
    required super.child,
  });

  final AppColorScheme colorScheme;

  static AppColorScheme of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AppThemeProvider>();
    return provider?.colorScheme ?? AppColorScheme.warmOrange;
  }

  @override
  bool updateShouldNotify(AppThemeProvider oldWidget) {
    return colorScheme != oldWidget.colorScheme;
  }
}

/// Extension on BuildContext for easy access to AppColorScheme
extension AppThemeContextExtension on BuildContext {
  AppColorScheme get appColors => AppThemeProvider.of(this);
}
