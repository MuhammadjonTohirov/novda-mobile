import 'package:flutter/material.dart';
import 'package:novda_components/novda_components.dart' as components;

import '../../../l10n/app_localizations.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key, required this.onSuccess});

  final VoidCallback onSuccess;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return components.VerificationScreen(
      onSuccess: onSuccess,
      texts: components.VerificationScreenTexts(
        enterVerificationCode: l10n.enterVerificationCode,
        codeSentTo: l10n.codeSentTo,
        errorWrongCode: l10n.errorWrongCode,
        sendAgainAfter: l10n.sendAgainAfter,
        resendCode: l10n.resendCode,
      ),
    );
  }
}
