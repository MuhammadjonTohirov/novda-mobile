import 'package:flutter/material.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/ui.dart';

/// Shared bottom action bar used across auth flow screens.
class AuthBottomBar extends StatelessWidget {
  const AuthBottomBar({
    super.key,
    required this.onPressed,
    required this.isEnabled,
    this.isLoading = false,
  });

  final VoidCallback onPressed;
  final bool isEnabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.bgPrimary,
        border: Border(
          top: BorderSide(color: colors.bgSecondary, width: 1),
        ),
      ),
      child: AppButton(
        text: l10n.continueButton,
        onPressed: onPressed,
        isEnabled: isEnabled,
        isLoading: isLoading,
      ).safeArea(top: false),
    );
  }
}
