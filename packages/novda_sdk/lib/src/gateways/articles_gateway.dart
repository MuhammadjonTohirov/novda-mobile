import '../core/network/api_client.dart';
import '../core/network/json_helpers.dart';
import '../models/article.dart';

/// Gateway interface for article operations
abstract interface class ArticlesGateway {
  Future<List<ArticleListItem>> getArticles(ArticleListQuery query);
  Future<ArticleDetail> getArticle(String slug);
  Future<List<ArticleListItem>> getSimilarArticles(String slug);
  Future<void> saveArticle(String slug);
  Future<void> unsaveArticle(String slug);
  Future<List<Topic>> getTopics();
}

/// Implementation of ArticlesGateway
class ArticlesGatewayImpl implements ArticlesGateway {
  ArticlesGatewayImpl(this._client);

  final ApiClient _client;

  Map<String, dynamic>? _extractArticleItemMap(Object? rawItem) {
    if (rawItem is Map<String, dynamic>) {
      final nestedArticle = rawItem['article'];
      if (nestedArticle is Map<String, dynamic>) return nestedArticle;
      return rawItem;
    }

    if (rawItem is Map) {
      final map = Map<String, dynamic>.from(rawItem);
      final nestedArticle = map['article'];
      if (nestedArticle is Map) {
        return Map<String, dynamic>.from(nestedArticle);
      }
      return map;
    }

    return null;
  }

  @override
  Future<List<ArticleListItem>> getArticles(ArticleListQuery query) async {
    return _client.get(
      '/api/v1/articles',
      queryParameters: query.toQueryParams(),
      fromJson: (json) =>
          extractList(json, candidateKeys: const ['articles', 'results'])
              .map((e) => ArticleListItem.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  @override
  Future<ArticleDetail> getArticle(String slug) async {
    return _client.get(
      '/api/v1/articles/$slug',
      fromJson: (json) => ArticleDetail.fromJson(
        extractMap(json, candidateKeys: const ['article']),
      ),
    );
  }

  @override
  Future<List<ArticleListItem>> getSimilarArticles(String slug) async {
    return _client.get(
      '/api/v1/similar_articles/$slug',
      fromJson: (json) {
        final items = extractList(
          json,
          candidateKeys: const [
            'similar_articles',
            'articles',
            'results',
            'items',
            'data',
          ],
        );

        final articles = <ArticleListItem>[];
        for (final item in items) {
          final articleMap = _extractArticleItemMap(item);
          if (articleMap == null) continue;
          articles.add(ArticleListItem.fromJson(articleMap));
        }

        return articles;
      },
    );
  }

  @override
  Future<void> saveArticle(String slug) async {
    await _client.post('/api/v1/articles/$slug/save');
  }

  @override
  Future<void> unsaveArticle(String slug) async {
    await _client.delete('/api/v1/articles/$slug/save');
  }

  @override
  Future<List<Topic>> getTopics() async {
    return _client.get(
      '/api/v1/topics',
      fromJson: (json) => extractList(
        json,
        candidateKeys: const ['topics', 'results'],
      ).map((e) => Topic.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
