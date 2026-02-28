import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Extension on BuildContext for easy access to localizations.
extension LocalizationsExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

/// SnackBar helpers to eliminate duplicated `_showActionErrorIfAny` / `_showComingSoon`.
extension SnackBarExtension on BuildContext {
  /// Shows a plain [SnackBar] with the given [message].
  void showSnackMessage(String message) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Consumes [error] and, if non-empty, schedules a SnackBar after the current frame.
  ///
  /// Replaces the duplicated `_showActionErrorIfAny` pattern.
  void showDeferredSnackIfNeeded(String? error) {
    if (error == null || error.isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showSnackMessage(error);
    });
  }
}

/// Navigation shortcuts.
extension NavigationExtension on BuildContext {
  /// Push a [MaterialPageRoute] with the given [builder].
  Future<T?> pushRoute<T>(Widget page) {
    return Navigator.of(this).push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// Push and remove all previous routes.
  Future<T?> pushRouteAndRemoveAll<T extends Object?>(Widget page) {
    return Navigator.of(this).pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  /// Pop the current route.
  void pop<T extends Object?>([T? result]) => Navigator.of(this).pop(result);
}
