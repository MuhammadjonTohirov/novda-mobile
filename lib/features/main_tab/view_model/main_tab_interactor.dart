import '../../../core/services/services.dart';

/// Interactor handling business logic for the main tab.
class MainTabInteractor {
  MainTabInteractor({TokenStorage? tokenStorage})
    : _tokenStorage = tokenStorage ?? services.tokenStorage;

  final TokenStorage _tokenStorage;

  Future<void> logout() async {
    await _tokenStorage.clearTokens();
  }
}
