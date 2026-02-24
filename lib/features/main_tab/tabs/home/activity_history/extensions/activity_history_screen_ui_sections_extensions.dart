import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../../core/extensions/extensions.dart';
import '../../../../../../core/theme/app_theme.dart';
import 'activity_history_screen_ui_metadata_extensions.dart';
import '../view_model/activity_history_view_model.dart';

extension ActivityHistoryScreenUiSectionsExtensions on BuildContext {
  Widget activityHistorySectionCard({
    required ActivityHistorySection section,
    required ValueChanged<ActivityItem> onItemTap,
  }) {
    final colors = appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          activityHistoryDateLabel(section.date),
          style: AppTypography.headingS.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            for (final item in section.items)
              activityHistoryItemTile(item: item, onTap: () => onItemTap(item)),
          ],
        ).container(
          decoration: BoxDecoration(
            color: colors.bgPrimary,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: colors.border),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ],
    );
  }

  Widget activityHistoryItemTile({
    required ActivityItem item,
    required VoidCallback onTap,
  }) {
    final colors = appColors;
    final type = item.activityTypeDetail;
    final baseColor = colors.accent.parseHexOrSelf(type.color);

    return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            activityHistoryTypeIcon(type: type, color: baseColor, size: 34),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type.title,
                  style: AppTypography.headingS.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  activityHistoryItemSubtitle(item),
                  style: AppTypography.bodyLRegular.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ).expanded(),
            const SizedBox(width: 8),
            Text(
              DateFormat('HH:mm').format(item.startDate.toLocal()),
              style: AppTypography.bodyLRegular.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        )
        .container(
          decoration: BoxDecoration(
            color: colors.bgPrimary,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        )
        .inkWell(onTap: onTap, borderRadius: BorderRadius.circular(16));
  }
}
