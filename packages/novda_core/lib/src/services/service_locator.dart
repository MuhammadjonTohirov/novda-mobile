import 'package:flutter/foundation.dart';
import 'package:novda_sdk/novda_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/theme_variant.dart';
import '../theme/theme_preference_resolver.dart';
import 'token_storage.dart';

/// Service locator for dependency injection
class ServiceLocator {
  ServiceLocator._();

  static ServiceLocator? _instance;
  static ServiceLocator get instance {
    _instance ??= ServiceLocator._();
    return _instance!;
  }

  static const _baseUrl =
      'http://94.158.51.9:8000'; //'https://kidscare.uzyol.uz';
  static const _apiKey = 'KIDS_CARE_API_KEY_9839283ad98asdj123j23a0s9dia9d';

  late final SharedPreferences _prefs;
  late final TokenStorage _tokenStorage;
  late final NovdaSDK _sdk;

  bool _initialized = false;

  /// Initialize the service locator
  Future<void> init() async {
    if (_initialized) return;

    _prefs = await SharedPreferences.getInstance();
    _tokenStorage = TokenStorage(_prefs);

    _sdk = NovdaSDK.create(
      baseUrl: _baseUrl,
      apiKey: _apiKey,
      tokenProvider: _tokenStorage,
    );

    _initialized = true;
    debugPrint('ServiceLocator initialized');
  }

  /// Get the SDK instance
  NovdaSDK get sdk {
    _assertInitialized();
    return _sdk;
  }

  /// Get the token storage
  TokenStorage get tokenStorage {
    _assertInitialized();
    return _tokenStorage;
  }

  /// Get SharedPreferences instance
  SharedPreferences get prefs {
    _assertInitialized();
    return _prefs;
  }

  /// Check if user is authenticated
  bool get isAuthenticated {
    _assertInitialized();
    return _tokenStorage.hasTokens;
  }

  /// Set the locale for API requests
  void setLocale(String locale) {
    _assertInitialized();
    _sdk.setLocale(locale);
  }

  /// Resolve the effective app theme for the current user.
  ///
  /// warm/calm map directly; auto is resolved by active child gender:
  /// boy -> calm, girl/unknown -> warm.
  Future<ThemeVariant> resolveThemeVariant() async {
    _assertInitialized();

    try {
      final user = await _sdk.user.getProfile();
      if (user.themePreference != ThemePreference.auto) {
        return ThemePreferenceResolver.resolve(
          preference: user.themePreference,
        );
      }

      final children = await _sdk.children.getChildren();
      final activeChild = ThemePreferenceResolver.activeChild(
        children,
        activeChildId: user.lastActiveChild,
      );

      return ThemePreferenceResolver.resolve(
        preference: user.themePreference,
        activeChildGender: activeChild?.gender,
      );
    } catch (_) {
      return ThemeVariant.warmOrange;
    }
  }

  void _assertInitialized() {
    assert(_initialized, 'ServiceLocator must be initialized before use');
  }
}

/// Convenience getter for ServiceLocator
ServiceLocator get services => ServiceLocator.instance;
