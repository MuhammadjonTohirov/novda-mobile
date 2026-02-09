import 'package:equatable/equatable.dart';

import 'enums.dart';

/// Activity type model
class ActivityType extends Equatable {
  const ActivityType({
    required this.id,
    required this.slug,
    required this.iconUrl,
    required this.color,
    required this.hasDuration,
    required this.hasQuality,
    required this.isActive,
    required this.order,
    required this.title,
    required this.description,
  });

  final int id;
  final String slug;
  final String iconUrl;
  final String color;
  final bool hasDuration;
  final bool hasQuality;
  final bool isActive;
  final int order;
  final String title;
  final String description;

  factory ActivityType.fromJson(Map<String, dynamic> json) {
    return ActivityType(
      id: json['id'] as int,
      slug: json['slug'] as String,
      iconUrl: json['icon_url'] as String? ?? '',
      color: json['color'] as String,
      hasDuration: json['has_duration'] as bool? ?? false,
      hasQuality: json['has_quality'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      order: json['order'] as int? ?? 0,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [
        id,
        slug,
        iconUrl,
        color,
        hasDuration,
        hasQuality,
        isActive,
        order,
        title,
        description,
      ];
}

/// Condition type for illness tracking
class ConditionType extends Equatable {
  const ConditionType({
    required this.id,
    required this.slug,
    required this.iconUrl,
    required this.name,
  });

  final int id;
  final String slug;
  final String iconUrl;
  final String name;

  factory ConditionType.fromJson(Map<String, dynamic> json) {
    return ConditionType(
      id: json['id'] as int,
      slug: json['slug'] as String,
      iconUrl: json['icon_url'] as String? ?? '',
      name: json['name'] as String,
    );
  }

  @override
  List<Object?> get props => [id, slug, iconUrl, name];
}

/// Activity item model
class ActivityItem extends Equatable {
  const ActivityItem({
    required this.id,
    required this.activityType,
    required this.activityTypeDetail,
    required this.child,
    required this.childName,
    required this.startDate,
    this.endDate,
    this.durationMinutes,
    this.quality,
    this.comments,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int activityType;
  final ActivityType activityTypeDetail;
  final int child;
  final String childName;
  final DateTime startDate;
  final DateTime? endDate;
  final int? durationMinutes;
  final Quality? quality;
  final String? comments;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory ActivityItem.fromJson(Map<String, dynamic> json) {
    return ActivityItem(
      id: json['id'] as int,
      activityType: json['activity_type'] as int,
      activityTypeDetail: ActivityType.fromJson(
        json['activity_type_detail'] as Map<String, dynamic>,
      ),
      child: json['child'] as int,
      childName: json['child_name'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      durationMinutes:
          int.tryParse(json['duration_minutes']?.toString() ?? ''),
      quality: Quality.fromString(json['quality'] as String?),
      comments: json['comments'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  @override
  List<Object?> get props => [
        id,
        activityType,
        activityTypeDetail,
        child,
        childName,
        startDate,
        endDate,
        durationMinutes,
        quality,
        comments,
        metadata,
        createdAt,
        updatedAt,
      ];
}

/// Activity summary for dashboard
class ActivitySummary extends Equatable {
  const ActivitySummary({
    required this.lastActivities,
    required this.dailyCounts,
    required this.totalToday,
  });

  final List<ActivityItem> lastActivities;
  final Map<String, int> dailyCounts;
  final int totalToday;

  factory ActivitySummary.fromJson(Map<String, dynamic> json) {
    return ActivitySummary(
      lastActivities: (json['last_activities'] as List<dynamic>)
          .map((e) => ActivityItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      dailyCounts: (json['daily_counts'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, v as int)),
      totalToday: json['total_today'] as int,
    );
  }

  @override
  List<Object?> get props => [lastActivities, dailyCounts, totalToday];
}

/// Request for creating an activity
class ActivityCreateRequest {
  const ActivityCreateRequest({
    required this.activityType,
    required this.startDate,
    this.endDate,
    this.quality,
    this.comments,
    this.metadata,
  });

  final int activityType;
  final DateTime startDate;
  final DateTime? endDate;
  final Quality? quality;
  final String? comments;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => {
        'activity_type': activityType,
        'start_date': startDate.toUtc().toIso8601String(),
        if (endDate != null) 'end_date': endDate!.toUtc().toIso8601String(),
        if (quality != null) 'quality': quality!.name,
        if (comments != null) 'comments': comments,
        if (metadata != null) 'metadata': metadata,
      };
}

/// Request for updating an activity
class ActivityUpdateRequest {
  const ActivityUpdateRequest({
    this.startDate,
    this.endDate,
    this.quality,
    this.comments,
    this.metadata,
  });

  final DateTime? startDate;
  final DateTime? endDate;
  final Quality? quality;
  final String? comments;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => {
        if (startDate != null)
          'start_date': startDate!.toUtc().toIso8601String(),
        if (endDate != null) 'end_date': endDate!.toUtc().toIso8601String(),
        if (quality != null) 'quality': quality!.name,
        if (comments != null) 'comments': comments,
        if (metadata != null) 'metadata': metadata,
      };
}

/// Query parameters for activity list
class ActivityListQuery {
  const ActivityListQuery({
    this.type,
    this.from,
    this.to,
    this.limit,
  });

  final String? type;
  final DateTime? from;
  final DateTime? to;
  final int? limit;

  Map<String, dynamic> toQueryParams() => {
        if (type != null) 'type': type,
        if (from != null) 'from': from!.toIso8601String(),
        if (to != null) 'to': to!.toIso8601String(),
        if (limit != null) 'limit': limit.toString(),
      };
}
