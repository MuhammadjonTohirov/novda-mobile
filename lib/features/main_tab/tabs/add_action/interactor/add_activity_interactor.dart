import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/services/services.dart';

class AddActivityInteractor {
  AddActivityInteractor({
    ActiveChildResolver? activeChildResolver,
    ActivitiesUseCase? activitiesUseCase,
    RemindersUseCase? remindersUseCase,
  }) : _activeChildResolver = activeChildResolver ?? ActiveChildResolver(),
       _activitiesUseCase = activitiesUseCase ?? services.sdk.activities,
       _remindersUseCase = remindersUseCase ?? services.sdk.reminders;

  final ActiveChildResolver _activeChildResolver;
  final ActivitiesUseCase _activitiesUseCase;
  final RemindersUseCase _remindersUseCase;

  Future<int?> resolveActiveChildId() => _activeChildResolver.resolveActiveChildId();

  Future<List<Reminder>> loadPendingReminders(
    int childId, {
    required int activityTypeId,
  }) async {
    final reminders = await _remindersUseCase.getReminders(
      childId,
      status: ReminderStatus.pending,
      limit: 100,
    );

    final filtered =
        reminders
            .where((reminder) => reminder.activityType == activityTypeId)
            .toList()
          ..sort((a, b) => a.dueAt.compareTo(b.dueAt));

    return filtered;
  }

  Future<List<ConditionType>> loadConditionTypes() {
    return _activitiesUseCase.getConditionTypes();
  }

  Future<ActivityItem> createActivity({
    required int childId,
    required int activityTypeId,
    required DateTime startDate,
    DateTime? endDate,
    Quality? quality,
    String? comments,
    Map<String, dynamic>? metadata,
  }) {
    return _activitiesUseCase.createActivity(
      childId,
      activityType: activityTypeId,
      startDate: startDate,
      endDate: endDate,
      quality: quality,
      comments: comments,
      metadata: metadata,
    );
  }

  Future<ActivityItem> updateActivity({
    required int activityId,
    required DateTime startDate,
    DateTime? endDate,
    Quality? quality,
    String? comments,
    Map<String, dynamic>? metadata,
  }) {
    return _activitiesUseCase.updateActivity(
      activityId,
      startDate: startDate,
      endDate: endDate,
      quality: quality,
      comments: comments,
      metadata: metadata,
    );
  }

  Future<void> completeReminders(Iterable<int> reminderIds) async {
    await Future.wait([
      for (final reminderId in reminderIds) _safeCompleteReminder(reminderId),
    ]);
  }

  Future<void> _safeCompleteReminder(int reminderId) async {
    try {
      await _remindersUseCase.completeReminder(reminderId);
    } catch (_) {
      // Keep activity creation success independent from reminder completion.
    }
  }
}
