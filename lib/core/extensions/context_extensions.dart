import 'package:flutter/material.dart';
import 'package:novda_components/novda_components.dart' show WidgetExtensions;

import '../../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

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

/// Shared loading / error / retry views.
extension ViewStateExtension on BuildContext {
  Widget loadErrorView({
    String? message,
    required VoidCallback onRetry,
  }) {
    final colors = appColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message ?? l10n.homeFailedLoad,
          style: AppTypography.bodyMRegular.copyWith(
            color: colors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        ElevatedButton(onPressed: onRetry, child: Text(l10n.homeRetry)),
      ],
    ).paddingAll(24).center();
  }
}

/// Common AppBar factory.
extension AppBarExtension on BuildContext {
  PreferredSizeWidget novdaAppBar({
    Color? backgroundColor,
    Widget? title,
    Widget? leading,
    List<Widget>? actions,
    bool showBackButton = true,
  }) {
    final colors = appColors;

    return AppBar(
      backgroundColor: backgroundColor ?? colors.bgPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: title,
      actions: actions,
      leading: leading ??
          (showBackButton
              ? IconButton(
                  icon: Icon(Icons.arrow_back, color: colors.textPrimary),
                  onPressed: () => Navigator.of(this).pop(),
                )
              : null),
    );
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
