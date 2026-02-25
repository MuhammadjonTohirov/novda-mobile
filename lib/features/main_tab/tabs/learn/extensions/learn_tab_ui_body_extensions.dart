import 'package:flutter/material.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import 'learn_articles_ui_extensions.dart';
import '../view_model/learn_tab_view_model.dart';
import 'learn_tab_ui_state_extensions.dart';

extension LearnTabUiBodyExtensions on BuildContext {
  static const _contentPadding = EdgeInsets.fromLTRB(16, 0, 16, 20);
  static const _sectionGap = SizedBox(height: 24);
  static const _itemGap = SizedBox(height: 12);

  Widget learnTabBody({
    required LearnTabViewModel viewModel,
    required Future<void> Function() onRefresh,
    required ValueChanged<String> onSearchChanged,
    required VoidCallback onSeeAllTap,
    required ValueChanged<Topic> onTopicTap,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.learnTab,
                style: AppTypography.headingL.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              learnSearchField(
                initialValue: viewModel.query,
                onChanged: onSearchChanged,
              ),
            ],
          ).safeArea(bottom: false),
          _sectionGap,
          if (viewModel.popularTopics.isNotEmpty && viewModel.query.isEmpty)
            learnPopularTopicsSection(
              viewModel: viewModel,
              onSeeAllTap: onSeeAllTap,
              onTopicTap: onTopicTap,
            ),
          if (viewModel.popularTopics.isNotEmpty) _sectionGap,
          learnArticlesSection(
            viewModel: viewModel,
            onBookmarkTap: onBookmarkTap,
            onArticleTap: onArticleTap,
          ),
        ],
      ),
    ).container(color: colors.bgSecondary);
  }

  Widget learnSearchField({
    required String initialValue,
    required ValueChanged<String> onChanged,
  }) {
    final colors = appColors;

    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      style: AppTypography.bodyLRegular.copyWith(color: colors.textPrimary),
      decoration: InputDecoration(
        hintText: l10n.learnSearchHint,
        hintStyle: AppTypography.bodyLRegular.copyWith(
          color: colors.textSecondary,
        ),
        prefixIcon: Icon(Icons.search_rounded, color: colors.textSecondary),
        fillColor: colors.bgPrimary,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.accent.withValues(alpha: 0.5)),
        ),
      ),
    );
  }

  Widget learnPopularTopicsSection({
    required LearnTabViewModel viewModel,
    required VoidCallback onSeeAllTap,
    required ValueChanged<Topic> onTopicTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        learnSectionHeader(
          title: l10n.learnPopularTopics,
          actionTitle: l10n.homeSeeAll,
          onActionTap: onSeeAllTap,
        ),
        const SizedBox(height: 12),
        GridView.builder(
          itemCount: viewModel.popularTopics.length,
          shrinkWrap: true,
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.72,
            mainAxisExtent: 156,
          ),
          itemBuilder: (_, index) {
            final topic = viewModel.popularTopics[index];
            final topicSlug = topic.slug;

            return learnTopicCard(
              topic: topic,
              articleCount: viewModel.topicArticleCount(topicSlug),
              onTap: () => onTopicTap(topic),
            );
          },
        ),
      ],
    );
  }

  Widget learnArticlesSection({
    required LearnTabViewModel viewModel,
    required ValueChanged<ArticleListItem> onBookmarkTap,
    required ValueChanged<ArticleListItem> onArticleTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.learnAllArticles,
          style: AppTypography.headingS.copyWith(color: appColors.textPrimary),
        ),
        const SizedBox(height: 12),
        if (viewModel.articles.isEmpty)
          learnEmptyArticlesView()
        else
          Column(
            children: [
              for (var i = 0; i < viewModel.articles.length; i++) ...[
                learnArticleCard(
                  article: viewModel.articles[i],
                  isSaved: viewModel.isArticleSaved(viewModel.articles[i]),
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
    );
  }

  Widget learnSectionHeader({
    required String title,
    required String actionTitle,
    required VoidCallback onActionTap,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: AppTypography.headingS.copyWith(color: appColors.textPrimary),
        ).expanded(),
        TextButton(
          onPressed: onActionTap,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            actionTitle,
            style: AppTypography.bodyLMedium.copyWith(color: appColors.accent),
          ),
        ),
      ],
    );
  }

  Widget learnTopicCard({
    required Topic topic,
    required int articleCount,
    required VoidCallback onTap,
  }) {
    final colors = appColors;

    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            learnNetworkImage(
              imageUrl: topic.coverImageUrl,
              width: double.infinity,
              height: 90,
              borderRadius: BorderRadius.circular(16),
              fallbackIcon: Icons.auto_stories_outlined,
            ),
            const SizedBox(height: 8),
            Text(
              topic.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.headingS.copyWith(color: colors.textPrimary),
            ).paddingOnly(left: 8, right: 4),
            const SizedBox(height: 4),
            Text(
              l10n.learnTopicArticlesCount(articleCount),
              style: AppTypography.bodyMRegular.copyWith(
                color: colors.textSecondary,
              ),
              maxLines: 1,
            ).paddingOnly(left: 8, right: 4),
          ],
        )
        .container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: colors.bgPrimary,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: colors.border),
            boxShadow: [
              BoxShadow(
                color: colors.textPrimary.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        )
        .inkWell(onTap: onTap, borderRadius: BorderRadius.circular(20));
  }
}
