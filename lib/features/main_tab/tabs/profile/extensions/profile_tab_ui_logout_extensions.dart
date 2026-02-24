import 'package:flutter/material.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/ui/ui.dart';

extension ProfileTabUiLogoutExtensions on BuildContext {
  Widget profileLogoutBottomSheet({
    required VoidCallback onCancel,
    required VoidCallback onLogout,
  }) {
    final colors = appColors;

    return AppBottomSheetContent(
      children: [
        Text(
          l10n.profileLogoutConfirmTitle,
          style: AppTypography.headingL.copyWith(color: colors.textPrimary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          l10n.profileLogoutConfirmDescription,
          style: AppTypography.bodyLRegular.copyWith(
            color: colors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: Text(l10n.settingsCancel, style: AppTypography.headingS)
                    .center()
                    .container(
                      decoration: BoxDecoration(
                        color: colors.bgSecondary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    )
                    .inkWell(
                      onTap: onCancel,
                      borderRadius: BorderRadius.circular(16),
                    ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 48,
                child: Text(l10n.homeLogOut, style: AppTypography.headingS)
                    .center()
                    .container(
                      decoration: BoxDecoration(
                        color: colors.buttonPressing,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    )
                    .inkWell(
                      onTap: onLogout,
                      borderRadius: BorderRadius.circular(16),
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
