import 'package:flutter/material.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/ui/ui.dart';

extension ProgressTabUiErrorExtensions on BuildContext {
  Widget progressLoadErrorView({
    required String message,
    required VoidCallback onRetry,
  }) {
    final colors = appColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message,
          style: AppTypography.bodyMRegular.copyWith(
            color: colors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        AppTextButton(text: l10n.homeRetry, onPressed: onRetry),
      ],
    ).paddingAll(24).center();
  }
}
