import 'package:flutter/material.dart';

import '../../../../../core/extensions/extensions.dart';
import '../view_model/profile_tab_view_model.dart';
import 'profile_tab_ui_menu_extensions.dart';
import 'profile_tab_ui_top_extensions.dart';

extension ProfileTabUiBodyExtensions on BuildContext {
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
}
