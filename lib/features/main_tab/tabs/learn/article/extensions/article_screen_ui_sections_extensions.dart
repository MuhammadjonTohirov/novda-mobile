import 'package:flutter/material.dart';

import '../../../../../../core/extensions/extensions.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../view_model/article_screen_view_model.dart';

extension ArticleScreenUiSectionsExtensions on BuildContext {
  Widget articleHeaderSection({
    required ArticleScreenViewModel viewModel,
    required VoidCallback onBackTap,
    required VoidCallback onBookmarkTap,
  }) {
    final colors = appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.arrow_back_rounded, size: 24, color: colors.textPrimary)
            .paddingOnly(right: 8, bottom: 8)
            .inkWell(onTap: onBackTap, borderRadius: BorderRadius.circular(16)),
        const SizedBox(height: 8),
        Text(
          viewModel.title,
          style: AppTypography.headingXL.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              l10n.learnReadMeta(
                viewModel.readingTime,
                _formatCompactCount(viewModel.viewCount),
              ),
              style: AppTypography.bodyLRegular.copyWith(
                color: colors.textSecondary,
              ),
            ).expanded(),
            if (viewModel.isBookmarkUpdating)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              SizedBox(
                width: 20,
                height: 20,
                child: Image.asset(
                  'assets/images/icon_bookmark_${viewModel.isSaved ? 'check' : 'add'}.png',
                ).sized(width: 20, height: 20),
              ).inkWell(
                onTap: onBookmarkTap,
                borderRadius: BorderRadius.circular(18),
              ),
          ],
        ),
      ],
    );
  }

  Widget articleHelpfulSection({required VoidCallback onHelpfulTap}) {
    final colors = appColors;

    return Column(
      children: [
        Text(
          l10n.articleHelpfulQuestion,
          style: AppTypography.headingM.copyWith(color: colors.textPrimary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                  'assets/images/icon_thumbs-up.png',
                  color: colors.accent,
                  width: 24,
                  height: 24,
                )
                .paddingOnly(right: 24)
                .inkWell(
                  onTap: onHelpfulTap,
                  borderRadius: BorderRadius.circular(18),
                ),
            Image.asset(
              'assets/images/icon_thumbs-down.png',
              color: colors.textSecondary,
              width: 24,
              height: 24,
            ).inkWell(
              onTap: onHelpfulTap,
              borderRadius: BorderRadius.circular(18),
            ),
          ],
        ),
      ],
    );
  }

  String _formatCompactCount(int count) {
    if (count >= 1000000) {
      final million = (count / 1000000).toStringAsFixed(
        count % 1000000 == 0 ? 0 : 1,
      );
      return '${_trimDecimalZero(million)}M';
    }

    if (count >= 1000) {
      final thousand = (count / 1000).toStringAsFixed(
        count % 1000 == 0 ? 0 : 1,
      );
      return '${_trimDecimalZero(thousand)}K';
    }

    return count.toString();
  }

  String _trimDecimalZero(String value) {
    if (!value.contains('.')) return value;
    return value.replaceFirst(RegExp(r'\.0$'), '');
  }
}
