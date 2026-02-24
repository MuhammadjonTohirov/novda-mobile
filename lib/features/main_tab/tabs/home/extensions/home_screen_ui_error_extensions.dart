import 'package:flutter/material.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';

extension HomeScreenUiErrorExtensions on BuildContext {
  Widget homeLoadErrorView({required VoidCallback onRetry}) {
    final colors = appColors;
    final l10n = this.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.homeFailedLoad,
          style: AppTypography.bodyMRegular.copyWith(
            color: colors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: onRetry, child: Text(l10n.homeRetry)),
      ],
    ).paddingAll(24).center();
  }
}
