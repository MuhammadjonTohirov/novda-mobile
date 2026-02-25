import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../../core/services/services.dart';

class TopicArticlesInteractor {
  TopicArticlesInteractor({ArticlesV2UseCase? articlesUseCase})
    : _articlesUseCase = articlesUseCase ?? services.sdk.articlesV2;

  final ArticlesV2UseCase _articlesUseCase;

  Future<List<ArticleListItem>> loadTopicArticles(String topicSlug) async {
    final page = await _articlesUseCase.getArticles(topic: topicSlug);
    return page.articles;
  }

  Future<void> saveArticle(String slug) {
    return _articlesUseCase.saveArticle(slug);
  }

  Future<void> unsaveArticle(String slug) {
    return _articlesUseCase.unsaveArticle(slug);
  }
}
