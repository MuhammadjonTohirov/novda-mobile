import 'package:flutter/material.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import '../extensions/profile_links_ui_extensions.dart';

class LegalDocumentsScreen extends StatelessWidget {
  const LegalDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.bgSecondary,
      body: context.profileLinksScreenBody(
        title: context.l10n.profileLegalDocuments,
        onBackTap: () => Navigator.of(context).pop(),
        items: [
          (
            iconPath: 'assets/images/profile/icon_hugeicons_legal-hammer.png',
            title: context.l10n.profileLegalTermsConditions,
            onTap: () => context.showSnackMessage(context.l10n.homeComingSoon),
          ),
          (
            iconPath: 'assets/images/profile/icon_hugeicons_policy.png',
            title: context.l10n.profileLegalPrivacyPolicy,
            onTap: () => context.showSnackMessage(context.l10n.homeComingSoon),
          ),
        ],
      ),
    );
  }
}
