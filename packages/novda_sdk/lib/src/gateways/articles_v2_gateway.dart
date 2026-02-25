import '../core/network/api_client.dart';
import '../models/article.dart';
import '../models/article_v2.dart';

/// Gateway interface for `/api/v2/articles` operations.
abstract interface class ArticlesV2Gateway {
  Future<ArticlesV2Page> getArticles(ArticlesV2Query query);

  Future<List<ArticleListItem>> getRecommendedArticles(
    RecommendedArticlesQuery query,
  );
}

/// Implementation of [ArticlesV2Gateway].
class ArticlesV2GatewayImpl implements ArticlesV2Gateway {
  ArticlesV2GatewayImpl(this._client);

  final ApiClient _client;

  Map<String, dynamic> _extractMap(Object? json) {
    if (json is Map<String, dynamic>) {
      final nestedData = json['data'];
      if (nestedData is Map<String, dynamic>) return nestedData;
      return json;
    }

    if (json is List<dynamic>) {
      return {'articles': json};
    }

    throw const FormatException('Expected a map or list response');
  }

  List<dynamic> _extractList(
    Object? json, {
    required List<String> candidateKeys,
  }) {
    if (json is List<dynamic>) return json;

    if (json is Map<String, dynamic>) {
      final nestedData = json['data'];
      if (nestedData is List<dynamic>) return nestedData;
      if (nestedData is Map<String, dynamic>) {
        for (final key in candidateKeys) {
          final value = nestedData[key];
          if (value is List<dynamic>) return value;
        }
      }

      for (final key in candidateKeys) {
        final value = json[key];
        if (value is List<dynamic>) return value;
      }

      for (final value in json.values) {
        if (value is List<dynamic>) return value;
      }

      return const [];
    }

    throw const FormatException('Expected a map or list response');
  }

  @override
  Future<ArticlesV2Page> getArticles(ArticlesV2Query query) async {
    return _client.get(
      '/api/v2/articles',
      queryParameters: query.toQueryParams(),
      fromJson: (json) => ArticlesV2Page.fromJson(_extractMap(json)),
    );
  }

  @override
  Future<List<ArticleListItem>> getRecommendedArticles(
    RecommendedArticlesQuery query,
  ) async {
    return _client.get(
      '/api/v2/children/${query.childId}/recommended-articles',
      queryParameters: query.toQueryParams(),
      fromJson: (json) =>
          _extractList(
                json,
                candidateKeys: const [
                  'recommended_articles',
                  'articles',
                  'results',
                  'items',
                  'data',
                ],
              )
              .whereType<Map>()
              .map((item) {
                return ArticleListItem.fromJson(
                  Map<String, dynamic>.from(item),
                );
              })
              .toList(growable: false),
    );
  }
}
