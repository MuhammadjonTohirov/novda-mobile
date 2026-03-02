import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/services/services.dart';

class AddReminderInteractor {
  AddReminderInteractor({
    UserUseCase? userUseCase,
    ChildrenUseCase? childrenUseCase,
    ActivitiesUseCase? activitiesUseCase,
    RemindersUseCase? remindersUseCase,
  }) : _userUseCase = userUseCase ?? services.sdk.user,
       _childrenUseCase = childrenUseCase ?? services.sdk.children,
       _activitiesUseCase = activitiesUseCase ?? services.sdk.activities,
       _remindersUseCase = remindersUseCase ?? services.sdk.reminders;

  final UserUseCase _userUseCase;
  final ChildrenUseCase _childrenUseCase;
  final ActivitiesUseCase _activitiesUseCase;
  final RemindersUseCase _remindersUseCase;

  Future<int?> resolveActiveChildId() async {
    final results = await Future.wait([
      _userUseCase.getProfile(),
      _childrenUseCase.getChildren(),
    ]);

    final user = results[0] as User;
    final children = results[1] as List<ChildListItem>;

    if (children.isEmpty) return null;

    final preferredChildId = user.lastActiveChild;
    if (preferredChildId != null) {
      for (final child in children) {
        if (child.id == preferredChildId) {
          return preferredChildId;
        }
      }
    }

    return children.first.id;
  }

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
