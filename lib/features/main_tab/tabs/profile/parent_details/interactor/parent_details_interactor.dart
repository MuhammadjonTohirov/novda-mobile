import 'package:novda/core/services/services.dart';
import 'package:novda_sdk/novda_sdk.dart';

class ParentDetailsInteractor {
  ParentDetailsInteractor({UserUseCase? userUseCase})
    : _userUseCase = userUseCase ?? services.sdk.user;

  final UserUseCase _userUseCase;

  Future<User> loadUserProfile() {
    return _userUseCase.getProfile();
  }

  Future<User> updateParentName({
    required User currentUser,
    required String name,
  }) {
    return _userUseCase.updateProfile(
      name: name,
      email: currentUser.email,
      preferredLocale: currentUser.preferredLocale,
      themePreference: currentUser.themePreference,
      notificationsEnabled: currentUser.notificationsEnabled,
    );
  }
}
