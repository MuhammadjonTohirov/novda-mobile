import 'dart:async';

import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../../core/base/base_view_model.dart';
import '../interactor/saved_articles_interactor.dart';

class SavedArticlesViewModel extends BaseViewModel with ActionErrorMixin {
  SavedArticlesViewModel({SavedArticlesInteractor? interactor})
    : _interactor = interactor ?? SavedArticlesInteractor();

  final SavedArticlesInteractor _interactor;

  List<ArticleListItem> _articles = const [];
  final Set<String> _savingSlugs = <String>{};

  List<ArticleListItem> get articles => _articles;
  bool get hasContent => _articles.isNotEmpty;
  bool isSavingArticle(String slug) => _savingSlugs.contains(slug);

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
      _articles = await _interactor.loadSavedArticles();
      setSuccess();
    } catch (error) {
      if (hasExistingContent) {
        setActionError(error);
        notifyListeners();
        return;
      }

      handleException(error);
    }
  }

  Future<void> _toggleArticleSaved(ArticleListItem article) async {
    final slug = article.slug;

    _savingSlugs.add(slug);
    notifyListeners();

    try {
      await _interactor.unsaveArticle(slug);
      _articles = _articles
          .where((savedArticle) => savedArticle.slug != slug)
          .toList(growable: false);
    } catch (error) {
      setActionError(error);
    } finally {
      _savingSlugs.remove(slug);
      notifyListeners();
    }
  }

}
