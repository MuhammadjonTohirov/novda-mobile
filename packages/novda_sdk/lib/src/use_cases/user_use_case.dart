import '../gateways/user_gateway.dart';
import '../models/article.dart';
import '../models/enums.dart';
import '../models/user.dart';

/// Use case interface for user profile operations
abstract interface class UserUseCase {
  /// Get current user profile
  Future<User> getProfile();

  /// Update user profile
  Future<User> updateProfile({
    String? name,
    String? email,
    PreferredLocale? preferredLocale,
    ThemePreference? themePreference,
    bool? notificationsEnabled,
  });

  /// Delete user account
  Future<void> deleteAccount();

  /// Accept terms and conditions
  Future<void> acceptTerms();

  /// Get saved articles for current user
  Future<List<ArticleListItem>> getSavedArticles();
}

/// Implementation of UserUseCase
class UserUseCaseImpl implements UserUseCase {
  UserUseCaseImpl(this._gateway);

  final UserGateway _gateway;

  @override
  Future<User> getProfile() {
    return _gateway.getProfile();
  }

  @override
  Future<User> updateProfile({
    String? name,
    String? email,
    PreferredLocale? preferredLocale,
    ThemePreference? themePreference,
    bool? notificationsEnabled,
  }) {
    return _gateway.updateProfile(UserUpdateRequest(
      name: name,
      email: email,
      preferredLocale: preferredLocale,
      themePreference: themePreference,
      notificationsEnabled: notificationsEnabled,
    ));
  }

  @override
  Future<void> deleteAccount() {
    return _gateway.deleteAccount();
  }

  @override
  Future<void> acceptTerms() {
    return _gateway.acceptTerms();
  }

  @override
  Future<List<ArticleListItem>> getSavedArticles() {
    return _gateway.getSavedArticles();
  }
}
