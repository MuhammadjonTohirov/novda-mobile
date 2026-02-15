import 'package:flutter/material.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/ui/ui.dart';
import '../view_model/profile_tab_view_model.dart';

extension ProfileTabUiExtensions on BuildContext {
  Widget profileTabBody({
    required ProfileTabViewModel viewModel,
    required VoidCallback onLogoutTap,
    required VoidCallback onActionTap,
    required VoidCallback onSettingsTap,
  }) {
    return RefreshIndicator(
      onRefresh: viewModel.load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          profileTopSection(viewModel: viewModel, onActionTap: onActionTap),
          const SizedBox(height: 16),
          profileMenuSection(
            items: [
              (
                title: l10n.profileSavedArticles,
                iconPath: 'assets/images/profile/icon_bookmark.png',
                trailingValue: viewModel.savedArticlesCount > 0
                    ? '${viewModel.savedArticlesCount}'
                    : '',
                onTap: onActionTap,
              ),
              (
                title: l10n.profileSettings,
                iconPath: 'assets/images/profile/icon_gear.png',
                trailingValue: '',
                onTap: onSettingsTap,
              ),
              (
                title: l10n.profileChangePhoneNumber,
                iconPath: 'assets/images/profile/icon_smartphone.png',
                trailingValue: '',
                onTap: onActionTap,
              ),
            ],
          ).paddingSymmetric(horizontal: 16),
          const SizedBox(height: 16),
          profileMenuSection(
            items: [
              (
                title: l10n.profileFollowUs,
                iconPath: 'assets/images/profile/icon_earth.png',
                trailingValue: '',
                onTap: onActionTap,
              ),
              (
                title: l10n.profileSupport,
                iconPath: 'assets/images/profile/icon_support.png',
                trailingValue: '',
                onTap: onActionTap,
              ),
              (
                title: l10n.profileLegalDocuments,
                iconPath: 'assets/images/profile/icon_legal_doc.png',
                trailingValue: '',
                onTap: onActionTap,
              ),
            ],
          ).paddingSymmetric(horizontal: 16),
          const SizedBox(height: 20),
          profileLogoutButton(onTap: onLogoutTap),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

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

  Widget profileLogoutBottomSheet({
    required VoidCallback onCancel,
    required VoidCallback onLogout,
  }) {
    final colors = appColors;

    return AppBottomSheetContent(
      children: [
        Text(
          l10n.profileLogoutConfirmTitle,
          style: AppTypography.headingL.copyWith(color: colors.textPrimary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          l10n.profileLogoutConfirmDescription,
          style: AppTypography.bodyLRegular.copyWith(
            color: colors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: Text(l10n.settingsCancel, style: AppTypography.headingS)
                    .center()
                    .container(
                      decoration: BoxDecoration(
                        color: colors.bgSecondary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    )
                    .inkWell(
                      onTap: onCancel,
                      borderRadius: BorderRadius.circular(16),
                    ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 48,
                child: Text(l10n.homeLogOut, style: AppTypography.headingS)
                    .center()
                    .container(
                      decoration: BoxDecoration(
                        color: colors.buttonPressing,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    )
                    .inkWell(
                      onTap: onLogout,
                      borderRadius: BorderRadius.circular(16),
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget profileIcon({required String iconPath, double size = 24}) {
    final colors = appColors;

    return ColorFiltered(
      colorFilter: ColorFilter.mode(colors.accent, BlendMode.srcIn),
      child: Image.asset(iconPath, width: size, height: size),
    );
  }

  String _profileAvatarByGender(Gender gender) {
    return switch (gender) {
      Gender.boy => 'assets/images/img_boy_avatar.png',
      Gender.girl => 'assets/images/img_girl_avatar.png',
      _ => 'assets/images/icon_baby.png',
    };
  }
}
