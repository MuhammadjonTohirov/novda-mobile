import 'package:flutter/material.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/ui/ui.dart';

extension AddActionSheetContentUiStateExtensions on BuildContext {
  Widget addActionActivityTypesLoadingView() {
    return const CircularProgressIndicator().center();
  }

  Widget addActionActivityTypesErrorView({
    required String message,
    required VoidCallback onRetry,
  }) {
    final colors = appColors;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }

  Widget addActionActivityTypesEmptyView() {
    return Text(
      l10n.homeNoActivityTypes,
      style: AppTypography.bodyMRegular.copyWith(
        color: appColors.textSecondary,
      ),
      textAlign: TextAlign.center,
    ).center();
  }
}
