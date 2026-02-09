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

  @override
  Future<List<ArticleListItem>> getArticles(ArticleListQuery query) async {
    return _client.get(
      '/api/v1/articles',
      queryParameters: query.toQueryParams(),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ArticleListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<ArticleDetail> getArticle(String slug) async {
    return _client.get(
      '/api/v1/articles/$slug',
      fromJson: (json) => ArticleDetail.fromJson(json as Map<String, dynamic>),
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
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => Topic.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
