import 'package:flutter/material.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import '../extensions/profile_links_ui_extensions.dart';

class FollowUsScreen extends StatelessWidget {
  const FollowUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.bgSecondary,
      body: context.profileLinksScreenBody(
        title: context.l10n.profileFollowUs,
        onBackTap: () => Navigator.of(context).pop(),
        items: [
          (
            iconPath: 'assets/images/profile/icon_telegram.png',
            title: context.l10n.profileFollowUsOnTelegram,
            onTap: () => context.showSnackMessage(context.l10n.homeComingSoon),
          ),
          (
            iconPath: 'assets/images/profile/icon_x.png',
            title: context.l10n.profileFollowUsOnX,
            onTap: () => context.showSnackMessage(context.l10n.homeComingSoon),
          ),
          (
            iconPath: 'assets/images/profile/icon_instagram.png',
            title: context.l10n.profileFollowUsOnInstagram,
            onTap: () => context.showSnackMessage(context.l10n.homeComingSoon),
          ),
        ],
      ),
    );
  }
}
