import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../../core/services/services.dart';

class TopicArticlesInteractor {
  TopicArticlesInteractor({ArticlesUseCase? articlesUseCase})
    : _articlesUseCase = articlesUseCase ?? services.sdk.articles;

  final ArticlesUseCase _articlesUseCase;

  Future<List<ArticleListItem>> loadTopicArticles(String topicSlug) {
    return _articlesUseCase.getArticles(topic: topicSlug);
  }

  Future<void> saveArticle(String slug) {
    return _articlesUseCase.saveArticle(slug);
  }

  Future<void> unsaveArticle(String slug) {
    return _articlesUseCase.unsaveArticle(slug);
  }
}
