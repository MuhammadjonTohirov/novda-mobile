import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../../core/services/services.dart';

class AllTopicsData {
  const AllTopicsData({required this.topics, required this.articles});

  final List<Topic> topics;
  final List<ArticleListItem> articles;
}

class AllTopicsInteractor {
  AllTopicsInteractor({ArticlesV2UseCase? articlesUseCase})
    : _articlesUseCase = articlesUseCase ?? services.sdk.articlesV2;

  final ArticlesV2UseCase _articlesUseCase;

  Future<AllTopicsData> loadContent() async {
    final results = await Future.wait([
      _articlesUseCase.getTopics(),
      _articlesUseCase.getArticles(),
    ]);

    final page = results[1] as ArticlesV2Page;

    return AllTopicsData(
      topics: results[0] as List<Topic>,
      articles: page.articles,
    );
  }
}
