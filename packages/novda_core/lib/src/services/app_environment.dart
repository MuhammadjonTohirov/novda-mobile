/// Application environment configuration.
///
/// Reads `STAGING` from `--dart-define` to determine the active environment.
/// Usage:
///   flutter run --dart-define=STAGING=true       → staging
///   flutter run                                   → production (default)
class AppEnvironment {
  AppEnvironment._();

  static const _isStaging = bool.fromEnvironment('STAGING');

  /// Whether the app is running in staging mode.
  static bool get isStaging => _isStaging;

  /// The base URL for the current environment.
  static String get baseUrl =>
      _isStaging ? _stagingUrl : _productionUrl;

  static const _stagingUrl = 'http://dev.mttech.uz';
  static const _productionUrl = 'https://kidscare.uzyol.uz';
}
