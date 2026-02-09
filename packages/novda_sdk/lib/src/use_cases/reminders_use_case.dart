import '../gateways/reminders_gateway.dart';
import '../models/enums.dart';
import '../models/reminder.dart';

/// Use case interface for reminder operations
abstract interface class RemindersUseCase {
  /// Get reminders for a child with optional filters
  Future<List<Reminder>> getReminders(
    int childId, {
    ReminderStatus? status,
    DateTime? from,
    DateTime? to,
    int? limit,
  });

  /// Get single reminder by ID
  Future<Reminder> getReminder(int reminderId);

  /// Get calendar data for reminders in a month
  Future<List<CalendarDay>> getCalendar(int childId, {required String month});

  /// Search reminders by query
  Future<List<Reminder>> searchReminders(
    int childId, {
    required String query,
    int? limit,
  });

  /// Create a new reminder for a child
  Future<Reminder> createReminder(
    int childId, {
    required int activityType,
    required DateTime dueAt,
    String? note,
  });

  /// Update an existing reminder
  Future<Reminder> updateReminder(
    int reminderId, {
    int? activityType,
    DateTime? dueAt,
    String? note,
    ReminderStatus? status,
  });

  /// Mark reminder as completed
  Future<Reminder> completeReminder(int reminderId);

  /// Delete a reminder
  Future<void> deleteReminder(int reminderId);
}

/// Implementation of RemindersUseCase
class RemindersUseCaseImpl implements RemindersUseCase {
  RemindersUseCaseImpl(this._gateway);

  final RemindersGateway _gateway;

  @override
  Future<List<Reminder>> getReminders(
    int childId, {
    ReminderStatus? status,
    DateTime? from,
    DateTime? to,
    int? limit,
  }) {
    return _gateway.getReminders(
      childId,
      ReminderListQuery(status: status, from: from, to: to, limit: limit),
    );
  }

  @override
  Future<Reminder> getReminder(int reminderId) {
    return _gateway.getReminder(reminderId);
  }

  @override
  Future<List<CalendarDay>> getCalendar(int childId, {required String month}) {
    return _gateway.getCalendar(childId, month);
  }

  @override
  Future<List<Reminder>> searchReminders(
    int childId, {
    required String query,
    int? limit,
  }) {
    return _gateway.searchReminders(childId, query, limit: limit);
  }

  @override
  Future<Reminder> createReminder(
    int childId, {
    required int activityType,
    required DateTime dueAt,
    String? note,
  }) {
    return _gateway.createReminder(
      childId,
      ReminderCreateRequest(
        activityType: activityType,
        dueAt: dueAt,
        note: note,
      ),
    );
  }

  @override
  Future<Reminder> updateReminder(
    int reminderId, {
    int? activityType,
    DateTime? dueAt,
    String? note,
    ReminderStatus? status,
  }) {
    return _gateway.updateReminder(
      reminderId,
      ReminderUpdateRequest(
        activityType: activityType,
        dueAt: dueAt,
        note: note,
        status: status,
      ),
    );
  }

  @override
  Future<Reminder> completeReminder(int reminderId) {
    return _gateway.completeReminder(reminderId);
  }

  @override
  Future<void> deleteReminder(int reminderId) {
    return _gateway.deleteReminder(reminderId);
  }
}
