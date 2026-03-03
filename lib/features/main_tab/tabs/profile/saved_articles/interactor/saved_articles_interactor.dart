import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../../core/services/services.dart';

class SavedArticlesInteractor {
  SavedArticlesInteractor({
    UserUseCase? userUseCase,
    ArticlesV2UseCase? articlesUseCase,
  }) : _userUseCase = userUseCase ?? services.sdk.user,
       _articlesUseCase = articlesUseCase ?? services.sdk.articlesV2;

  final UserUseCase _userUseCase;
  final ArticlesV2UseCase _articlesUseCase;

  Future<List<ArticleListItem>> loadSavedArticles() {
    return _userUseCase.getSavedArticles();
  }

  Future<void> unsaveArticle(String slug) {
    return _articlesUseCase.unsaveArticle(slug);
  }
}
