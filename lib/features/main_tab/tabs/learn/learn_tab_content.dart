import 'package:flutter/material.dart';
import 'package:novda_sdk/novda_sdk.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/extensions.dart';
import 'all_topics/all_topics_screen.dart';
import 'article/article_screen.dart';
import 'extensions/learn_tab_ui_extensions.dart';
import 'interactor/learn_tab_interactor.dart';
import 'topic_articles/topic_articles_screen.dart';
import 'view_model/learn_tab_view_model.dart';

class LearnTabContent extends StatefulWidget {
  const LearnTabContent({super.key});

  @override
  State<LearnTabContent> createState() => _LearnTabContentState();
}

class _LearnTabContentState extends State<LearnTabContent> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;
  VoidCallback? _onSearchBlur;
  bool _isSearchMode = false;
  bool _hadSearchFocus = false;

  bool get _hasSearchText => _searchController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    _hadSearchFocus = _searchFocusNode.hasFocus;
    _searchController.addListener(_onSearchUiChanged);
    _searchFocusNode.addListener(_onSearchUiChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchUiChanged);
    _searchFocusNode.removeListener(_onSearchUiChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchUiChanged() {
    if (!mounted) return;

    final hasFocus = _searchFocusNode.hasFocus;
    if (_hadSearchFocus && !hasFocus) {
      _onSearchBlur?.call();
    }
    _hadSearchFocus = hasFocus;

    final isSearchMode = hasFocus || _hasSearchText;
    if (_isSearchMode == isSearchMode) return;

    setState(() => _isSearchMode = isSearchMode);
  }

  void _onSearchChanged(LearnTabViewModel viewModel, String value) {
    viewModel.searchArticles(value);
  }

  void _onSearchSubmitted(LearnTabViewModel viewModel, String value) {
    viewModel.submitSearch(value);
  }

  void _onSearchClear(LearnTabViewModel viewModel) {
    _searchController.clear();
    viewModel.clearSearch();
  }

  void _onSearchCancel(LearnTabViewModel viewModel) {
    viewModel.submitSearch(_searchController.text);
    _searchController.clear();
    _searchFocusNode.unfocus();
    viewModel.clearSearch();
  }

  void _onRecentQueryTap(LearnTabViewModel viewModel, String query) {
    _searchController.value = TextEditingValue(
      text: query,
      selection: TextSelection.collapsed(offset: query.length),
    );
    _searchFocusNode.requestFocus();
    viewModel.applyRecentQuery(query);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LearnTabViewModel>(
      create: (_) =>
          LearnTabViewModel(interactor: LearnTabInteractor())..load(),
      child: Consumer<LearnTabViewModel>(
        builder: (context, viewModel, _) {
          _onSearchBlur = () => viewModel.submitSearch(_searchController.text);
          context.showDeferredSnackIfNeeded(viewModel.consumeActionError());

          if (viewModel.isLoading && !viewModel.hasContent) {
            return const CircularProgressIndicator().center().safeArea();
          }

          if (viewModel.hasError && !viewModel.hasContent) {
            return context.loadErrorView(
              message: viewModel.errorMessage ?? context.l10n.learnFailedLoad,
              onRetry: viewModel.load,
            );
          }

          return context.learnTabBody(
            viewModel: viewModel,
            isSearchMode: _isSearchMode,
            searchController: _searchController,
            searchFocusNode: _searchFocusNode,
            onRefresh: viewModel.refresh,
            onSearchChanged: (value) => _onSearchChanged(viewModel, value),
            onSearchSubmitted: (value) => _onSearchSubmitted(viewModel, value),
            onSearchClear: () => _onSearchClear(viewModel),
            onSearchCancel: () => _onSearchCancel(viewModel),
            onRecentQueryTap: (query) => _onRecentQueryTap(viewModel, query),
            onRecentQueryDelete: viewModel.removeRecentQueryAt,
            onSeeAllTap: () => _openAllTopics(context, viewModel),
            onTopicTap: (topic) =>
                _openTopicArticles(context, viewModel, topic),
            onBookmarkTap: viewModel.toggleArticleSaved,
            onArticleTap: (article) =>
                _openArticle(context, viewModel, article),
          );
        },
      ),
    );
  }

  Future<void> _openTopicArticles(
    BuildContext context,
    LearnTabViewModel viewModel,
    Topic topic,
  ) async {
    await context.pushRoute(TopicArticlesScreen(topic: topic));

    if (!context.mounted) return;
    await viewModel.refresh();
  }

  Future<void> _openAllTopics(
    BuildContext context,
    LearnTabViewModel viewModel,
  ) async {
    await context.pushRoute(const AllTopicsScreen());

    if (!context.mounted) return;
    await viewModel.refresh();
  }

  Future<void> _openArticle(
    BuildContext context,
    LearnTabViewModel viewModel,
    ArticleListItem article,
  ) async {
    await context.pushRoute(ArticleScreen(article: article));

    if (!context.mounted) return;
    await viewModel.refresh();
  }
}
