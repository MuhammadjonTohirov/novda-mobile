import 'package:flutter/material.dart';

import 'package:novda/core/extensions/extensions.dart';
import 'package:novda/core/theme/app_theme.dart';

import '../view_model/settings_view_model.dart';
import 'settings_screen_ui_options_extensions.dart';

extension SettingsScreenUiBodyExtensions on BuildContext {
  Widget settingsScreenContent({
    required SettingsViewModel viewModel,
    required VoidCallback onThemeTap,
    required VoidCallback onLanguageTap,
    required ValueChanged<bool> onNotificationChanged,
    required VoidCallback onDeleteTap,
  }) {
    final colors = appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.settingsTitle,
          style: AppTypography.headingL.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: 18),
        settingsOptionsCard(
          children: [
            settingsOptionTile(
              iconPath: 'assets/images/icon_paint_board.png',
              title: l10n.settingsAppTheme,
              trailing: settingsValueWithChevron(
                value: settingsThemeLabel(viewModel.themePreference),
              ),
              onTap: onThemeTap,
            ),
            settingsOptionTile(
              iconPath: 'assets/images/icon_language.png',
              title: l10n.settingsLanguage,
              trailing: settingsValueWithChevron(
                value: settingsLanguageLabel(viewModel.preferredLocale),
              ),
              onTap: onLanguageTap,
            ),
            settingsOptionTile(
              iconPath: 'assets/images/icon_notification.png',
              title: l10n.settingsNotifications,
              trailing: Switch.adaptive(
                value: viewModel.notificationsEnabled,
                onChanged: viewModel.isUpdatingNotifications
                    ? null
                    : onNotificationChanged,
                activeTrackColor: Colors.green.shade600,
              ).sized(height: 24),
            ),
          ],
        ),
        const Spacer(),
        Text(
              l10n.settingsDeleteAccount,
              style: AppTypography.headingS.copyWith(color: colors.error),
              textAlign: TextAlign.center,
            )
            .center()
            .sized(height: 50)
            .inkWell(
              onTap: onDeleteTap,
              borderRadius: BorderRadius.circular(14),
            ),
        const SizedBox(height: 20),
      ],
    ).safeArea(top: false, bottom: false).paddingAll(16);
  }
}
