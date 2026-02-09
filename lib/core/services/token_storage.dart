import 'package:novda_sdk/novda_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Token storage implementation using SharedPreferences
class TokenStorage implements TokenProvider {
  TokenStorage(this._prefs);

  final SharedPreferences _prefs;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  @override
  String? get accessToken => _prefs.getString(_accessTokenKey);

  @override
  String? get refreshToken => _prefs.getString(_refreshTokenKey);

  @override
  Future<void> saveTokens({
    required String access,
    required String refresh,
  }) async {
    await _prefs.setString(_accessTokenKey, access);
    await _prefs.setString(_refreshTokenKey, refresh);
  }

  @override
  Future<void> clearTokens() async {
    await _prefs.remove(_accessTokenKey);
    await _prefs.remove(_refreshTokenKey);
  }

  bool get hasTokens => accessToken != null && refreshToken != null;
}
