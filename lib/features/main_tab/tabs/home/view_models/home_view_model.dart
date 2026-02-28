import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/base/base_view_model.dart';
import '../interactors/home_interactor.dart';

class HomeViewModel extends BaseViewModel {
  HomeViewModel({HomeInteractor? interactor})
    : _interactor = interactor ?? HomeInteractor();

  final HomeInteractor _interactor;

  HomeDashboardData _dashboard = HomeDashboardData.empty();
  final Set<int> _updatingReminderIds = <int>{};
  String? _actionErrorMessage;

  ChildListItem? get activeChild => _dashboard.activeChild;
  Child? get activeChildDetails => _dashboard.activeChildDetails;
  List<ActivityType> get activityTypes => _dashboard.activityTypes;
  Map<int, ActivityItem> get latestActivitiesByType =>
      _dashboard.latestActivitiesByType;
  Map<int, int> get todayCountByType => _dashboard.todayCountByType;
  List<Reminder> get recentReminders => _dashboard.recentReminders;
  bool get hasAnyContent => _dashboard.hasAnyContent;

  bool isUpdatingReminder(int reminderId) =>
      _updatingReminderIds.contains(reminderId);

  String? consumeActionError() {
    final message = _actionErrorMessage;
    _actionErrorMessage = null;
    return message;
  }

  Future<void> load() async {
    setLoading();

    try {
      _dashboard = await _interactor.loadDashboard();
      setSuccess();
    } catch (error) {
      handleException(error);
    }
  }

  Future<void> completeReminder(int reminderId) async {
    if (_updatingReminderIds.contains(reminderId)) return;

    final currentReminders = [..._dashboard.recentReminders];
    final index = currentReminders.indexWhere((r) => r.id == reminderId);
    if (index < 0) return;

    final reminder = currentReminders[index];
    if (reminder.status == ReminderStatus.completed) return;

    _updatingReminderIds.add(reminderId);
    notifyListeners();

    try {
      final updatedReminder = await _interactor.completeReminder(reminderId);
      currentReminders[index] = updatedReminder;
      currentReminders.sort(_interactor.sortReminders);
      _dashboard = HomeDashboardData(
        activeChild: _dashboard.activeChild,
        activeChildDetails: _dashboard.activeChildDetails,
        activityTypes: _dashboard.activityTypes,
        latestActivitiesByType: _dashboard.latestActivitiesByType,
        todayCountByType: _dashboard.todayCountByType,
        recentReminders: currentReminders,
      );
    } catch (error) {
      _actionErrorMessage = _actionErrorText(error);
    } finally {
      _updatingReminderIds.remove(reminderId);
      notifyListeners();
    }
  }

  String _actionErrorText(Object error) {
    if (error is ApiException) {
      return error.message;
    }

    return error.toString();
  }
}
