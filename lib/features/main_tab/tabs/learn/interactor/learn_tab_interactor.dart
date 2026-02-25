import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/services/services.dart';

class LearnTabData {
  const LearnTabData({required this.topics, required this.articles});

  final List<Topic> topics;
  final List<ArticleListItem> articles;
}

class LearnTabInteractor {
  LearnTabInteractor({ArticlesV2UseCase? articlesUseCase})
    : _articlesUseCase = articlesUseCase ?? services.sdk.articlesV2;

  final ArticlesV2UseCase _articlesUseCase;

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
}
