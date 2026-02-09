import '../gateways/articles_gateway.dart';
import '../models/article.dart';

/// Use case interface for article operations
abstract interface class ArticlesUseCase {
  /// Get articles with optional search and topic filter
  Future<List<ArticleListItem>> getArticles({
    String? query,
    String? topic,
  });

  /// Get article detail by slug
  Future<ArticleDetail> getArticle(String slug);

  /// Save an article
  Future<void> saveArticle(String slug);

  /// Unsave an article
  Future<void> unsaveArticle(String slug);

  /// Get all topics
  Future<List<Topic>> getTopics();
}

/// Implementation of ArticlesUseCase
class ArticlesUseCaseImpl implements ArticlesUseCase {
  ArticlesUseCaseImpl(this._gateway);

  final ArticlesGateway _gateway;

  @override
  Future<List<ArticleListItem>> getArticles({
    String? query,
    String? topic,
  }) {
    return _gateway.getArticles(ArticleListQuery(query: query, topic: topic));
  }

  @override
  Future<ArticleDetail> getArticle(String slug) {
    return _gateway.getArticle(slug);
  }

  @override
  Future<void> saveArticle(String slug) {
    return _gateway.saveArticle(slug);
  }

  @override
  Future<void> unsaveArticle(String slug) {
    return _gateway.unsaveArticle(slug);
  }

  @override
  Future<List<Topic>> getTopics() {
    return _gateway.getTopics();
  }
}
