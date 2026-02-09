import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Activity card component for displaying activity items
class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.icon,
    required this.title,
    required this.duration,
    required this.time,
    this.iconColor,
    this.showBackground = true,
    this.onTap,
  });

  final Widget icon;
  final String title;
  final String duration;
  final String time;
  final Color? iconColor;
  final bool showBackground;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final content = Row(
      children: [
        SizedBox(
          width: 48,
          height: 48,
          child: icon,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.bodyLMedium.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              Text(
                duration,
                style: AppTypography.bodyMRegular.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Text(
          time,
          style: AppTypography.bodyMRegular.copyWith(
            color: colors.textSecondary,
          ),
        ),
      ],
    );

    if (showBackground) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            decoration: BoxDecoration(
              color: colors.bgPrimary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: content,
          ),
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: content,
      ),
    );
  }
}
