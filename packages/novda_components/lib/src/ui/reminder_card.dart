import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Reminder card component for displaying reminder items
class ReminderCard extends StatelessWidget {
  const ReminderCard({
    super.key,
    required this.title,
    required this.dateTime,
    required this.category,
    this.isCompleted = false,
    this.showBackground = true,
    this.onTap,
    this.onCheckTap,
  });

  final String title;
  final String dateTime;
  final String category;
  final bool isCompleted;
  final bool showBackground;
  final VoidCallback? onTap;
  final VoidCallback? onCheckTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onCheckTap,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isCompleted ? colors.accent : colors.border,
                width: 2,
              ),
              color: isCompleted ? colors.accent : Colors.transparent,
            ),
            child: isCompleted
                ? Icon(Icons.check, size: 16, color: colors.bgPrimary)
                : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.bodyLMedium.copyWith(
                  color: colors.textPrimary,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$dateTime • $category',
                style: AppTypography.bodySRegular.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
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
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: content,
      ),
    );
  }
}
