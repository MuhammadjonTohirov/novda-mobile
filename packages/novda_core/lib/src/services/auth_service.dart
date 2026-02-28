import 'package:novda_sdk/novda_sdk.dart';

import 'token_storage.dart';

/// Encapsulates authentication state checks.
class AuthService {
  AuthService({
    required TokenStorage tokenStorage,
    required UserUseCase userUseCase,
  })  : _tokenStorage = tokenStorage,
       _userUseCase = userUseCase;

  final TokenStorage _tokenStorage;
  final UserUseCase _userUseCase;

  /// Whether tokens exist locally (does not validate with backend).
  bool get isAuthenticated => _tokenStorage.hasTokens;

  /// Validates the current session by calling `/me`.
  ///
  /// Returns `true` only when tokens exist and the profile can be fetched.
  /// Clears tokens on failure.
  Future<bool> hasValidSession() async {
    if (!_tokenStorage.hasTokens) return false;

    try {
      await _userUseCase.getProfile();
      return true;
    } catch (_) {
      await _tokenStorage.clearTokens();
      return false;
    }
  }
}
