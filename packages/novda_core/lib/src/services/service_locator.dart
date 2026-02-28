import 'package:flutter/foundation.dart';
import 'package:novda_sdk/novda_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/theme_variant.dart';
import 'auth_service.dart';
import 'theme_resolution_service.dart';
import 'token_storage.dart';

/// Service locator for dependency injection
class ServiceLocator {
  ServiceLocator._();

  static ServiceLocator? _instance;
  static ServiceLocator get instance {
    _instance ??= ServiceLocator._();
    return _instance!;
  }

  static const _baseUrl = 'http://94.158.51.9:8000';
  // static const _baseUrl = 'https://kidscare.uzyol.uz';
  static const _apiKey = 'KIDS_CARE_API_KEY_9839283ad98asdj123j23a0s9dia9d';

  late final SharedPreferences _prefs;
  late final TokenStorage _tokenStorage;
  late final NovdaSDK _sdk;
  late final AuthService _authService;
  late final ThemeResolutionService _themeResolutionService;

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

    _authService = AuthService(
      tokenStorage: _tokenStorage,
      userUseCase: _sdk.user,
    );

    _themeResolutionService = ThemeResolutionService(
      userUseCase: _sdk.user,
      childrenUseCase: _sdk.children,
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

  /// Get the auth service
  AuthService get authService {
    _assertInitialized();
    return _authService;
  }

  /// Get the theme resolution service
  ThemeResolutionService get themeResolutionService {
    _assertInitialized();
    return _themeResolutionService;
  }

  /// Check if user is authenticated
  bool get isAuthenticated {
    _assertInitialized();
    return _authService.isAuthenticated;
  }

  /// Validate the current auth session with backend profile endpoint.
  Future<bool> hasValidSession() => _authService.hasValidSession();

  /// Set the locale for API requests
  void setLocale(String locale) {
    _assertInitialized();
    _sdk.setLocale(locale);
  }

  /// Resolve the effective app theme for the current user.
  Future<ThemeVariant> resolveThemeVariant({int? selectedChildId}) =>
      _themeResolutionService.resolveThemeVariant(
        selectedChildId: selectedChildId,
      );

  void _assertInitialized() {
    assert(_initialized, 'ServiceLocator must be initialized before use');
  }
}

/// Convenience getter for ServiceLocator
ServiceLocator get services => ServiceLocator.instance;
