import 'package:flutter/material.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import '../extensions/profile_links_ui_extensions.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.bgSecondary,
      body: context.profileLinksScreenBody(
        title: context.l10n.profileSupport,
        onBackTap: () => Navigator.of(context).pop(),
        items: [
          (
            iconPath: 'assets/images/profile/icon_telegram.png',
            title: context.l10n.profileSupportTelegram,
            onTap: () => context.showSnackMessage(context.l10n.homeComingSoon),
          ),
          (
            iconPath: 'assets/images/profile/icon_mail.png',
            title: context.l10n.profileSupportEmail,
            onTap: () => context.showSnackMessage(context.l10n.homeComingSoon),
          ),
        ],
      ),
    );
  }
}
