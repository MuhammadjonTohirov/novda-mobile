import '../core/network/api_client.dart';
import '../models/article.dart';
import '../models/user.dart';

/// Gateway interface for user operations
abstract interface class UserGateway {
  Future<User> getProfile();
  Future<User> updateProfile(UserUpdateRequest request);
  Future<void> deleteAccount();
  Future<void> acceptTerms();
  Future<List<ArticleListItem>> getSavedArticles();
}

/// Implementation of UserGateway
class UserGatewayImpl implements UserGateway {
  UserGatewayImpl(this._client);

  final ApiClient _client;

  @override
  Future<User> getProfile() async {
    return _client.get(
      '/api/v1/me',
      fromJson: (json) => User.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<User> updateProfile(UserUpdateRequest request) async {
    return _client.patch(
      '/api/v1/me/update',
      data: request.toJson(),
      fromJson: (json) => User.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<void> deleteAccount() async {
    await _client.delete('/api/v1/me/delete');
  }

  @override
  Future<void> acceptTerms() async {
    await _client.post('/api/v1/me/accept-terms', data: {'accept': true});
  }

  @override
  Future<List<ArticleListItem>> getSavedArticles() async {
    return _client.get(
      '/api/v1/me/saved-articles',
      fromJson: _parseSavedArticles,
    );
  }

  List<ArticleListItem> _parseSavedArticles(Object? json) {
    if (json is List<dynamic>) {
      return _parseSavedArticlesList(json);
    }

    if (json is Map<String, dynamic>) {
      final savedArticles = json['saved_articles'];
      if (savedArticles is List<dynamic>) {
        return _parseSavedArticlesList(savedArticles);
      }

      // Fallback when API returns a flat article object in `data`.
      if (json['slug'] != null) {
        return [ArticleListItem.fromJson(json)];
      }
    }

    return const [];
  }

  List<ArticleListItem> _parseSavedArticlesList(List<dynamic> source) {
    final articles = <ArticleListItem>[];

    for (final item in source) {
      if (item is! Map<String, dynamic>) continue;

      final rawArticle = item['article'];
      if (rawArticle is Map<String, dynamic>) {
        articles.add(ArticleListItem.fromJson(rawArticle));
        continue;
      }

      // Backward compatible shape: list can be the article objects directly.
      articles.add(ArticleListItem.fromJson(item));
    }

    return articles;
  }
}
