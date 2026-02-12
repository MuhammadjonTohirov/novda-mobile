import 'package:flutter/material.dart';

import '../../core/app/app.dart';
import '../../core/services/services.dart';
import '../../core/theme/app_theme.dart';
import '../auth/auth.dart';
import '../home/home.dart';
import '../onboarding/onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Small delay to show splash
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    final isAuthenticated = services.isAuthenticated;
    final hasCompletedOnboarding =
        services.prefs.getBool('onboarding_completed') ?? false;

    if (isAuthenticated) {
      final resolvedTheme = await services.resolveThemeVariant();

      if (!mounted) return;
      context.appController.setThemeVariant(resolvedTheme);

      _navigateTo(const HomeScreen());
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

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo
            Image.asset('assets/images/img_onb_1.png', width: 120, height: 120),
            const SizedBox(height: 24),
            Text(
              'Novda',
              style: AppTypography.headingL.copyWith(color: colors.textPrimary),
            ),
            const SizedBox(height: 32),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(colors.accent),
            ),
          ],
        ),
      ),
    );
  }
}
