import '../../../core/base/base_view_model.dart';
import '../../../core/services/services.dart';

class MainTabViewModel extends BaseViewModel {
  MainTabViewModel({TokenStorage? tokenStorage})
    : _tokenStorage = tokenStorage ?? services.tokenStorage;

  final TokenStorage _tokenStorage;

  int _selectedTabIndex = 0;

  int get selectedTabIndex => _selectedTabIndex;

  void selectTab(int index) {
    if (index == 2) {
      // Show add activity sheet
      return;
    }
    
    if (_selectedTabIndex == index) return;

    _selectedTabIndex = index;
    notifyListeners();
  }

  Future<void> logout() async {
    await _tokenStorage.clearTokens();
  }
}
