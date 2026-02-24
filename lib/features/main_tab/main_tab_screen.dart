import 'package:flutter/material.dart';
import 'package:novda/core/ui/ui.dart';
import 'package:provider/provider.dart';

import '../../core/extensions/extensions.dart';
import '../../core/theme/app_theme.dart';
import '../splash/splash.dart';
import 'tabs/add_action/add_activity_screen.dart';
import 'tabs/add_action/add_action_sheet_content.dart';
import 'tabs/add_action/view_model/add_action_sheet_view_model.dart';
import 'tabs/home/home_screen.dart';
import 'tabs/progress/progress_tab_content.dart';
import 'tabs/profile/profile_tab_content.dart';
import 'view_model/main_tab_view_model.dart';

class MainTabScreen extends StatelessWidget {
  const MainTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainTabViewModel>(
      create: (_) => MainTabViewModel(),
      child: Consumer<MainTabViewModel>(
        builder: (context, viewModel, _) {
          final l10n = context.l10n;
          final colors = context.appColors;

          return Scaffold(
            backgroundColor: colors.bgSecondary,
            body: IndexedStack(
              index: viewModel.selectedTabIndex,
              children: [
                const HomeScreen(),
                const ProgressTabContent(),
                _TabPlaceholder(title: l10n.addTab),
                _TabPlaceholder(title: l10n.learnTab),
                ProfileTabContent(onLogout: () => _logout(context, viewModel)),
              ],
            ),
            bottomNavigationBar: _MainTabBar(
              selectedIndex: viewModel.selectedTabIndex,
              onTabSelected: (index) async {
                if (index == 2) {
                  _addAction(context);
                  return;
                }
                viewModel.selectTab(index);
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _addAction(BuildContext context) async {
    final selection = await AppBottomSheet.show<AddActionSheetSelection>(
      context: context,
      showDragHandle: true,
      child: const AddActionSheetContent(),
    );

    if (!context.mounted || selection == null) return;

    switch (selection.actionType) {
      case AddActionType.activity:
        final createdActivity = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) =>
                AddActivityScreen(activityType: selection.activityType),
          ),
        );

        if (!context.mounted || createdActivity == null) return;

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(context.l10n.addActivityCreated)),
          );
        return;

      case AddActionType.reminder:
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(context.l10n.homeComingSoon)));
        return;
    }
  }

  Future<void> _logout(BuildContext context, MainTabViewModel viewModel) async {
    await viewModel.logout();

    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SplashScreen()),
      (route) => false,
    );
  }
}

class _MainTabBar extends StatelessWidget {
  const _MainTabBar({required this.selectedIndex, required this.onTabSelected});

  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  static const _iconAssets = [
    'assets/images/tabs/icon_home.png',
    'assets/images/tabs/icon_analytics.png',
    'assets/images/icon_plus_sign.png',
    'assets/images/tabs/icon_book_open.png',
    'assets/images/tabs/icon_user.png',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;

    final labels = [
      l10n.homeTab,
      l10n.progressTab,
      l10n.addTab,
      l10n.learnTab,
      l10n.profileTab,
    ];

    return Row(
          children: List.generate(labels.length, (index) {
            final isSelected = selectedIndex == index;

            if (index == 2) {
              return InkWell(
                onTap: () => onTabSelected(index),
                child:
                    _TabIcon(
                          assetPath: _iconAssets[index],
                          color: isSelected
                              ? colors.accent
                              : (index == 2
                                    ? colors.accent
                                    : colors.tabDisabled),
                          size: 26,
                        )
                        .center()
                        .container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? colors.accent.withValues(alpha: 0.14)
                                : colors.bgSoft,
                          ),
                        )
                        .center(),
              ).expanded();
            }

            return InkWell(
              onTap: () => onTabSelected(index),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    margin: const EdgeInsets.only(bottom: 8),
                    width: 62,
                    height: 3,
                    decoration: BoxDecoration(
                      color: isSelected ? colors.tabActive : Colors.transparent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  _TabIcon(
                    assetPath: _iconAssets[index],
                    color: isSelected ? colors.tabActive : colors.tabDisabled,
                    size: 24,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    labels[index],
                    style: AppTypography.bodyMRegular.copyWith(
                      color: isSelected ? colors.tabActive : colors.tabDisabled,
                    ),
                  ),
                ],
              ),
            ).expanded();
          }),
        )
        .sized(height: 78)
        .safeArea(top: false)
        .container(
          decoration: BoxDecoration(
            color: colors.bgPrimary,
            border: Border(top: BorderSide(color: colors.border)),
          ),
        );
  }
}

class _TabIcon extends StatelessWidget {
  const _TabIcon({
    required this.assetPath,
    required this.color,
    required this.size,
  });

  final String assetPath;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      child: Image.asset(assetPath, width: size, height: size),
    );
  }
}

class _TabPlaceholder extends StatelessWidget {
  const _TabPlaceholder({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Text(
      context.l10n.homeTabPlaceholder(title),
      style: AppTypography.headingM.copyWith(color: colors.textSecondary),
    ).center().safeArea();
  }
}
