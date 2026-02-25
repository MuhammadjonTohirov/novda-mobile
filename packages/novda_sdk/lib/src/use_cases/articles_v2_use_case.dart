import '../gateways/articles_gateway.dart';
import '../gateways/articles_v2_gateway.dart';
import '../models/article.dart';
import '../models/article_v2.dart';

/// Use case interface for `/api/v2/articles`.
abstract interface class ArticlesV2UseCase {
  Future<ArticlesV2Page> getArticles({
    int? page,
    int? pageSize,
    String? query,
    String? topic,
  });

  Future<List<ArticleListItem>> getRecommendedArticles({
    required int childId,
    required int progressIndex,
    required String progressType,
  });

  Future<ArticleDetail> getArticle(String slug);

  Future<void> saveArticle(String slug);

  Future<void> unsaveArticle(String slug);

  Future<List<Topic>> getTopics();
}

/// Implementation of [ArticlesV2UseCase].
class ArticlesV2UseCaseImpl implements ArticlesV2UseCase {
  ArticlesV2UseCaseImpl({
    required ArticlesV2Gateway articlesV2Gateway,
    required ArticlesGateway articlesGateway,
  }) : _articlesV2Gateway = articlesV2Gateway,
       _articlesGateway = articlesGateway;

  final ArticlesV2Gateway _articlesV2Gateway;
  final ArticlesGateway _articlesGateway;

  @override
  Future<ArticlesV2Page> getArticles({
    int? page,
    int? pageSize,
    String? query,
    String? topic,
  }) {
    return _articlesV2Gateway.getArticles(
      ArticlesV2Query(
        page: page,
        pageSize: pageSize,
        query: query,
        topic: topic,
      ),
    );
  }

  @override
  Future<List<ArticleListItem>> getRecommendedArticles({
    required int childId,
    required int progressIndex,
    required String progressType,
  }) {
    return _articlesV2Gateway.getRecommendedArticles(
      RecommendedArticlesQuery(
        childId: childId,
        progressIndex: progressIndex,
        progressType: progressType,
      ),
    );
  }

  @override
  Future<ArticleDetail> getArticle(String slug) {
    return _articlesGateway.getArticle(slug);
  }

  @override
  Future<void> saveArticle(String slug) {
    return _articlesGateway.saveArticle(slug);
  }

  @override
  Future<void> unsaveArticle(String slug) {
    return _articlesGateway.unsaveArticle(slug);
  }

  @override
  Future<List<Topic>> getTopics() {
    return _articlesGateway.getTopics();
  }
}
