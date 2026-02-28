import 'package:novda_core/novda_core.dart';

/// Presentation-layer asset path for [AppLanguage].
extension AppLanguageFlagExtension on AppLanguage {
  /// Full asset path to the flag image for this language.
  String get flagPath => 'assets/images/$flagAsset';
}
