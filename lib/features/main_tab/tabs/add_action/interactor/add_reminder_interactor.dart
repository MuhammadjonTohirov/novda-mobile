import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/services/services.dart';

class AddReminderInteractor {
  AddReminderInteractor({
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

  Future<List<ActivityType>> loadActivityTypes() async {
    final types = await _activitiesUseCase.getActivityTypes();

    final active =
        types.where((type) => type.isActive && type.isReminderEnabled).toList()
          ..sort((a, b) => a.order.compareTo(b.order));

    return active;
  }

  Future<Reminder> createReminder({
    required int childId,
    required int activityTypeId,
    required DateTime dueAt,
    String? note,
  }) {
    return _remindersUseCase.createReminder(
      childId,
      activityType: activityTypeId,
      dueAt: dueAt,
      note: note,
    );
  }
}
