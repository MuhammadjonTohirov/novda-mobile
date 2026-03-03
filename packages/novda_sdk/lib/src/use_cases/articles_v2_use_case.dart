import '../gateways/articles_gateway.dart';
import '../gateways/articles_v2_gateway.dart';
import '../gateways/user_gateway.dart';
import '../models/article.dart';
import '../models/article_v2.dart';
import 'saved_articles_store.dart';

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

  Future<List<ArticleListItem>> getSimilarArticles(String slug);

  Future<void> saveArticle(String slug);

  Future<void> unsaveArticle(String slug);

  Future<List<Topic>> getTopics();
}

/// Implementation of [ArticlesV2UseCase].
class ArticlesV2UseCaseImpl implements ArticlesV2UseCase {
  ArticlesV2UseCaseImpl({
    required ArticlesV2Gateway articlesV2Gateway,
    required ArticlesGateway articlesGateway,
    UserGateway? userGateway,
    SavedArticlesStore? savedArticlesStore,
  }) : _articlesV2Gateway = articlesV2Gateway,
       _articlesGateway = articlesGateway,
       _userGateway = userGateway,
       _savedArticlesStore = savedArticlesStore ?? SavedArticlesStore();

  final ArticlesV2Gateway _articlesV2Gateway;
  final ArticlesGateway _articlesGateway;
  final UserGateway? _userGateway;
  final SavedArticlesStore _savedArticlesStore;

  @override
  Future<ArticlesV2Page> getArticles({
    int? page,
    int? pageSize,
    String? query,
    String? topic,
  }) async {
    final savedLoad = _loadSavedArticlesIfNeeded();

    final result = await _articlesV2Gateway.getArticles(
      ArticlesV2Query(
        page: page,
        pageSize: pageSize,
        query: query,
        topic: topic,
      ),
    );

    await savedLoad;

    return ArticlesV2Page(
      articles: _savedArticlesStore.applyToList(result.articles),
      page: result.page,
      pageSize: result.pageSize,
      totalCount: result.totalCount,
      totalPages: result.totalPages,
      hasNext: result.hasNext,
      hasPrevious: result.hasPrevious,
    );
  }

  @override
  Future<List<ArticleListItem>> getRecommendedArticles({
    required int childId,
    required int progressIndex,
    required String progressType,
  }) async {
    final savedLoad = _loadSavedArticlesIfNeeded();

    final result = await _articlesV2Gateway.getRecommendedArticles(
      RecommendedArticlesQuery(
        childId: childId,
        progressIndex: progressIndex,
        progressType: progressType,
      ),
    );

    await savedLoad;

    return _savedArticlesStore.applyToList(result);
  }

  @override
  Future<ArticleDetail> getArticle(String slug) async {
    final savedLoad = _loadSavedArticlesIfNeeded();
    final detail = await _articlesGateway.getArticle(slug);
    await savedLoad;
    return _savedArticlesStore.applyToDetail(detail);
  }

  @override
  Future<List<ArticleListItem>> getSimilarArticles(String slug) async {
    final savedLoad = _loadSavedArticlesIfNeeded();
    final similarArticles = await _articlesGateway.getSimilarArticles(slug);
    await savedLoad;
    return _savedArticlesStore.applyToList(similarArticles);
  }

  @override
  Future<void> saveArticle(String slug) async {
    await _articlesGateway.saveArticle(slug);
    _savedArticlesStore.markSaved(slug);
  }

  @override
  Future<void> unsaveArticle(String slug) async {
    await _articlesGateway.unsaveArticle(slug);
    _savedArticlesStore.markUnsaved(slug);
  }

  @override
  Future<List<Topic>> getTopics() {
    return _articlesGateway.getTopics();
  }

  Future<void> _loadSavedArticlesIfNeeded() async {
    final gateway = _userGateway;
    if (gateway == null) return;

    try {
      await _savedArticlesStore.ensureLoaded(gateway.getSavedArticles);
    } catch (_) {
      // Keep article loading resilient even when saved articles endpoint fails.
    }
  }
}
