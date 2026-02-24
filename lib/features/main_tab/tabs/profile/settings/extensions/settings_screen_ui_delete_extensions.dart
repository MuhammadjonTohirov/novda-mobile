import 'package:flutter/material.dart';

import 'package:novda/core/extensions/extensions.dart';
import 'package:novda/core/theme/app_theme.dart';
import 'package:novda/core/ui/ui.dart';

extension SettingsScreenUiDeleteExtensions on BuildContext {
  Widget settingsDeleteAccountSheet({
    required bool isDeleting,
    required VoidCallback onCancel,
    required VoidCallback onDelete,
  }) {
    final colors = appColors;

    return AppBottomSheetContent(
      padding: EdgeInsets.all(16),
      children: [
        Text(
          l10n.settingsDeleteAccountTitle,
          style: AppTypography.headingL.copyWith(color: colors.textPrimary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.settingsDeleteAccountDescription,
          style: AppTypography.bodyLRegular.copyWith(
            color: colors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: isDeleting ? null : onCancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.bgSecondary,
                    foregroundColor: colors.textPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(l10n.settingsCancel),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: isDeleting ? null : onDelete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.error,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: isDeleting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(l10n.settingsDelete),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
