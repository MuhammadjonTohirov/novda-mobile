import '../../../core/base/base_view_model.dart';
import 'main_tab_interactor.dart';

class MainTabViewModel extends BaseViewModel {
  MainTabViewModel({MainTabInteractor? interactor})
    : _interactor = interactor ?? MainTabInteractor();

  final MainTabInteractor _interactor;

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
    await _interactor.logout();
  }
}
