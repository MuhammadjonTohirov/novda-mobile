import 'package:flutter/material.dart';
import 'package:novda_components/novda_components.dart';

import '../../core/app/app.dart';
import '../../core/services/services.dart';
import '../auth/auth.dart';
import '../main_tab/tabs/home/home.dart';
import '../onboarding/onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _logoLightAsset = 'assets/images/logo.png';
  static const _logoDarkAsset = 'assets/images/logo_dark.png';
  static const _darkSplashBackground = Color(0xFF2A2B30);

  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Small delay to show splash
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    final isAuthenticated = await services.hasValidSession();
    if (!mounted) return;

    final onboarding = SharedPrefsOnboardingRepository(prefs: services.prefs);
    final hasCompletedOnboarding = onboarding.hasCompletedOnboarding;

    if (isAuthenticated) {
      final profile = await services.sdk.user.getProfile();

      if (!mounted) return;
      services.setLocale(profile.preferredLocale.name);
      context.appController.setLocale(Locale(profile.preferredLocale.name));

      final resolvedTheme = await services.resolveThemeVariant(
        selectedChildId: profile.lastActiveChild,
      );

      if (!mounted) return;
      context.appController.setThemeVariant(resolvedTheme);

      _navigateTo(const MainTabScreen());
    } else if (hasCompletedOnboarding) {
      _navigateTo(const AuthorizationFlowScreen());
    } else {
      _navigateTo(const OnboardingScreen());
    }
  }

  void _navigateTo(Widget screen) {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isGrayTheme = context.appController.themeVariant == ThemeVariant.gray;
    final logoAsset = isGrayTheme ? _logoDarkAsset : _logoLightAsset;
    final background = isGrayTheme ? _darkSplashBackground : colors.bgPrimary;
    final indicatorColor = isGrayTheme
        ? Colors.white.withValues(alpha: 0.75)
        : colors.accent;

    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(logoAsset, width: 220, height: 220),
            const SizedBox(height: 28),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
              strokeWidth: 2,
            ).container(width: 32, height: 32),
          ],
        ),
      ),
    );
  }
}
