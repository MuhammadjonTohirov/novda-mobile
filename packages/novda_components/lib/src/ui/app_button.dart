import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Primary button component
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SizedBox(
      width: width ?? double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.buttonPrimary,
          foregroundColor: colors.textOnPrimary,
          disabledBackgroundColor: colors.buttonDisabled,
          disabledForegroundColor: colors.textSecondary,
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
                  color: colors.textOnPrimary,
                ),
              )
            : Text(
                text,
                style: AppTypography.bodyLMedium.copyWith(
                  color: isEnabled
                      ? colors.textOnPrimary
                      : colors.textSecondary,
                ),
              ),
      ),
    );
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
