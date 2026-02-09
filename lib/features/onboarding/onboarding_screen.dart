import 'package:flutter/material.dart';

import '../../core/app/app.dart';
import '../../core/extensions/extensions.dart';
import '../../core/services/services.dart';
import '../../core/theme/app_theme.dart';
import '../../core/ui/ui.dart';
import '../../l10n/app_localizations.dart';
import '../auth/auth.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Future<void> _onContinue() async {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Mark onboarding as completed
      await services.prefs.setBool('onboarding_completed', true);

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const AuthorizationFlowScreen(),
        ),
      );
    }
  }

  void _showLanguageSelector() {
    final appController = context.appController;
    final currentLanguage = appController.currentLanguage;

    AppBottomSheet.show<AppLanguage>(
      context: context,
      title: context.l10n.selectLanguage,
      child: AppBottomSheetContent(
        children: [
          for (final language in AppLanguage.values)
            LanguageSelectionTile(
              language: language,
              isSelected: language == currentLanguage,
              onTap: () {
                appController.setLanguage(language);
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final appController = context.appController;

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // Language selector - fixed at top
            Padding(
              padding: const EdgeInsets.only(top: 16, right: 24),
              child: Align(
                alignment: Alignment.topRight,
                child: LanguageSelectorButton(
                  language: appController.currentLanguage,
                  onTap: _showLanguageSelector,
                ),
              ),
            ),

            // Page content - scrollable
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return _OnboardingPage(pageIndex: index);
                },
              ),
            ),

            // Page indicator - fixed
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: AppPageIndicator(
                count: 3,
                currentIndex: _currentPage,
              ),
            ),

            // Continue button - fixed at bottom
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: AppButton(
                text: context.l10n.continueButton,
                onPressed: _onContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.pageIndex});

  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;

    final (imagePath, title, description) = _getPageContent(l10n);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Image.asset(
            imagePath,
            fit: BoxFit.contain,
            width: 250,
            height: 250,
            ),

          // Title
          Text(
            title,
            style: AppTypography.headingL.copyWith(
              color: colors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // Description
          Text(
            description,
            style: AppTypography.bodyMRegular.copyWith(
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  (String, String, String) _getPageContent(AppLocalizations l10n) {
    return switch (pageIndex) {
      0 => (
          'assets/images/img_onb_1.png',
          l10n.onboardingTitle1,
          l10n.onboardingDescription1,
        ),
      1 => (
          'assets/images/img_onb_2.png',
          l10n.onboardingTitle2,
          l10n.onboardingDescription2,
        ),
      2 => (
          'assets/images/img_onb_3.png',
          l10n.onboardingTitle3,
          l10n.onboardingDescription3,
        ),
      _ => (
          'assets/images/img_onb_1.png',
          l10n.onboardingTitle1,
          l10n.onboardingDescription1,
        ),
    };
  }
}
