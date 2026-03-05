import 'dart:math' as math;

import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../../core/base/base_view_model.dart';
import '../interactor/reminders_interactor.dart';

class RemindersViewModel extends BaseViewModel with ActionErrorMixin {
  RemindersViewModel({
    RemindersInteractor? interactor,
    DateTime? initialDate,
    bool initiallyExpanded = true,
  }) : _interactor = interactor ?? RemindersInteractor(),
       _isCalendarExpanded = initiallyExpanded {
    final selected = _dateOnly(initialDate ?? DateTime.now());
    _selectedDate = selected;
    _visibleMonth = DateTime(selected.year, selected.month);
  }

  final RemindersInteractor _interactor;

  int? _childId;
  late DateTime _selectedDate;
  late DateTime _visibleMonth;
  bool _isCalendarExpanded;
  bool _isReady = false;
  bool _isRefreshingCalendar = false;
  bool _isRefreshingDayReminders = false;
  Map<DateTime, CalendarDay> _calendarDaysByDate = const {};
  List<Reminder> _selectedDayReminders = const [];
  final Set<int> _updatingReminderIds = <int>{};

  int? get childId => _childId;
  DateTime get selectedDate => _selectedDate;
  DateTime get visibleMonth => _visibleMonth;
  bool get isCalendarExpanded => _isCalendarExpanded;
  bool get isReady => _isReady;
  bool get isRefreshingCalendar => _isRefreshingCalendar;
  bool get isRefreshingDayReminders => _isRefreshingDayReminders;
  List<Reminder> get selectedDayReminders => _selectedDayReminders;
  bool get hasChild => _childId != null;
  bool get hasReminders => _selectedDayReminders.isNotEmpty;

  bool get canShowContent {
    if (!_isReady) return false;
    if (hasError && !hasChild) return false;
    return true;
  }

  bool isUpdatingReminder(int reminderId) =>
      _updatingReminderIds.contains(reminderId);

  Future<void> load() async {
    setLoading();

    try {
      _childId = await _interactor.resolveActiveChildId();
      if (_childId != null) {
        await Future.wait([
          _loadCalendar(notifyBusy: false),
          _loadDayReminders(notifyBusy: false),
        ]);
      } else {
        _calendarDaysByDate = const {};
        _selectedDayReminders = const [];
      }

      _isReady = true;
      setSuccess();
    } catch (error) {
      _isReady = true;
      handleException(error);
    }
  }

  Future<void> refresh() async {
    if (!hasChild) return;
    await Future.wait([_loadCalendar(), _loadDayReminders()]);
  }

  Future<void> selectDate(DateTime date) async {
    final normalized = _dateOnly(date);
    final isSameDay = _isSameDate(normalized, _selectedDate);
    final isSameMonth = _isSameMonthDate(normalized, _visibleMonth);

    if (isSameDay && isSameMonth) return;

    _selectedDate = normalized;
    _visibleMonth = DateTime(normalized.year, normalized.month);
    notifyListeners();

    if (!hasChild) return;

    if (isSameMonth) {
      await _loadDayReminders();
      return;
    }

    await Future.wait([_loadCalendar(), _loadDayReminders()]);
  }

  Future<void> selectToday() {
    return selectDate(DateTime.now());
  }

  Future<void> previousMonth() {
    return _changeMonth(-1);
  }

  Future<void> nextMonth() {
    return _changeMonth(1);
  }

  void toggleCalendarExpanded() {
    _isCalendarExpanded = !_isCalendarExpanded;
    notifyListeners();
  }

  Future<void> onReminderCreated() async {
    if (!hasChild) return;
    await Future.wait([_loadCalendar(), _loadDayReminders()]);
  }

  Future<void> completeReminder(int reminderId) async {
    if (_updatingReminderIds.contains(reminderId)) return;

    final index = _selectedDayReminders.indexWhere(
      (item) => item.id == reminderId,
    );
    if (index < 0) return;

    final current = _selectedDayReminders[index];
    if (current.status == ReminderStatus.completed) return;

    _updatingReminderIds.add(reminderId);
    notifyListeners();

    try {
      final updated = await _interactor.completeReminder(reminderId);
      final reminders = [..._selectedDayReminders];
      reminders[index] = updated;
      reminders.sort(_interactor.sortReminders);
      _selectedDayReminders = reminders;
      notifyListeners();
    } catch (error) {
      setActionError(error);
      notifyListeners();
    } finally {
      _updatingReminderIds.remove(reminderId);
      notifyListeners();
    }
  }

  bool isSelectedDate(DateTime day) => _isSameDate(day, _selectedDate);

  bool hasMarker(DateTime day) {
    final key = _dateOnly(day);
    final info = _calendarDaysByDate[key];
    return (info?.totalCount ?? 0) > 0;
  }

  Future<void> _changeMonth(int delta) async {
    final target = DateTime(_visibleMonth.year, _visibleMonth.month + delta);
    final daysInTargetMonth = DateTime(target.year, target.month + 1, 0).day;
    final selectedDay = math.min(_selectedDate.day, daysInTargetMonth);
    _selectedDate = DateTime(target.year, target.month, selectedDay);
    _visibleMonth = DateTime(target.year, target.month);
    notifyListeners();

    if (!hasChild) return;
    await Future.wait([_loadCalendar(), _loadDayReminders()]);
  }

  Future<void> _loadCalendar({bool notifyBusy = true}) async {
    final childId = _childId;
    if (childId == null) return;

    if (notifyBusy) {
      _isRefreshingCalendar = true;
      notifyListeners();
    }

    try {
      final calendarDays = await _interactor.loadCalendarDays(
        childId,
        _visibleMonth,
      );
      _calendarDaysByDate = {
        for (final day in calendarDays) _dateOnly(day.date.toLocal()): day,
      };
    } catch (error) {
      setActionError(error);
    } finally {
      if (notifyBusy) {
        _isRefreshingCalendar = false;
        notifyListeners();
      }
    }
  }

  Future<void> _loadDayReminders({bool notifyBusy = true}) async {
    final childId = _childId;
    if (childId == null) return;

    if (notifyBusy) {
      _isRefreshingDayReminders = true;
      notifyListeners();
    }

    try {
      _selectedDayReminders = await _interactor.loadRemindersForDate(
        childId,
        _selectedDate,
      );
    } catch (error) {
      setActionError(error);
    } finally {
      if (notifyBusy) {
        _isRefreshingDayReminders = false;
        notifyListeners();
      }
    }
  }

  static DateTime _dateOnly(DateTime value) {
    final local = value.toLocal();
    return DateTime(local.year, local.month, local.day);
  }

  static bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static bool _isSameMonthDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;
}
