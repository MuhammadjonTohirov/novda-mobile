import 'package:flutter/material.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import '../view_model/profile_tab_view_model.dart';

extension ProfileTabUiTopExtensions on BuildContext {
  Widget profileTopSection({
    required ProfileTabViewModel viewModel,
    required VoidCallback onActionTap,
  }) {
    final colors = appColors;
    final parentTitle = viewModel.parentName.isEmpty
        ? l10n.profileParent
        : viewModel.parentName;
    final activeChild = viewModel.activeChild;

    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.profileTitle,
              style: AppTypography.headingL.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: 16),
            Row(
                  children: [
                    Text(
                      parentTitle,
                      style: AppTypography.bodyLMedium.copyWith(
                        color: colors.textPrimary,
                      ),
                    ).expanded(),
                    Icon(
                      Icons.edit_outlined,
                      size: 24,
                      color: colors.textSecondary,
                    ),
                  ],
                )
                .container(
                  decoration: BoxDecoration(
                    color: colors.bgPrimary,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: colors.border),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                )
                .inkWell(
                  onTap: onActionTap,
                  borderRadius: BorderRadius.circular(18),
                ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      l10n.profileMyBabies,
                      style: AppTypography.headingS.copyWith(
                        color: colors.textPrimary,
                      ),
                    ).expanded(),
                    Text(
                      l10n.profileAdd,
                      style: AppTypography.bodyMMedium.copyWith(
                        color: colors.accent,
                      ),
                    ).inkWell(onTap: onActionTap),
                  ],
                ),
                const SizedBox(height: 14),
                if (activeChild == null)
                  Text(
                    l10n.homeNoActiveChildSelected,
                    style: AppTypography.bodyMRegular.copyWith(
                      color: colors.textSecondary,
                    ),
                  )
                else
                  Row(
                    children: [
                      Image.asset(
                        _profileAvatarByGender(activeChild.gender),
                        width: 44,
                        height: 44,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activeChild.name,
                            style: AppTypography.bodyLMedium.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                          Text(
                            activeChild.ageDisplay,
                            style: AppTypography.bodyMRegular.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ).expanded(),
                      Icon(
                        Icons.chevron_right,
                        size: 30,
                        color: colors.textSecondary,
                      ),
                    ],
                  ).inkWell(onTap: onActionTap),
              ],
            ).container(
              decoration: BoxDecoration(
                color: colors.bgPrimary,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: colors.border),
              ),
              padding: const EdgeInsets.all(16),
            ),
          ],
        )
        .paddingOnly(left: 16, right: 16, bottom: 16)
        .safeArea(bottom: false)
        .container(color: colors.bgSoft);
  }

  String _profileAvatarByGender(Gender gender) {
    return switch (gender) {
      Gender.boy => 'assets/images/img_boy_avatar.png',
      Gender.girl => 'assets/images/img_girl_avatar.png',
      _ => 'assets/images/icon_baby.png',
    };
  }
}
