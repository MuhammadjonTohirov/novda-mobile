import 'package:flutter/material.dart';

import 'package:novda/core/app/app.dart';
import 'package:novda/core/extensions/extensions.dart';
import 'package:novda/core/theme/app_theme.dart';
import 'package:novda/core/ui/ui.dart';
import 'package:novda_sdk/novda_sdk.dart';

extension SettingsScreenUiPickersExtensions on BuildContext {
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
}
