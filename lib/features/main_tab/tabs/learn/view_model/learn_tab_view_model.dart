import 'dart:async';

import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/base/base_view_model.dart';
import '../interactor/learn_tab_interactor.dart';

class LearnTabViewModel extends BaseViewModel {
  LearnTabViewModel({LearnTabInteractor? interactor})
    : _interactor = interactor ?? LearnTabInteractor();

  static const _searchDebounceDuration = Duration(milliseconds: 360);

  final LearnTabInteractor _interactor;

  List<Topic> _topics = const [];
  List<ArticleListItem> _articles = const [];
  final Set<String> _savingSlugs = <String>{};
  final Set<String> _savedSlugs = <String>{};

  String _query = '';
  String? _selectedTopicSlug;
  String? _actionErrorMessage;
  Timer? _searchDebounce;

  List<Topic> get topics => _topics;
  List<ArticleListItem> get articles => _articles;
  String get query => _query;
  String? get selectedTopicSlug => _selectedTopicSlug;
  bool get hasContent => _topics.isNotEmpty || _articles.isNotEmpty;

  List<Topic> get popularTopics {
    final popular = _topics.where((topic) => topic.isPopular).toList();
    if (popular.isEmpty) return _topics.take(6).toList();

    popular.sort(_compareTopics);
    return popular.take(6).toList();
  }

  bool isTopicSelected(String topicSlug) => _selectedTopicSlug == topicSlug;

  bool isArticleSaved(ArticleListItem article) {
    return _savedSlugs.contains(article.slug);
  }

  bool isSavingArticle(String slug) => _savingSlugs.contains(slug);

  int topicArticleCount(String topicSlug) {
    var count = 0;

    for (final article in _articles) {
      final hasTopic = article.topics.any((topic) => topic.slug == topicSlug);
      if (hasTopic) count += 1;
    }

    return count;
  }

  String? consumeActionError() {
    final message = _actionErrorMessage;
    _actionErrorMessage = null;
    return message;
  }

  Future<void> load() {
    return _load(withLoading: true);
  }

  Future<void> refresh() {
    return _load(withLoading: false);
  }

  void searchArticles(String value) {
    final normalized = value.trim();
    if (_query == normalized) return;

    _query = normalized;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(_searchDebounceDuration, () {
      unawaited(_load(withLoading: !hasContent));
    });
  }

  void selectTopic(String topicSlug) {
    final nextTopic = _selectedTopicSlug == topicSlug ? null : topicSlug;
    if (nextTopic == _selectedTopicSlug) return;

    _selectedTopicSlug = nextTopic;
    notifyListeners();
    unawaited(_load(withLoading: !hasContent));
  }

  void clearTopicFilter() {
    if (_selectedTopicSlug == null) return;

    _selectedTopicSlug = null;
    notifyListeners();
    unawaited(_load(withLoading: !hasContent));
  }

  void toggleArticleSaved(ArticleListItem article) {
    if (_savingSlugs.contains(article.slug)) return;
    unawaited(_toggleArticleSaved(article));
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  Future<void> _load({required bool withLoading}) async {
    final hasExistingContent = hasContent;

    if (withLoading || !hasExistingContent) {
      setLoading();
    }

    try {
      final data = await _interactor.loadContent(
        query: _query.isEmpty ? null : _query,
        topic: _selectedTopicSlug,
      );

      _topics = _sortTopics(data.topics);
      _articles = data.articles;
      _savedSlugs
        ..clear()
        ..addAll(
          _articles
              .where((article) => article.isSaved)
              .map((article) => article.slug),
        );

      setSuccess();
    } catch (error) {
      if (hasExistingContent) {
        _actionErrorMessage = _errorText(error);
        notifyListeners();
        return;
      }

      handleException(error);
    }
  }

  Future<void> _toggleArticleSaved(ArticleListItem article) async {
    final slug = article.slug;
    final wasSaved = isArticleSaved(article);

    _savingSlugs.add(slug);
    notifyListeners();

    try {
      if (wasSaved) {
        await _interactor.unsaveArticle(slug);
        _savedSlugs.remove(slug);
      } else {
        await _interactor.saveArticle(slug);
        _savedSlugs.add(slug);
      }
    } catch (error) {
      _actionErrorMessage = _errorText(error);
    } finally {
      _savingSlugs.remove(slug);
      notifyListeners();
    }
  }

  List<Topic> _sortTopics(List<Topic> source) {
    final sorted = [...source];
    sorted.sort(_compareTopics);
    return sorted;
  }

  int _compareTopics(Topic left, Topic right) {
    final positionDiff = left.position.compareTo(right.position);
    if (positionDiff != 0) return positionDiff;

    return left.title.toLowerCase().compareTo(right.title.toLowerCase());
  }

  String _errorText(Object error) {
    if (error is ApiException) return error.message;
    return error.toString();
  }
}
