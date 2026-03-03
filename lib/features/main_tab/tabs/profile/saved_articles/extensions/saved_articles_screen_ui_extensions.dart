import 'package:flutter/material.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../../core/extensions/extensions.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../learn/extensions/learn_articles_ui_extensions.dart';
import '../view_model/saved_articles_view_model.dart';
import 'saved_articles_screen_ui_state_extensions.dart';

extension SavedArticlesScreenUiExtensions on BuildContext {
  static const _contentPadding = EdgeInsets.fromLTRB(16, 0, 16, 20);
  static const _itemGap = SizedBox(height: 12);

  Widget savedArticlesScreenBody({
    required SavedArticlesViewModel viewModel,
    required Future<void> Function() onRefresh,
    required VoidCallback onBackTap,
    required ValueChanged<ArticleListItem> onBookmarkTap,
    required ValueChanged<ArticleListItem> onArticleTap,
  }) {
    final colors = appColors;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: _contentPadding,
        children: [
          _savedArticlesHeader(onBackTap: onBackTap).safeArea(bottom: false),
          const SizedBox(height: 16),
          if (viewModel.articles.isEmpty)
            savedArticlesEmptyView()
          else
            Column(
              children: [
                for (var i = 0; i < viewModel.articles.length; i++) ...[
                  learnArticleCard(
                    article: viewModel.articles[i],
                    isSaved: true,
                    isSaving: viewModel.isSavingArticle(
                      viewModel.articles[i].slug,
                    ),
                    onBookmarkTap: () => onBookmarkTap(viewModel.articles[i]),
                    onTap: () => onArticleTap(viewModel.articles[i]),
                  ),
                  if (i != viewModel.articles.length - 1) _itemGap,
                ],
              ],
            ),
        ],
      ),
    ).container(color: colors.bgSecondary);
  }

  Widget _savedArticlesHeader({required VoidCallback onBackTap}) {
    final colors = appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.arrow_back_rounded, size: 24, color: colors.textPrimary)
            .paddingOnly(right: 8, bottom: 8)
            .inkWell(onTap: onBackTap, borderRadius: BorderRadius.circular(20)),
        const SizedBox(height: 8),
        Text(
          l10n.profileSavedArticles,
          style: AppTypography.headingL.copyWith(color: colors.textPrimary),
        ),
      ],
    );
  }
}
