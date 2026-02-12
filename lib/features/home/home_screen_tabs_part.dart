part of 'home_screen.dart';

class _MainTabBar extends StatelessWidget {
  const _MainTabBar({required this.selectedIndex, required this.onTabSelected});

  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  static const _iconAssets = [
    'assets/images/tabs/icon_home.png',
    'assets/images/tabs/icon_analytics.png',
    'assets/images/tabs/icon_add_circular.png',
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

    return Container(
      decoration: BoxDecoration(
        color: colors.bgPrimary,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 78,
          child: Row(
            children: List.generate(labels.length, (index) {
              final isSelected = selectedIndex == index;

              if (index == 2) {
                return Expanded(
                  child: InkWell(
                    onTap: () => onTabSelected(index),
                    child: Center(
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? colors.accent.withValues(alpha: 0.14)
                              : colors.bgSoft,
                        ),
                        child: Center(
                          child: _TabIcon(
                            assetPath: _iconAssets[index],
                            color: isSelected
                                ? colors.accent
                                : colors.tabDisabled,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }

              return Expanded(
                child: InkWell(
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
                          color: isSelected
                              ? colors.tabActive
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      _TabIcon(
                        assetPath: _iconAssets[index],
                        color: isSelected
                            ? colors.tabActive
                            : colors.tabDisabled,
                        size: 24,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        labels[index],
                        style: AppTypography.bodyMRegular.copyWith(
                          color: isSelected
                              ? colors.tabActive
                              : colors.tabDisabled,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
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

    return SafeArea(
      child: Center(
        child: Text(
          context.l10n.homeTabPlaceholder(title),
          style: AppTypography.headingM.copyWith(color: colors.textSecondary),
        ),
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab({required this.onLogout});

  final Future<void> Function() onLogout;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SafeArea(
      child: Center(
        child: ElevatedButton.icon(
          onPressed: onLogout,
          icon: const Icon(Icons.logout),
          label: Text(
            context.l10n.homeLogOut,
            style: AppTypography.bodyLMedium.copyWith(
              color: colors.textOnPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
