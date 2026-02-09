import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Extension on BuildContext for easy access to localizations
extension LocalizationsExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
