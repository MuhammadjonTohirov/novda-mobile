import 'dart:async';

import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../../core/base/base_view_model.dart';
import '../interactor/topic_articles_interactor.dart';

class TopicArticlesViewModel extends BaseViewModel {
  TopicArticlesViewModel({
    required this.topic,
    TopicArticlesInteractor? interactor,
  }) : _interactor = interactor ?? TopicArticlesInteractor();

  final Topic topic;
  final TopicArticlesInteractor _interactor;

  List<ArticleListItem> _articles = const [];
  final Set<String> _savingSlugs = <String>{};
  final Set<String> _savedSlugs = <String>{};
  String? _actionErrorMessage;

  List<ArticleListItem> get articles => _articles;
  bool get hasContent => _articles.isNotEmpty;
  int get articleCount => _articles.length;

  bool isArticleSaved(ArticleListItem article) {
    return _savedSlugs.contains(article.slug);
  }

  bool isSavingArticle(String slug) => _savingSlugs.contains(slug);

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

  void toggleArticleSaved(ArticleListItem article) {
    if (_savingSlugs.contains(article.slug)) return;
    unawaited(_toggleArticleSaved(article));
  }

  Future<void> _load({required bool withLoading}) async {
    final hasExistingContent = hasContent;

    if (withLoading || !hasExistingContent) {
      setLoading();
    }

    try {
      _articles = await _interactor.loadTopicArticles(topic.slug);
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

  String _errorText(Object error) {
    if (error is ApiException) return error.message;
    return error.toString();
  }
}
