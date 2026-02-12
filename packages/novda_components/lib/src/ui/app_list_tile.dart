import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// List tile component with optional background
class AppListTile extends StatelessWidget {
  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.isSelected = false,
    this.showBackground = false,
    this.onTap,
    this.padding,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool isSelected;
  final bool showBackground;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final content = Row(
      children: [
        if (leading != null) ...[leading!, const SizedBox(width: 12)],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppTypography.bodyLMedium.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: AppTypography.bodyMRegular.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 12),
          trailing!,
        ] else if (isSelected) ...[
          const SizedBox(width: 12),
          Icon(Icons.check, color: colors.accent, size: 24),
        ],
      ],
    );

    if (showBackground) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            decoration: BoxDecoration(
              color: colors.bgPrimary,
              borderRadius: BorderRadius.circular(12),
            ),
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: content,
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: content,
      ),
    );
  }
}

/// Selectable list tile for language selection, etc.
class AppSelectableTile extends StatelessWidget {
  const AppSelectableTile({
    super.key,
    required this.title,
    this.leading,
    this.isSelected = false,
    this.showBackground = false,
    this.onTap,
  });

  final String title;
  final Widget? leading;
  final bool isSelected;
  final bool showBackground;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final content = Row(
      children: [
        if (leading != null) ...[leading!, const SizedBox(width: 12)],
        Expanded(
          child: Text(
            title,
            style: AppTypography.bodyLMedium.copyWith(
              color: colors.textPrimary,
            ),
          ),
        ),
        if (isSelected) ...[
          const SizedBox(width: 12),
          Icon(Icons.check, color: colors.accent, size: 24),
        ],
      ],
    );

    if (showBackground) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            decoration: BoxDecoration(
              color: isSelected ? colors.bgSecondary : colors.bgPrimary,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: content,
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: content,
      ),
    );
  }
}
