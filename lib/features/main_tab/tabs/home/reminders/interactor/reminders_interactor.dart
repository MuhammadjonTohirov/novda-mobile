import 'package:intl/intl.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../../core/services/services.dart';

class RemindersInteractor {
  RemindersInteractor({
    UserUseCase? userUseCase,
    ChildrenUseCase? childrenUseCase,
    RemindersUseCase? remindersUseCase,
  }) : _userUseCase = userUseCase ?? services.sdk.user,
       _childrenUseCase = childrenUseCase ?? services.sdk.children,
       _remindersUseCase = remindersUseCase ?? services.sdk.reminders;

  final UserUseCase _userUseCase;
  final ChildrenUseCase _childrenUseCase;
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

  Future<List<CalendarDay>> loadCalendarDays(int childId, DateTime month) {
    final monthKey = DateFormat('yyyy-MM').format(month);
    return _remindersUseCase.getCalendar(childId, month: monthKey);
  }

  Future<List<Reminder>> loadRemindersForDate(
    int childId,
    DateTime date,
  ) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start
        .add(const Duration(days: 1))
        .subtract(const Duration(milliseconds: 1));

    final reminders = await _remindersUseCase.getReminders(
      childId,
      from: start,
      to: end,
      limit: 200,
    );

    final sorted = [...reminders]..sort(sortReminders);
    return sorted;
  }

  Future<Reminder> completeReminder(int reminderId) {
    return _remindersUseCase.completeReminder(reminderId);
  }

  int sortReminders(Reminder a, Reminder b) {
    final aCompleted = a.status == ReminderStatus.completed;
    final bCompleted = b.status == ReminderStatus.completed;

    if (aCompleted != bCompleted) {
      return aCompleted ? 1 : -1;
    }

    return a.dueAt.compareTo(b.dueAt);
  }
}
