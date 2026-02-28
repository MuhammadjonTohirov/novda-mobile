import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/services/services.dart';
import '../models/home_dashboard_data.dart';

export '../models/home_dashboard_data.dart';

class HomeInteractor {
  HomeInteractor({
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

  Future<HomeDashboardData> loadDashboard() async {
    final results = await Future.wait([
      _userUseCase.getProfile(),
      _childrenUseCase.getChildren(),
      _activitiesUseCase.getActivityTypes(),
    ]);

    final user = results[0] as User;
    final children = results[1] as List<ChildListItem>;
    final activityTypes = results[2] as List<ActivityType>;

    final sortedActivityTypes =
        activityTypes.where((type) => type.isActive).toList()
          ..sort((a, b) => a.order.compareTo(b.order));

    if (children.isEmpty) {
      return HomeDashboardData(
        activeChild: null,
        activeChildDetails: null,
        activityTypes: sortedActivityTypes,
        latestActivitiesByType: const {},
        todayCountByType: const {},
        recentReminders: const [],
      );
    }

    final activeChildId = user.lastActiveChild ?? children.first.id;
    final activeChild = children.firstWhere(
      (child) => child.id == activeChildId,
      orElse: () => children.first,
    );

    final activeChildDetails = await _runSafely(
      () => _childrenUseCase.getChild(activeChild.id),
    );

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    final summaryFuture = _runSafely(
      () => _activitiesUseCase.getActivitySummary(activeChild.id),
    );

    final todayActivitiesFuture = _runSafely(
      () => _activitiesUseCase.getActivities(
        activeChild.id,
        from: startOfDay,
        to: now,
        limit: 200,
      ),
    );

    final remindersFuture = _runSafely(
      () => _remindersUseCase.getReminders(activeChild.id, limit: 6),
    );

    final summary = await summaryFuture;
    final todayActivities =
        await todayActivitiesFuture ?? const <ActivityItem>[];
    final reminders = await remindersFuture ?? const <Reminder>[];

    return HomeDashboardData(
      activeChild: activeChild,
      activeChildDetails: activeChildDetails,
      activityTypes: sortedActivityTypes,
      latestActivitiesByType: _mapLatestByType(
        summary?.lastActivities ?? const [],
      ),
      todayCountByType: _mapTodayCounts(todayActivities),
      recentReminders: [...reminders]..sort(sortReminders),
    );
  }

  Future<Reminder> completeReminder(int reminderId) {
    return _remindersUseCase.completeReminder(reminderId);
  }

  Future<T?> _runSafely<T>(Future<T> Function() action) async {
    try {
      return await action();
    } catch (_) {
      return null;
    }
  }

  Map<int, ActivityItem> _mapLatestByType(List<ActivityItem> items) {
    final sorted = [...items]
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    final latest = <int, ActivityItem>{};
    for (final item in sorted) {
      latest.putIfAbsent(item.activityType, () => item);
    }

    return latest;
  }

  Map<int, int> _mapTodayCounts(List<ActivityItem> items) {
    final counts = <int, int>{};

    for (final item in items) {
      counts.update(item.activityType, (value) => value + 1, ifAbsent: () => 1);
    }

    return counts;
  }

  static const ActivityType fallbackOtherType = ActivityType(
    id: -1,
    slug: 'other',
    iconUrl: '',
    color: '#706A93',
    hasDuration: false,
    hasQuality: false,
    isActive: true,
    order: 999,
    title: 'Other',
    description: '',
  );

  int sortReminders(Reminder a, Reminder b) {
    final aCompleted = a.status == ReminderStatus.completed;
    final bCompleted = b.status == ReminderStatus.completed;

    if (aCompleted != bCompleted) {
      return aCompleted ? 1 : -1;
    }

    return a.dueAt.compareTo(b.dueAt);
  }
}
