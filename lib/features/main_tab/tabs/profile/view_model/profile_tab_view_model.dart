import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/base/base_view_model.dart';
import '../interactor/profile_tab_interactor.dart';

class ProfileTabViewModel extends BaseViewModel {
  ProfileTabViewModel({ProfileTabInteractor? interactor})
    : _interactor = interactor ?? ProfileTabInteractor();

  final ProfileTabInteractor _interactor;

  ProfileTabData _data = ProfileTabData.empty();

  String get parentName => _data.user?.name.trim() ?? '';
  ChildListItem? get activeChild => _data.activeChild;
  int get savedArticlesCount => _data.savedArticlesCount;
  bool get hasContent => _data.hasContent;

  Future<void> load() async {
    setLoading();

    try {
      _data = await _interactor.loadProfileData();
      setSuccess();
    } catch (error) {
      handleException(error);
    }
  }
}
