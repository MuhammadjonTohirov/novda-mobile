import 'package:novda_sdk/novda_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/services/services.dart';

class LearnTabData {
  const LearnTabData({required this.topics, required this.articles});

  final List<Topic> topics;
  final List<ArticleListItem> articles;
}

class LearnTabInteractor {
  LearnTabInteractor({
    ArticlesV2UseCase? articlesUseCase,
    SharedPreferences? prefs,
  }) : _articlesUseCase = articlesUseCase ?? services.sdk.articlesV2,
       _prefs = prefs ?? services.prefs;

  static const _recentQueriesKey = 'learn_recent_queries_v1';
  static const _maxRecentQueries = 8;

  final ArticlesV2UseCase _articlesUseCase;
  final SharedPreferences _prefs;

  Future<LearnTabData> loadContent({String? query, String? topic}) async {
    final results = await Future.wait([
      _articlesUseCase.getTopics(),
      _articlesUseCase.getArticles(query: query, topic: topic),
    ]);

    final page = results[1] as ArticlesV2Page;

    return LearnTabData(
      topics: results[0] as List<Topic>,
      articles: page.articles,
    );
  }

  Future<void> saveArticle(String slug) {
    return _articlesUseCase.saveArticle(slug);
  }

  Future<void> unsaveArticle(String slug) {
    return _articlesUseCase.unsaveArticle(slug);
  }

  List<String> loadRecentQueries() {
    final stored = _prefs.getStringList(_recentQueriesKey) ?? const <String>[];
    return _sanitizeRecentQueries(stored);
  }

  Future<List<String>> saveRecentQuery(String query) async {
    final normalized = query.trim();
    if (normalized.isEmpty) return loadRecentQueries();

    final current = loadRecentQueries();
    current.removeWhere(
      (item) => item.toLowerCase() == normalized.toLowerCase(),
    );
    current.insert(0, normalized);

    final next = current.take(_maxRecentQueries).toList(growable: false);
    await _prefs.setStringList(_recentQueriesKey, next);
    return next;
  }

  Future<List<String>> removeRecentQueryAt(int index) async {
    final current = loadRecentQueries();
    if (index < 0 || index >= current.length) {
      return current;
    }

    current.removeAt(index);
    await _prefs.setStringList(_recentQueriesKey, current);
    return current;
  }

  List<String> _sanitizeRecentQueries(List<String> source) {
    final unique = <String>[];
    final seen = <String>{};

    for (final item in source) {
      final normalized = item.trim();
      if (normalized.isEmpty) continue;

      final key = normalized.toLowerCase();
      if (!seen.add(key)) continue;
      unique.add(normalized);
    }

    return unique.take(_maxRecentQueries).toList(growable: false);
  }
}
