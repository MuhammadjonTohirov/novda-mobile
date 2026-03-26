import '../core/cache/in_memory_cache.dart';
import '../models/article.dart';
import '../models/enums.dart';
import '../models/user.dart';
import 'user_use_case.dart';

/// Caching decorator for [UserUseCase].
///
/// Caches [getProfile] with a 2-minute TTL.
/// [updateProfile] invalidates the profile cache.
/// [getSavedArticles] is not cached as it changes frequently.
class CachedUserUseCase implements UserUseCase {
  CachedUserUseCase(this._inner);

  final UserUseCase _inner;
  final _profileCache = InMemoryCache<User>(ttl: Duration(minutes: 2));

  @override
  Future<User> getProfile() async {
    final cached = _profileCache.value;
    if (cached != null) return cached;
    final result = await _inner.getProfile();
    _profileCache.set(result);
    return result;
  }

  @override
  Future<User> updateProfile({
    String? name,
    String? email,
    PreferredLocale? preferredLocale,
    ThemePreference? themePreference,
    bool? notificationsEnabled,
  }) async {
    final result = await _inner.updateProfile(
      name: name,
      email: email,
      preferredLocale: preferredLocale,
      themePreference: themePreference,
      notificationsEnabled: notificationsEnabled,
    );
    invalidateProfileCache();
    return result;
  }

  @override
  Future<void> deleteAccount() => _inner.deleteAccount();

  @override
  Future<void> acceptTerms() => _inner.acceptTerms();

  @override
  Future<List<ArticleListItem>> getSavedArticles() => _inner.getSavedArticles();

  void invalidateProfileCache() {
    _profileCache.invalidate();
  }
}
