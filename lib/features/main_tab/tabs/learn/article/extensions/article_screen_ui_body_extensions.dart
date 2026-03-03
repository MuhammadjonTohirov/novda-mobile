import 'package:flutter/material.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../../core/extensions/extensions.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../extensions/learn_articles_ui_extensions.dart';
import '../view_model/article_screen_view_model.dart';
import 'article_screen_html_extensions.dart';
import 'article_screen_ui_sections_extensions.dart';

extension ArticleScreenUiBodyExtensions on BuildContext {
  static const _contentPadding = EdgeInsets.fromLTRB(16, 0, 16, 20);
  static const _heroImageHeight = 300.0;
  static const _similarItemGap = SizedBox(height: 12);

  Widget articleScreenBody({
    required ArticleScreenViewModel viewModel,
    required Future<void> Function() onRefresh,
    required VoidCallback onBackTap,
    required VoidCallback onBookmarkTap,
    required VoidCallback onHelpfulTap,
    required ValueChanged<ArticleListItem> onSimilarBookmarkTap,
    required ValueChanged<ArticleListItem> onSimilarArticleTap,
  }) {
    final colors = appColors;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: _contentPadding,
        children: [
          articleHeaderSection(
            viewModel: viewModel,
            onBackTap: onBackTap,
            onBookmarkTap: onBookmarkTap,
          ).safeArea(bottom: false),
          const SizedBox(height: 16),
          learnNetworkImage(
            imageUrl: viewModel.heroImageUrl,
            width: double.infinity,
            height: _heroImageHeight,
            borderRadius: BorderRadius.circular(24),
          ),
          const SizedBox(height: 12),
          articleHtmlContent(viewModel: viewModel),
          const SizedBox(height: 8),
          articleHelpfulSection(onHelpfulTap: onHelpfulTap),
          if (viewModel.similarArticles.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              l10n.articleContinueReading,
              style: AppTypography.headingS.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < viewModel.similarArticles.length; i++) ...[
              learnArticleCard(
                article: viewModel.similarArticles[i],
                isSaved: viewModel.isArticleSaved(viewModel.similarArticles[i]),
                isSaving: viewModel.isSavingArticle(
                  viewModel.similarArticles[i].slug,
                ),
                onBookmarkTap: () =>
                    onSimilarBookmarkTap(viewModel.similarArticles[i]),
                onTap: () => onSimilarArticleTap(viewModel.similarArticles[i]),
              ),
              if (i != viewModel.similarArticles.length - 1) _similarItemGap,
            ],
          ],
          const SizedBox(height: 20),
        ],
      ),
    ).container(color: colors.bgSecondary);
  }
}
