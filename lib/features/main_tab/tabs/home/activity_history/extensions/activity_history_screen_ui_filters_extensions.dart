import 'package:flutter/material.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../../core/extensions/extensions.dart';
import '../../../../../../core/theme/app_theme.dart';
import 'activity_history_screen_ui_metadata_extensions.dart';

extension ActivityHistoryScreenUiFiltersExtensions on BuildContext {
  Widget activityHistoryTypeChips({
    required List<ActivityType> types,
    required Set<int> selectedTypeIds,
    required ValueChanged<int> onToggle,
  }) {
    if (types.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final type in types)
            activityHistoryTypeChip(
              type: type,
              selected: selectedTypeIds.contains(type.id),
              onTap: () => onToggle(type.id),
            ).paddingOnly(right: 8),
        ],
      ),
    );
  }

  Widget activityHistoryTypeChip({
    required ActivityType type,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final colors = appColors;
    final baseColor = colors.accent.parseHexOrSelf(type.color);

    return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            activityHistoryTypeIcon(type: type, color: baseColor, size: 20),
            const SizedBox(width: 8),
            Text(
              type.title,
              style: AppTypography.bodyLMedium.copyWith(
                color: selected ? baseColor : colors.textSecondary,
              ),
            ),
          ],
        )
        .container(
          decoration: BoxDecoration(
            color: selected
                ? baseColor.withValues(alpha: 0.08)
                : colors.bgSecondary,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? baseColor.withValues(alpha: 0.28)
                  : colors.border,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        )
        .inkWell(onTap: onTap, borderRadius: BorderRadius.circular(18));
  }
}
