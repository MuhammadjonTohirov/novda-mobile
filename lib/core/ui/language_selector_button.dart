import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Supported languages
enum AppLanguage {
  english('en', 'EN', 'English', 'logo_united_kingdom.png'),
  uzbek('uz', 'UZ', "O'zbek tili", 'logo_uzbekistan.png'),
  russian('ru', 'RU', 'Русский язык', 'logo_russia.png');

  const AppLanguage(this.code, this.shortCode, this.name, this.flagAsset);

  final String code;
  final String shortCode;
  final String name;
  final String flagAsset;

  String get flagPath => 'assets/images/$flagAsset';
}

/// Language selector button (shown in top-right corner)
class LanguageSelectorButton extends StatelessWidget {
  const LanguageSelectorButton({
    super.key,
    required this.language,
    required this.onTap,
  });

  final AppLanguage language;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: colors.bgPrimary,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: colors.bgPrimary,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Image.asset(
                  language.flagPath,
                  width: 24,
                  height: 24,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                language.shortCode,
                style: AppTypography.bodyMMedium.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Language selection tile for bottom sheet
class LanguageSelectionTile extends StatelessWidget {
  const LanguageSelectionTile({
    super.key,
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  final AppLanguage language;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            color: isSelected ? colors.bgSecondary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              ClipOval(
                child: Image.asset(
                  language.flagPath,
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  language.name,
                  style: AppTypography.bodyLMedium.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check,
                  color: colors.accent,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
