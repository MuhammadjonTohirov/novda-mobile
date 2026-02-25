import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../../core/services/services.dart';

class ArticleScreenInteractor {
  ArticleScreenInteractor({ArticlesV2UseCase? articlesUseCase})
    : _articlesUseCase = articlesUseCase ?? services.sdk.articlesV2;

  final ArticlesV2UseCase _articlesUseCase;

  Future<ArticleDetail> loadArticle(String slug) {
    return _articlesUseCase.getArticle(slug);
  }

  Future<void> saveArticle(String slug) {
    return _articlesUseCase.saveArticle(slug);
  }

  Future<void> unsaveArticle(String slug) {
    return _articlesUseCase.unsaveArticle(slug);
  }
}
