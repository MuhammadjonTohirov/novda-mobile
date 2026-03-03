import 'package:flutter/material.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';

extension ProfileLinksUiExtensions on BuildContext {
  static const _contentPadding = EdgeInsets.fromLTRB(16, 0, 16, 20);

  Widget profileLinksScreenBody({
    required String title,
    required VoidCallback onBackTap,
    required List<({String iconPath, String title, VoidCallback onTap})> items,
  }) {
    final colors = appColors;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: _contentPadding,
      children: [
        _profileLinksHeader(
          title: title,
          onBackTap: onBackTap,
        ).safeArea(bottom: false),
        const SizedBox(height: 16),
        profileLinksSection(items: items),
      ],
    ).container(color: colors.bgSecondary);
  }

  Widget profileLinksSection({
    required List<({String iconPath, String title, VoidCallback onTap})> items,
  }) {
    final colors = appColors;

    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          profileLinksTile(
            iconPath: items[i].iconPath,
            title: items[i].title,
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

  Widget profileLinksTile({
    required String iconPath,
    required String title,
    required VoidCallback onTap,
  }) {
    final colors = appColors;

    return Row(
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(colors.accent, BlendMode.srcIn),
              child: Image.asset(iconPath, width: 28, height: 28),
            ),
            const SizedBox(width: 14),
            Text(
              title,
              style: AppTypography.bodyLMedium.copyWith(
                color: colors.textPrimary,
              ),
            ).expanded(),
            Icon(Icons.chevron_right, size: 22, color: colors.textSecondary),
          ],
        )
        .paddingSymmetric(horizontal: 16, vertical: 12)
        .sized(height: 52)
        .inkWell(onTap: onTap);
  }

  Widget _profileLinksHeader({
    required String title,
    required VoidCallback onBackTap,
  }) {
    final colors = appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.arrow_back_rounded, size: 24, color: colors.textPrimary)
            .paddingOnly(right: 8, bottom: 8)
            .inkWell(onTap: onBackTap, borderRadius: BorderRadius.circular(20)),
        const SizedBox(height: 8),
        Text(
          title,
          style: AppTypography.headingL.copyWith(color: colors.textPrimary),
        ),
      ],
    );
  }
}
