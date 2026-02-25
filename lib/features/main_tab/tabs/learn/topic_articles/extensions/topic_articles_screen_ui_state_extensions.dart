import 'package:flutter/material.dart';

import '../../../../../../core/extensions/extensions.dart';
import '../../../../../../core/theme/app_theme.dart';

extension TopicArticlesScreenUiStateExtensions on BuildContext {
  Widget topicArticlesLoadErrorView({
    required String message,
    required VoidCallback onRetry,
  }) {
    final colors = appColors;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline_rounded, size: 34, color: colors.error),
        const SizedBox(height: 10),
        Text(
          message,
          textAlign: TextAlign.center,
          style: AppTypography.bodyMRegular.copyWith(
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(onPressed: onRetry, child: Text(l10n.homeRetry)),
      ],
    ).paddingSymmetric(horizontal: 20).center().safeArea();
  }

  Widget topicArticlesEmptyView() {
    final colors = appColors;

    return Text(
      l10n.learnNoArticles,
      style: AppTypography.bodyMRegular.copyWith(color: colors.textSecondary),
      textAlign: TextAlign.center,
    ).paddingSymmetric(vertical: 24).center();
  }
}
