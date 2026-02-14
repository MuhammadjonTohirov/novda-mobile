import 'package:novda/core/app/app.dart';
import 'package:novda/core/base/base_view_model.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../interactor/settings_interactor.dart';

class SettingsViewModel extends BaseViewModel {
  SettingsViewModel({SettingsInteractor? interactor})
    : _interactor = interactor ?? SettingsInteractor();

  final SettingsInteractor _interactor;

  ThemePreference _themePreference = ThemePreference.auto;
  PreferredLocale _preferredLocale = PreferredLocale.en;
  bool _notificationsEnabled = true;
  int? _lastActiveChildId;

  bool _isUpdatingTheme = false;
  bool _isUpdatingLanguage = false;
  bool _isUpdatingNotifications = false;
  bool _isDeletingAccount = false;
  bool _hasLoaded = false;
  String? _actionErrorMessage;

  ThemePreference get themePreference => _themePreference;
  PreferredLocale get preferredLocale => _preferredLocale;
  bool get notificationsEnabled => _notificationsEnabled;

  bool get isUpdatingTheme => _isUpdatingTheme;
  bool get isUpdatingLanguage => _isUpdatingLanguage;
  bool get isUpdatingNotifications => _isUpdatingNotifications;
  bool get isDeletingAccount => _isDeletingAccount;
  bool get hasLoaded => _hasLoaded;

  String? consumeActionError() {
    final message = _actionErrorMessage;
    _actionErrorMessage = null;
    return message;
  }

  Future<void> load() async {
    setLoading();

    try {
      final user = await _interactor.loadUserProfile();
      _applyUser(user);
      _hasLoaded = true;
      setSuccess();
    } catch (error) {
      handleException(error);
    }
  }

  Future<ThemeVariant?> changeTheme(ThemePreference preference) async {
    if (_isUpdatingTheme) return null;

    _isUpdatingTheme = true;
    notifyListeners();

    try {
      final user = await _interactor.updateThemePreference(preference);
      _applyUser(user);
      return _interactor.resolveThemeVariant(
        selectedChildId: _lastActiveChildId,
      );
    } catch (error) {
      _actionErrorMessage = _errorText(error);
      return null;
    } finally {
      _isUpdatingTheme = false;
      notifyListeners();
    }
  }

  Future<PreferredLocale?> changeLanguage(PreferredLocale locale) async {
    if (_isUpdatingLanguage) return null;

    _isUpdatingLanguage = true;
    notifyListeners();

    try {
      final user = await _interactor.updateLanguage(locale);
      _applyUser(user);
      _interactor.setApiLocale(_preferredLocale.name);
      return _preferredLocale;
    } catch (error) {
      _actionErrorMessage = _errorText(error);
      return null;
    } finally {
      _isUpdatingLanguage = false;
      notifyListeners();
    }
  }

  Future<void> changeNotifications(bool enabled) async {
    if (_isUpdatingNotifications) return;

    final previous = _notificationsEnabled;
    _notificationsEnabled = enabled;
    _isUpdatingNotifications = true;
    notifyListeners();

    try {
      final user = await _interactor.updateNotifications(enabled);
      _applyUser(user);
    } catch (error) {
      _notificationsEnabled = previous;
      _actionErrorMessage = _errorText(error);
    } finally {
      _isUpdatingNotifications = false;
      notifyListeners();
    }
  }

  Future<bool> deleteAccount() async {
    if (_isDeletingAccount) return false;

    _isDeletingAccount = true;
    notifyListeners();

    try {
      await _interactor.deleteAccount();
      return true;
    } catch (error) {
      _actionErrorMessage = _errorText(error);
      return false;
    } finally {
      _isDeletingAccount = false;
      notifyListeners();
    }
  }

  void _applyUser(User user) {
    _themePreference = user.themePreference;
    _preferredLocale = PreferredLocale.fromString(user.preferredLocale.name);
    _notificationsEnabled = user.notificationsEnabled;
    _lastActiveChildId = user.lastActiveChild;
  }

  String _errorText(Object error) {
    if (error is ApiException) return error.message;
    return error.toString();
  }
}
