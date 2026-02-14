import 'package:flutter/material.dart';
import 'package:novda/core/app/app.dart';
import 'package:novda/core/extensions/extensions.dart';
import 'package:novda/core/theme/app_theme.dart';
import 'package:novda/core/ui/ui.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../view_model/settings_view_model.dart';

extension SettingsScreenUiExtensions on BuildContext {
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
        .inkWell(onTap: onDeleteTap, borderRadius: BorderRadius.circular(14)),
        const SizedBox(height: 20),
      ],
    ).safeArea(top: false, bottom: false).paddingAll(16);
  }

  Widget settingsOptionsCard({required List<Widget> children}) {
    final colors = appColors;

    return Column(children: children).container(
      decoration: BoxDecoration(
        color: colors.bgPrimary,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.symmetric(vertical: 0),
    );
  }

  Widget settingsOptionTile({
    required String iconPath,
    required String title,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    final colors = appColors;

    final row = Row(
      children: [
        settingsLeadingIcon(iconPath),
        const SizedBox(width: 14),
        Text(
          title,
          style: AppTypography.bodyLMedium.copyWith(color: colors.textPrimary),
        ).expanded(),
        trailing,
      ],
    ).paddingSymmetric(horizontal: 16, vertical: 14);

    if (onTap == null) return row;

    return row.inkWell(onTap: onTap, borderRadius: BorderRadius.circular(32));
  }

  Widget settingsLeadingIcon(String iconPath) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(appColors.accent, BlendMode.srcIn),
      child: Image.asset(iconPath, width: 24, height: 24),
    );
  }

  Widget settingsValueWithChevron({required String value}) {
    final colors = appColors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTypography.bodyLRegular.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(width: 4),
        Icon(Icons.chevron_right, size: 30, color: colors.textSecondary),
      ],
    );
  }

  Widget settingsThemePickerSheet({
    required ThemePreference selected,
    required ValueChanged<ThemePreference> onSelect,
  }) {
    return AppBottomSheetContent(
      padding: EdgeInsets.all(16),
      children: [
        settingsPickerTile(
          title: l10n.settingsThemeWarm,
          icon: Icon(Icons.wb_sunny_outlined, color: appColors.accent),
          selected: selected == ThemePreference.warm,
          onTap: () => onSelect(ThemePreference.warm),
        ),
        settingsPickerTile(
          title: l10n.settingsThemeCalm,
          icon: Icon(Icons.cloud_outlined, color: appColors.accent),
          selected: selected == ThemePreference.calm,
          onTap: () => onSelect(ThemePreference.calm),
        ),
        settingsPickerTile(
          title: l10n.settingsThemeAutoWarm,
          icon: Icon(Icons.auto_awesome_outlined, color: appColors.accent),
          selected: selected == ThemePreference.auto,
          onTap: () => onSelect(ThemePreference.auto),
        ),
      ],
    );
  }

  Widget settingsLanguagePickerSheet({
    required PreferredLocale selected,
    required ValueChanged<PreferredLocale> onSelect,
  }) {
    return AppBottomSheetContent(
      padding: EdgeInsets.all(16),
      children: [
        settingsPickerTile(
          title: AppLanguage.english.name,
          icon: ClipOval(
            child: Image.asset(
              AppLanguage.english.flagPath,
              width: 24,
              height: 24,
            ),
          ),
          selected: selected == PreferredLocale.en,
          onTap: () => onSelect(PreferredLocale.en),
        ),
        settingsPickerTile(
          title: AppLanguage.uzbek.name,
          icon: ClipOval(
            child: Image.asset(
              AppLanguage.uzbek.flagPath,
              width: 24,
              height: 24,
            ),
          ),
          selected: selected == PreferredLocale.uz,
          onTap: () => onSelect(PreferredLocale.uz),
        ),
        settingsPickerTile(
          title: AppLanguage.russian.name,
          icon: ClipOval(
            child: Image.asset(
              AppLanguage.russian.flagPath,
              width: 24,
              height: 24,
            ),
          ),
          selected: selected == PreferredLocale.ru,
          onTap: () => onSelect(PreferredLocale.ru),
        ),
      ],
    );
  }

  Widget settingsPickerTile({
    required String title,
    required Widget icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final colors = appColors;

    return Row(
          children: [
            icon,
            const SizedBox(width: 14),
            Text(
              title,
              style: AppTypography.bodyLMedium.copyWith(
                color: colors.textPrimary,
              ),
            ).expanded(),
            if (selected)
              Icon(Icons.check_rounded, color: colors.accent, size: 24),
          ],
        )
        .container(
          decoration: BoxDecoration(
            color: selected ? colors.bgSecondary : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        )
        .inkWell(onTap: onTap, borderRadius: BorderRadius.circular(14));
  }

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

  String settingsThemeLabel(ThemePreference preference) {
    return switch (preference) {
      ThemePreference.warm => l10n.settingsThemeWarm,
      ThemePreference.calm => l10n.settingsThemeCalm,
      ThemePreference.auto => l10n.settingsThemeAutoWarm,
    };
  }

  String settingsLanguageLabel(PreferredLocale locale) {
    return switch (locale) {
      PreferredLocale.en => AppLanguage.english.name,
      PreferredLocale.uz => AppLanguage.uzbek.name,
      PreferredLocale.ru => AppLanguage.russian.name,
    };
  }
}
