import 'package:novda/core/app/app.dart';
import 'package:novda/core/services/services.dart';
import 'package:novda_sdk/novda_sdk.dart';

class SettingsInteractor {
  SettingsInteractor({UserUseCase? userUseCase})
    : _userUseCase = userUseCase ?? services.sdk.user;

  final UserUseCase _userUseCase;

  Future<User> loadUserProfile() {
    return _userUseCase.getProfile();
  }

  Future<User> updateThemePreference(ThemePreference preference) {
    return _userUseCase.updateProfile(themePreference: preference);
  }

  Future<User> updateLanguage(PreferredLocale locale) {
    return _userUseCase.updateProfile(preferredLocale: locale);
  }

  Future<User> updateNotifications(bool enabled) {
    return _userUseCase.updateProfile(notificationsEnabled: enabled);
  }

  Future<void> deleteAccount() async {
    await _userUseCase.deleteAccount();
    await services.tokenStorage.clearTokens();
  }

  Future<ThemeVariant> resolveThemeVariant({int? selectedChildId}) {
    return services.resolveThemeVariant(selectedChildId: selectedChildId);
  }

  void setApiLocale(String localeCode) {
    services.setLocale(localeCode);
  }
}
