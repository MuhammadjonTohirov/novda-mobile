import 'package:intl/intl.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../../core/services/services.dart';

class RemindersInteractor {
  RemindersInteractor({
    ActiveChildResolver? activeChildResolver,
    RemindersUseCase? remindersUseCase,
  }) : _activeChildResolver = activeChildResolver ?? ActiveChildResolver(),
       _remindersUseCase = remindersUseCase ?? services.sdk.reminders;

  final ActiveChildResolver _activeChildResolver;
  final RemindersUseCase _remindersUseCase;

  Future<int?> resolveActiveChildId() => _activeChildResolver.resolveActiveChildId();

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
