import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:novda_sdk/novda_sdk.dart';
import 'package:provider/provider.dart';

import '../../core/extensions/extensions.dart';
import '../../core/services/services.dart';
import '../../core/theme/app_theme.dart';
import '../splash/splash.dart';
import 'interactors/home_interactor.dart';
import 'view_models/home_view_model.dart';

part 'home_screen_dashboard_part.dart';
part 'home_screen_activity_part.dart';
part 'home_screen_reminder_part.dart';
part 'home_screen_tabs_part.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTabIndex = 0;

  Future<void> _logout() async {
    await services.tokenStorage.clearTokens();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SplashScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.bgSecondary,
      body: IndexedStack(
        index: _currentTabIndex,
        children: [
          const _HomeDashboardTab(),
          _TabPlaceholder(title: l10n.progressTab),
          _TabPlaceholder(title: l10n.addTab),
          _TabPlaceholder(title: l10n.learnTab),
          _ProfileTab(onLogout: _logout),
        ],
      ),
      bottomNavigationBar: _MainTabBar(
        selectedIndex: _currentTabIndex,
        onTabSelected: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
      ),
    );
  }
}
