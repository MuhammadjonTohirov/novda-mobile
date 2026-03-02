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
  static const _modeAnimationDuration = Duration(milliseconds: 260);
  static const _contentAnimationDuration = Duration(milliseconds: 200);

  Widget learnTabBody({
    required LearnTabViewModel viewModel,
    required bool isSearchMode,
    required TextEditingController searchController,
    required FocusNode searchFocusNode,
    required Future<void> Function() onRefresh,
    required ValueChanged<String> onSearchChanged,
    required ValueChanged<String> onSearchSubmitted,
    required VoidCallback onSearchClear,
    required VoidCallback onSearchCancel,
    required ValueChanged<String> onRecentQueryTap,
    required ValueChanged<int> onRecentQueryDelete,
    required VoidCallback onSeeAllTap,
    required ValueChanged<Topic> onTopicTap,
    required ValueChanged<ArticleListItem> onBookmarkTap,
    required ValueChanged<ArticleListItem> onArticleTap,
  }) {
    final colors = appColors;
    final hasQuery = viewModel.query.isNotEmpty;

    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedSize(
              duration: _contentAnimationDuration,
              curve: Curves.easeOutCubic,
              child: isSearchMode
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.learnTab,
                          style: AppTypography.headingL.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
            ),
            learnSearchHeader(
              controller: searchController,
              focusNode: searchFocusNode,
              showCancelButton: isSearchMode,
              onChanged: onSearchChanged,
              onSubmitted: onSearchSubmitted,
              onTap: () => searchFocusNode.requestFocus(),
              onClear: onSearchClear,
              onCancel: onSearchCancel,
            ),
          ],
        ).paddingSymmetric(horizontal: 16).safeArea(bottom: false),
        const SizedBox(height: 16),
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              RefreshIndicator(
                onRefresh: onRefresh,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: _contentPadding,
                  children: [
                    if (viewModel.popularTopics.isNotEmpty)
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
              ),
              IgnorePointer(
                ignoring: !isSearchMode,
                child: AnimatedOpacity(
                  duration: _modeAnimationDuration,
                  curve: Curves.easeOutCubic,
                  opacity: isSearchMode ? 1 : 0,
                  child: _searchOverlayBody(
                    hasQuery: hasQuery,
                    viewModel: viewModel,
                    onRecentQueryTap: onRecentQueryTap,
                    onRecentQueryDelete: onRecentQueryDelete,
                    onBookmarkTap: onBookmarkTap,
                    onArticleTap: onArticleTap,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ).container(color: colors.bgSecondary);
  }

  Widget _searchOverlayBody({
    required bool hasQuery,
    required LearnTabViewModel viewModel,
    required ValueChanged<String> onRecentQueryTap,
    required ValueChanged<int> onRecentQueryDelete,
    required ValueChanged<ArticleListItem> onBookmarkTap,
    required ValueChanged<ArticleListItem> onArticleTap,
  }) {
    final colors = appColors;

    return Container(
      color: colors.bgSecondary,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: _contentPadding,
        children: [
          AnimatedSwitcher(
            duration: _contentAnimationDuration,
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: _learnFadeSlideTransition,
            child: KeyedSubtree(
              key: ValueKey(
                hasQuery
                    ? 'learn-search-overlay-results'
                    : 'learn-search-overlay-recent',
              ),
              child: hasQuery
                  ? learnSearchResultsSection(
                      viewModel: viewModel,
                      onBookmarkTap: onBookmarkTap,
                      onArticleTap: onArticleTap,
                    )
                  : learnRecentQueriesSection(
                      queries: viewModel.recentQueries,
                      onQueryTap: onRecentQueryTap,
                      onQueryDelete: onRecentQueryDelete,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _learnFadeSlideTransition(Widget child, Animation<double> animation) {
    final slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.02),
      end: Offset.zero,
    ).animate(animation);

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(position: slideAnimation, child: child),
    );
  }

  Widget learnSearchHeader({
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool showCancelButton,
    required ValueChanged<String> onChanged,
    required ValueChanged<String> onSubmitted,
    required VoidCallback onTap,
    required VoidCallback onClear,
    required VoidCallback onCancel,
  }) {
    final colors = appColors;

    return Row(
      children: [
        learnSearchField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          onTap: onTap,
          onClear: onClear,
        ).expanded(),
        AnimatedSwitcher(
          duration: _modeAnimationDuration,
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: _learnHeaderActionTransition,
          child: showCancelButton
              ? Row(
                  key: const ValueKey('learn-search-cancel-visible'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: onCancel,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        l10n.settingsCancel,
                        style: AppTypography.bodyLMedium.copyWith(
                          color: colors.accent,
                        ),
                      ),
                    ),
                  ],
                )
              : const SizedBox(key: ValueKey('learn-search-cancel-hidden')),
        ),
      ],
    );
  }

  Widget _learnHeaderActionTransition(
    Widget child,
    Animation<double> animation,
  ) {
    final slideAnimation = Tween<Offset>(
      begin: const Offset(0.18, 0),
      end: Offset.zero,
    ).animate(animation);

    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        axis: Axis.horizontal,
        axisAlignment: -1,
        child: SlideTransition(position: slideAnimation, child: child),
      ),
    );
  }

  Widget learnSearchField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required ValueChanged<String> onChanged,
    required ValueChanged<String> onSubmitted,
    required VoidCallback onTap,
    required VoidCallback onClear,
  }) {
    final colors = appColors;
    final hasValue = controller.text.trim().isNotEmpty;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      onTap: onTap,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      style: AppTypography.bodyLRegular.copyWith(color: colors.textPrimary),
      decoration: InputDecoration(
        hintText: l10n.learnSearchHint,
        hintStyle: AppTypography.bodyLRegular.copyWith(
          color: colors.textSecondary,
        ),
        prefixIcon: Icon(Icons.search_rounded, color: colors.textSecondary),
        suffixIcon: AnimatedSwitcher(
          duration: _contentAnimationDuration,
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: hasValue
              ? IconButton(
                  key: const ValueKey('learn-search-clear'),
                  onPressed: onClear,
                  icon: Icon(Icons.cancel_rounded, color: colors.textSecondary),
                )
              : const SizedBox(
                  key: ValueKey('learn-search-clear-empty'),
                  width: 48,
                  height: 48,
                ),
        ),
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
          borderSide: BorderSide(color: colors.border),
        ),
      ),
    );
  }

  Widget learnRecentQueriesSection({
    required List<String> queries,
    required ValueChanged<String> onQueryTap,
    required ValueChanged<int> onQueryDelete,
  }) {
    final colors = appColors;

    if (queries.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.learnRecentSearches,
          style: AppTypography.bodyMRegular.copyWith(
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: _contentAnimationDuration,
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: _learnFadeSlideTransition,
          child: Column(
            key: ValueKey('learn-recent-${queries.join('|')}'),
            children: [
              for (var i = 0; i < queries.length; i++) ...[
                learnRecentQueryTile(
                  query: queries[i],
                  onTap: () => onQueryTap(queries[i]),
                  onDelete: () => onQueryDelete(i),
                ),
                if (i != queries.length - 1) const SizedBox(height: 4),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget learnRecentQueryTile({
    required String query,
    required VoidCallback onTap,
    required VoidCallback onDelete,
  }) {
    final colors = appColors;

    return Row(
          children: [
            Icon(Icons.history_rounded, color: colors.textSecondary, size: 24),
            const SizedBox(width: 10),
            Text(
              query,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.headingS.copyWith(
                color: colors.textSecondary,
              ),
            ).expanded(),
            IconButton(
              onPressed: onDelete,
              icon: Icon(
                Icons.delete_outline_rounded,
                color: colors.textSecondary,
              ),
              tooltip: MaterialLocalizations.of(this).deleteButtonTooltip,
              visualDensity: VisualDensity.compact,
            ),
          ],
        )
        .paddingSymmetric(vertical: 4)
        .inkWell(onTap: onTap, borderRadius: BorderRadius.circular(12));
  }

  Widget learnSearchResultsSection({
    required LearnTabViewModel viewModel,
    required ValueChanged<ArticleListItem> onBookmarkTap,
    required ValueChanged<ArticleListItem> onArticleTap,
  }) {
    final colors = appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.learnSearchResults,
              style: AppTypography.headingM.copyWith(color: colors.textPrimary),
            ).expanded(),
            Text(
              l10n.learnSearchFoundCount(viewModel.articles.length),
              style: AppTypography.bodyLRegular.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (viewModel.articles.isEmpty)
          learnEmptyArticlesView()
        else
          learnArticlesList(
            viewModel: viewModel,
            onBookmarkTap: onBookmarkTap,
            onArticleTap: onArticleTap,
          ),
      ],
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
          learnArticlesList(
            viewModel: viewModel,
            onBookmarkTap: onBookmarkTap,
            onArticleTap: onArticleTap,
          ),
      ],
    );
  }

  Widget learnArticlesList({
    required LearnTabViewModel viewModel,
    required ValueChanged<ArticleListItem> onBookmarkTap,
    required ValueChanged<ArticleListItem> onArticleTap,
  }) {
    return Column(
      children: [
        for (var i = 0; i < viewModel.articles.length; i++) ...[
          learnArticleCard(
            article: viewModel.articles[i],
            isSaved: viewModel.isArticleSaved(viewModel.articles[i]),
            isSaving: viewModel.isSavingArticle(viewModel.articles[i].slug),
            onBookmarkTap: () => onBookmarkTap(viewModel.articles[i]),
            onTap: () => onArticleTap(viewModel.articles[i]),
          ),
          if (i != viewModel.articles.length - 1) _itemGap,
        ],
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
