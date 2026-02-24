import 'package:flutter/material.dart';

import 'package:novda/core/app/app.dart';
import 'package:novda/core/extensions/extensions.dart';
import 'package:novda/core/theme/app_theme.dart';
import 'package:novda_sdk/novda_sdk.dart';

extension SettingsScreenUiOptionsExtensions on BuildContext {
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
          style: AppTypography.bodyLRegular.copyWith(
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(width: 4),
        Icon(Icons.chevron_right, size: 30, color: colors.textSecondary),
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
