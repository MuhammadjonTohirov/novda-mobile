import 'package:flutter/material.dart';

import '../../core/extensions/extensions.dart';
import '../../core/services/services.dart';
import '../../core/theme/app_theme.dart';
import '../splash/splash.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await services.tokenStorage.clearTokens();

    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const SplashScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      appBar: AppBar(
        backgroundColor: colors.bgPrimary,
        elevation: 0,
        title: Text(
          l10n.appName,
          style: AppTypography.headingM.copyWith(
            color: colors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: colors.textPrimary),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home,
              size: 80,
              color: colors.accent,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.welcomeHome,
              style: AppTypography.headingL.copyWith(
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.homeDescription,
              style: AppTypography.bodyMRegular.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ).padding(const EdgeInsets.all(24)),
      ),
    );
  }
}
