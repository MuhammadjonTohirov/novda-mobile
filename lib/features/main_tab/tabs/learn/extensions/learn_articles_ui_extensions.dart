import 'package:flutter/material.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';

extension LearnArticlesUiExtensions on BuildContext {
  Widget learnArticleCard({
    required ArticleListItem article,
    required bool isSaved,
    required bool isSaving,
    required VoidCallback onBookmarkTap,
    required VoidCallback onTap,
  }) {
    final colors = appColors;

    return Column(
          spacing: 16,
          children: [
            Row(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  article.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.headingS.copyWith(
                    color: colors.textPrimary,
                  ),
                ).expanded(flex: 1),

                learnNetworkImage(
                  imageUrl: article.heroImageUrl,
                  width: 116,
                  height: 84,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.learnReadMeta(
                    article.readingTime,
                    _formatCompactCount(article.viewCount),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyMRegular.copyWith(
                    color: colors.textSecondary,
                  ),
                ),

                SizedBox(
                  width: 20,
                  height: 20,
                  child: isSaving
                      ? const CircularProgressIndicator(strokeWidth: 2.2)
                      : Image.asset('assets/images/icon_bookmark_${isSaved ? 'check' : 'add'}.png').sized(width: 20, height: 20),
                ),
              ],
            ).inkWell(
              onTap: onBookmarkTap,
              borderRadius: BorderRadius.circular(16),
            ),
          ],
        )
        .container(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
          decoration: BoxDecoration(
            color: colors.bgPrimary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.border),
          ),
        )
        .inkWell(onTap: onTap, borderRadius: BorderRadius.circular(20));
  }

  Widget learnNetworkImage({
    required String imageUrl,
    required double width,
    required double height,
    BorderRadius? borderRadius,
    IconData fallbackIcon = Icons.image_outlined,
  }) {
    final colors = appColors;

    final fallback = Icon(fallbackIcon, color: colors.textSecondary, size: 24)
        .center()
        .container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: colors.bgSoft,
            borderRadius: borderRadius,
          ),
        );

    if (imageUrl.trim().isEmpty) {
      return fallback;
    }

    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => fallback,
      loadingBuilder: (_, child, progress) {
        if (progress == null) {
          return child;
        }
        return fallback;
      },
    ).clipRRect(borderRadius: borderRadius ?? BorderRadius.zero);
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
