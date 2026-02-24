import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../../core/extensions/extensions.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../view_model/activity_history_view_model.dart';

extension ActivityHistoryScreenUiExtensions on BuildContext {
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

  Widget activityHistoryTypeIcon({
    required ActivityType type,
    required Color color,
    double size = 24,
  }) {
    final fallback = Icon(
      activityHistoryIconBySlug(type.slug),
      color: color,
      size: size,
    );
    final iconUrl = type.iconUrl.trim();

    if (iconUrl.isEmpty) return fallback;

    return Image.network(
      iconUrl,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => fallback,
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return fallback;
      },
    );
  }

  String activityHistoryDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final normalized = DateTime(date.year, date.month, date.day);

    if (normalized == today) return l10n.today;
    if (normalized == yesterday) return l10n.homeYesterday;

    return DateFormat('MMM d, yyyy').format(normalized);
  }

  String activityHistoryItemSubtitle(ActivityItem item) {
    final metadata = item.metadata ?? const <String, dynamic>{};
    final parts = <String>[];

    final feedingType = metadata['feeding_type'];
    if (feedingType is String && feedingType.trim().isNotEmpty) {
      parts.add(_activityHistoryFeedingLabel(feedingType));

      final amount = metadata['amount_ml'];
      final parsed = int.tryParse('$amount');
      if (parsed != null && parsed > 0) {
        parts.add('$parsed ml');
      }
    }

    if (item.durationMinutes != null && item.durationMinutes! > 0) {
      parts.add(_activityHistoryDurationLabel(item.durationMinutes!));
    }

    if (item.quality != null) {
      parts.add(_activityHistoryQualityLabel(item.quality!));
    }

    if (parts.isNotEmpty) {
      return parts.join(' • ');
    }

    final comments = item.comments?.trim();
    if (comments != null && comments.isNotEmpty) {
      return comments;
    }

    return '-';
  }

  IconData activityHistoryIconBySlug(String slug) {
    final value = slug.toLowerCase();

    if (value.contains('feed') || value.contains('food')) {
      return Icons.local_drink_outlined;
    }
    if (value.contains('sleep')) {
      return Icons.bedtime_outlined;
    }
    if (value.contains('diaper')) {
      return Icons.baby_changing_station_outlined;
    }
    if (value.contains('bath')) {
      return Icons.bathtub_outlined;
    }
    if (value.contains('med')) {
      return Icons.medication_outlined;
    }

    return Icons.more_horiz;
  }

  String _activityHistoryDurationLabel(int minutes) {
    if (minutes < 60) return '$minutes m';

    final hours = minutes ~/ 60;
    final mins = minutes % 60;

    if (mins == 0) return '${hours}h';
    return '${hours}h ${mins}m';
  }

  String _activityHistoryFeedingLabel(String value) {
    return switch (value.toLowerCase()) {
      'breast' => l10n.addActivityFeedingBreast,
      'bottle' => l10n.addActivityFeedingBottle,
      _ => value,
    };
  }

  String _activityHistoryQualityLabel(Quality quality) {
    return switch (quality) {
      Quality.good => l10n.addActivityQualityGood,
      Quality.normal => l10n.addActivityQualityNormal,
      Quality.bad => l10n.addActivityQualityBad,
    };
  }
}
