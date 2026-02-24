import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';

extension HomeScreenUiSectionExtensions on BuildContext {
  Widget homeSectionHeader({
    required String title,
    required String actionLabel,
    required VoidCallback onActionTap,
  }) {
    final colors = appColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.headingS.copyWith(color: colors.textPrimary),
        ),
        TextButton(
          onPressed: onActionTap,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            actionLabel,
            style: AppTypography.bodyMMedium.copyWith(color: colors.accent),
          ),
        ),
      ],
    );
  }
}
