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
    return Reminder(
      id: json['id'] as int,
      child: json['child'] as int,
      childName: json['child_name'] as String,
      activityType: json['activity_type'] as int,
      activityTypeDetail: ActivityType.fromJson(
        json['activity_type_detail'] as Map<String, dynamic>,
      ),
      dueAt: DateTime.parse(json['due_at'] as String),
      note: json['note'] as String?,
      status: ReminderStatus.fromString(json['status'] as String? ?? 'pending'),
      statusDisplay: json['status_display'] as String? ?? '',
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      createdBy: json['created_by'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
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
      date: DateTime.parse(json['date'] as String),
      pendingCount: json['pending_count'] as int,
      completedCount: json['completed_count'] as int,
      totalCount: json['total_count'] as int,
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
