import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../../core/base/base_view_model.dart';
import '../interactor/article_screen_interactor.dart';

class ArticleScreenViewModel extends BaseViewModel {
  ArticleScreenViewModel({
    required this.preview,
    ArticleScreenInteractor? interactor,
  }) : _interactor = interactor ?? ArticleScreenInteractor(),
       _isSaved = preview.isSaved,
       _viewCount = preview.viewCount;

  final ArticleListItem preview;
  final ArticleScreenInteractor _interactor;

  ArticleDetail? _detail;
  bool _isSaved;
  int _viewCount;
  List<ArticleListItem> _similarArticles = const [];
  final Set<String> _savingSlugs = <String>{};
  String? _actionErrorMessage;

  bool get hasDetail => _detail != null;
  bool get isSaved => _isSaved;
  bool get isBookmarkUpdating => _savingSlugs.contains(slug);
  List<ArticleListItem> get similarArticles => _similarArticles;

  String get slug => preview.slug;
  String get title => _detail?.title ?? preview.title;
  String get heroImageUrl => _detail?.heroImageUrl ?? preview.heroImageUrl;
  int get readingTime => _detail?.readingTime ?? preview.readingTime;
  int get viewCount => _detail?.viewCount ?? _viewCount;
  String get bodyHtml => _detail?.body ?? '';

  String? consumeActionError() {
    final message = _actionErrorMessage;
    _actionErrorMessage = null;
    return message;
  }

  Future<void> load() async {
    setLoading();

    final detailFuture = _interactor.loadArticle(slug);
    final similarFuture = _interactor
        .loadSimilarArticles(slug)
        .catchError((_) => const <ArticleListItem>[]);

    try {
      final detail = await detailFuture;
      final similarArticles = await similarFuture;

      _detail = detail;
      _isSaved = detail.isSaved;
      _viewCount = detail.viewCount;
      _similarArticles = _normalizeSimilarArticles(similarArticles);
      setSuccess();
    } catch (error) {
      await similarFuture;
      handleException(error);
    }
  }

  Future<void> toggleSaved() async {
    await _toggleSavedBySlug(slug);
  }

  Future<void> toggleSimilarArticleSaved(ArticleListItem article) async {
    await _toggleSavedBySlug(article.slug);
  }

  bool isSavingArticle(String slug) => _savingSlugs.contains(slug);

  bool isArticleSaved(ArticleListItem article) {
    if (article.slug == slug) return _isSaved;

    for (final similar in _similarArticles) {
      if (similar.slug == article.slug) return similar.isSaved;
    }

    return article.isSaved;
  }

  Future<void> _toggleSavedBySlug(String targetSlug) async {
    if (_savingSlugs.contains(targetSlug)) return;

    final wasSaved = _isSlugSaved(targetSlug);

    _savingSlugs.add(targetSlug);
    notifyListeners();

    try {
      if (wasSaved) {
        await _interactor.unsaveArticle(targetSlug);
        _setSavedState(targetSlug, false);
      } else {
        await _interactor.saveArticle(targetSlug);
        _setSavedState(targetSlug, true);
      }
    } catch (error) {
      _actionErrorMessage = _errorText(error);
    } finally {
      _savingSlugs.remove(targetSlug);
      notifyListeners();
    }
  }

  bool _isSlugSaved(String targetSlug) {
    if (targetSlug == slug) return _isSaved;

    for (final article in _similarArticles) {
      if (article.slug == targetSlug) return article.isSaved;
    }

    return false;
  }

  void _setSavedState(String targetSlug, bool isSaved) {
    if (targetSlug == slug) {
      _isSaved = isSaved;
    }

    if (_similarArticles.isEmpty) return;

    _similarArticles = _similarArticles
        .map(
          (article) => article.slug == targetSlug
              ? article.copyWith(isSaved: isSaved)
              : article,
        )
        .toList(growable: false);
  }

  List<ArticleListItem> _normalizeSimilarArticles(
    List<ArticleListItem> source,
  ) {
    final normalized = <ArticleListItem>[];
    final seenSlugs = <String>{};

    for (final article in source) {
      if (article.slug == slug) continue;
      if (!seenSlugs.add(article.slug)) continue;
      normalized.add(article);
    }

    return normalized.toList(growable: false);
  }

  String _errorText(Object error) {
    if (error is ApiException) return error.message;
    return error.toString();
  }
}
