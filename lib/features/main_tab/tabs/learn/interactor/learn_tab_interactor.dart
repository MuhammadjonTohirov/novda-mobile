import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/services/services.dart';

class LearnTabData {
  const LearnTabData({required this.topics, required this.articles});

  final List<Topic> topics;
  final List<ArticleListItem> articles;
}

class LearnTabInteractor {
  LearnTabInteractor({ArticlesUseCase? articlesUseCase})
    : _articlesUseCase = articlesUseCase ?? services.sdk.articles;

  final ArticlesUseCase _articlesUseCase;

  Future<LearnTabData> loadContent({String? query, String? topic}) async {
    final results = await Future.wait([
      _articlesUseCase.getTopics(),
      _articlesUseCase.getArticles(query: query, topic: topic),
    ]);

    return LearnTabData(
      topics: results[0] as List<Topic>,
      articles: results[1] as List<ArticleListItem>,
    );
  }

  Future<void> saveArticle(String slug) {
    return _articlesUseCase.saveArticle(slug);
  }

  Future<void> unsaveArticle(String slug) {
    return _articlesUseCase.unsaveArticle(slug);
  }
}
