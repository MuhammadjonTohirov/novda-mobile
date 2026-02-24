import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../../core/extensions/extensions.dart';

extension ActivityHistoryScreenUiMetadataExtensions on BuildContext {
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
