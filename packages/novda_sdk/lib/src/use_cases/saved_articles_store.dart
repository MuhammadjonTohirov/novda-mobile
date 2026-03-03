import '../models/article.dart';

typedef SavedArticlesLoader = Future<List<ArticleListItem>> Function();

class SavedArticlesStore {
  final Set<String> _savedSlugs = <String>{};

  bool _isLoaded = false;
  Future<void>? _loadInFlight;

  bool contains(String slug) => _savedSlugs.contains(slug);

  Future<void> ensureLoaded(SavedArticlesLoader loader) {
    if (_isLoaded) return Future<void>.value();
    final inFlight = _loadInFlight;
    if (inFlight != null) return inFlight;

    final load = _load(loader);
    _loadInFlight = load;
    return load;
  }

  Future<void> _load(SavedArticlesLoader loader) async {
    try {
      final savedArticles = await loader();
      setFromArticles(savedArticles);
      _isLoaded = true;
    } finally {
      _loadInFlight = null;
    }
  }

  void setFromArticles(Iterable<ArticleListItem> articles) {
    _savedSlugs
      ..clear()
      ..addAll(articles.map((article) => article.slug));
    _isLoaded = true;
  }

  void markSaved(String slug) {
    _savedSlugs.add(slug);
    _isLoaded = true;
  }

  void markUnsaved(String slug) {
    _savedSlugs.remove(slug);
    _isLoaded = true;
  }

  List<ArticleListItem> applyToList(List<ArticleListItem> articles) {
    if (!_isLoaded) return articles;

    return articles
        .map((article) => article.copyWith(isSaved: contains(article.slug)))
        .toList(growable: false);
  }

  ArticleDetail applyToDetail(ArticleDetail detail) {
    if (!_isLoaded) return detail;

    return detail.copyWith(isSaved: contains(detail.slug));
  }
}
