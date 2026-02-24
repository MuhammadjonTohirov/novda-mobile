import 'package:flutter/material.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';

extension ProfileTabUiMenuExtensions on BuildContext {
  Widget profileMenuSection({
    required List<
      ({
        String title,
        String iconPath,
        String trailingValue,
        VoidCallback onTap,
      })
    >
    items,
  }) {
    final colors = appColors;

    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          profileMenuTile(
            title: items[i].title,
            iconPath: items[i].iconPath,
            trailingValue: items[i].trailingValue,
            onTap: items[i].onTap,
          ),
          if (i != items.length - 1) const SizedBox(height: 4),
        ],
      ],
    ).container(
      decoration: BoxDecoration(
        color: colors.bgPrimary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
    );
  }

  Widget profileMenuTile({
    required String title,
    required String iconPath,
    required String trailingValue,
    required VoidCallback onTap,
  }) {
    final colors = appColors;

    return Row(
      children: [
        profileIcon(iconPath: iconPath),
        const SizedBox(width: 14),
        Text(
          title,
          style: AppTypography.bodyLMedium.copyWith(color: colors.textPrimary),
        ).expanded(),
        if (trailingValue.isNotEmpty)
          Text(
            trailingValue,
            style: AppTypography.bodyLRegular.copyWith(
              color: colors.textSecondary,
            ),
          ).paddingOnly(right: 8),
        Icon(Icons.chevron_right, size: 30, color: colors.textSecondary),
      ],
    ).paddingSymmetric(horizontal: 16, vertical: 12).inkWell(onTap: onTap);
  }

  Widget profileLogoutButton({required VoidCallback onTap}) {
    final colors = appColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        profileIcon(
          iconPath: 'assets/images/profile/icon_logout.png',
          size: 28,
        ),
        const SizedBox(width: 10),
        Text(
          l10n.homeLogOut,
          style: AppTypography.headingM.copyWith(color: colors.textOnPrimary),
        ),
      ],
    ).inkWell(onTap: onTap);
  }

  Widget profileIcon({required String iconPath, double size = 24}) {
    final colors = appColors;

    return ColorFiltered(
      colorFilter: ColorFilter.mode(colors.accent, BlendMode.srcIn),
      child: Image.asset(iconPath, width: size, height: size),
    );
  }
}
