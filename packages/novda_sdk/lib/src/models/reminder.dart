import 'package:equatable/equatable.dart';

import 'activity.dart';
import 'enums.dart';

/// Reminder model
class Reminder extends Equatable {
  const Reminder({
    required this.id,
    required this.child,
    required this.childName,
    required this.activityType,
    required this.activityTypeDetail,
    required this.dueAt,
    this.note,
    required this.status,
    required this.statusDisplay,
    this.completedAt,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int child;
  final String childName;
  final int activityType;
  final ActivityType activityTypeDetail;
  final DateTime dueAt;
  final String? note;
  final ReminderStatus status;
  final String statusDisplay;
  final DateTime? completedAt;
  final int createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Reminder.fromJson(Map<String, dynamic> json) {
    final dueAt = DateTime.tryParse(json['due_at']?.toString() ?? '') ??
        DateTime.now();
    final rawDetail = json['activity_type_detail'];
    return Reminder(
      id: _parseInt(json['id']),
      child: _parseInt(json['child']),
      childName: json['child_name'] as String? ?? '',
      activityType: _parseInt(json['activity_type']),
      activityTypeDetail: rawDetail is Map<String, dynamic>
          ? ActivityType.fromJson(rawDetail)
          : rawDetail is Map
              ? ActivityType.fromJson(Map<String, dynamic>.from(rawDetail))
              : ActivityType.fromJson(const {}),
      dueAt: dueAt,
      note: json['note'] as String?,
      status: ReminderStatus.fromString(json['status']?.toString() ?? 'pending'),
      statusDisplay: json['status_display'] as String? ?? '',
      completedAt: DateTime.tryParse(json['completed_at']?.toString() ?? ''),
      createdBy: _parseInt(json['created_by']),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          dueAt,
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
          dueAt,
    );
  }

  static int _parseInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  @override
  List<Object?> get props => [
        id,
        child,
        childName,
        activityType,
        activityTypeDetail,
        dueAt,
        note,
        status,
        statusDisplay,
        completedAt,
        createdBy,
        createdAt,
        updatedAt,
      ];
}

/// Calendar day data for reminders
class CalendarDay extends Equatable {
  const CalendarDay({
    required this.date,
    required this.pendingCount,
    required this.completedCount,
    required this.totalCount,
  });

  final DateTime date;
  final int pendingCount;
  final int completedCount;
  final int totalCount;

  factory CalendarDay.fromJson(Map<String, dynamic> json) {
    return CalendarDay(
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      pendingCount: json['pending_count'] as int? ?? 0,
      completedCount: json['completed_count'] as int? ?? 0,
      totalCount: json['total_count'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [date, pendingCount, completedCount, totalCount];
}

/// Request for creating a reminder
class ReminderCreateRequest {
  const ReminderCreateRequest({
    required this.activityType,
    required this.dueAt,
    this.note,
  });

  final int activityType;
  final DateTime dueAt;
  final String? note;

  Map<String, dynamic> toJson() => {
        'activity_type': activityType,
        'due_at': dueAt.toUtc().toIso8601String(),
        if (note != null) 'note': note,
      };
}

/// Request for updating a reminder
class ReminderUpdateRequest {
  const ReminderUpdateRequest({
    this.activityType,
    this.dueAt,
    this.note,
    this.status,
  });

  final int? activityType;
  final DateTime? dueAt;
  final String? note;
  final ReminderStatus? status;

  Map<String, dynamic> toJson() => {
        if (activityType != null) 'activity_type': activityType,
        if (dueAt != null) 'due_at': dueAt!.toUtc().toIso8601String(),
        if (note != null) 'note': note,
        if (status != null) 'status': status!.name,
      };
}

/// Query parameters for reminder list
class ReminderListQuery {
  const ReminderListQuery({
    this.status,
    this.from,
    this.to,
    this.limit,
  });

  final ReminderStatus? status;
  final DateTime? from;
  final DateTime? to;
  final int? limit;

  Map<String, dynamic> toQueryParams() => {
        if (status != null) 'status': status!.name,
        if (from != null) 'from': from!.toIso8601String(),
        if (to != null) 'to': to!.toIso8601String(),
        if (limit != null) 'limit': limit.toString(),
      };
}
