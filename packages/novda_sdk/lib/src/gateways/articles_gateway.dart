import '../core/network/api_client.dart';
import '../models/article.dart';

/// Gateway interface for article operations
abstract interface class ArticlesGateway {
  Future<List<ArticleListItem>> getArticles(ArticleListQuery query);
  Future<ArticleDetail> getArticle(String slug);
  Future<void> saveArticle(String slug);
  Future<void> unsaveArticle(String slug);
  Future<List<Topic>> getTopics();
}

/// Implementation of ArticlesGateway
class ArticlesGatewayImpl implements ArticlesGateway {
  ArticlesGatewayImpl(this._client);

  final ApiClient _client;

  List<dynamic> _extractList(
    Object? json, {
    required List<String> candidateKeys,
  }) {
    if (json is List<dynamic>) {
      return json;
    }

    if (json is Map<String, dynamic>) {
      for (final key in candidateKeys) {
        final value = json[key];
        if (value is List<dynamic>) {
          return value;
        }
      }

      for (final value in json.values) {
        if (value is List<dynamic>) {
          return value;
        }
      }
    }

    throw const FormatException('Expected a list response');
  }

  Map<String, dynamic> _extractMap(
    Object? json, {
    List<String> candidateKeys = const [],
  }) {
    if (json is Map<String, dynamic>) {
      for (final key in candidateKeys) {
        final value = json[key];
        if (value is Map<String, dynamic>) {
          return value;
        }
      }

      return json;
    }

    throw const FormatException('Expected a map response');
  }

  @override
  Future<List<ArticleListItem>> getArticles(ArticleListQuery query) async {
    return _client.get(
      '/api/v1/articles',
      queryParameters: query.toQueryParams(),
      fromJson: (json) =>
          _extractList(json, candidateKeys: const ['articles', 'results'])
              .map((e) => ArticleListItem.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  @override
  Future<ArticleDetail> getArticle(String slug) async {
    return _client.get(
      '/api/v1/articles/$slug',
      fromJson: (json) => ArticleDetail.fromJson(
        _extractMap(json, candidateKeys: const ['article']),
      ),
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
      fromJson: (json) => _extractList(
        json,
        candidateKeys: const ['topics', 'results'],
      ).map((e) => Topic.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
