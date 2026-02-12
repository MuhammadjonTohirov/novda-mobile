import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Page indicator dots for onboarding
class AppPageIndicator extends StatelessWidget {
  const AppPageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
    this.activeWidth = 24,
    this.inactiveWidth = 8,
    this.height = 8,
    this.spacing = 6,
  });

  final int count;
  final int currentIndex;
  final double activeWidth;
  final double inactiveWidth;
  final double height;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          margin: EdgeInsets.only(left: index == 0 ? 0 : spacing),
          width: isActive ? activeWidth : inactiveWidth,
          height: height,
          decoration: BoxDecoration(
            color: isActive ? colors.accent : colors.bgSoft,
            borderRadius: BorderRadius.circular(height / 2),
          ),
        );
      }),
    );
  }
}
