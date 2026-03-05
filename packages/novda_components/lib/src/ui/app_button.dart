import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum AppButtonVariant { submit, cancel, delete }

/// Primary button component
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.variant = AppButtonVariant.submit,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final AppButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final style = _resolveStyle(colors);

    return SizedBox(
      width: width ?? double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: style.backgroundColor,
          foregroundColor: style.foregroundColor,
          disabledBackgroundColor: style.disabledBackgroundColor,
          disabledForegroundColor: style.disabledForegroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: style.progressColor,
                ),
              )
            : Text(
                text,
                style: AppTypography.bodyLMedium.copyWith(
                  color: isEnabled
                      ? style.foregroundColor
                      : style.disabledForegroundColor,
                ),
              ),
      ),
    );
  }

  ({
    Color backgroundColor,
    Color foregroundColor,
    Color disabledBackgroundColor,
    Color disabledForegroundColor,
    Color progressColor,
  })
  _resolveStyle(AppColorScheme colors) {
    return switch (variant) {
      AppButtonVariant.submit => (
        backgroundColor: colors.buttonPrimary,
        foregroundColor: colors.textOnPrimary,
        disabledBackgroundColor: colors.buttonDisabled,
        disabledForegroundColor: colors.textSecondary,
        progressColor: colors.textOnPrimary,
      ),
      AppButtonVariant.cancel => (
        backgroundColor: colors.bgSecondary,
        foregroundColor: colors.textPrimary,
        disabledBackgroundColor: colors.buttonDisabled,
        disabledForegroundColor: colors.textSecondary,
        progressColor: colors.textPrimary,
      ),
      AppButtonVariant.delete => (
        backgroundColor: colors.error,
        foregroundColor: Colors.white,
        disabledBackgroundColor: colors.buttonDisabled,
        disabledForegroundColor: colors.textSecondary,
        progressColor: Colors.white,
      ),
    };
  }
}

/// Text-only button component
class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return TextButton(
      onPressed: isEnabled ? onPressed : null,
      child: Text(
        text,
        style: AppTypography.bodyMMedium.copyWith(
          color: isEnabled ? colors.textOnly : colors.textSecondary,
        ),
      ),
    );
  }
}
