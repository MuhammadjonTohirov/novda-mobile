import 'package:novda/core/app/app.dart';
import 'package:novda/core/services/services.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/base/base_view_model.dart';
import '../interactors/home_interactor.dart';

class HomeViewModel extends BaseViewModel with ActionErrorMixin {
  HomeViewModel({HomeInteractor? interactor})
    : _interactor = interactor ?? HomeInteractor();

  final HomeInteractor _interactor;

  HomeDashboardData _dashboard = HomeDashboardData.empty();
  final Set<int> _updatingReminderIds = <int>{};

  ChildListItem? get activeChild => _dashboard.activeChild;
  List<ChildListItem> get children => _dashboard.children;
  Child? get activeChildDetails => _dashboard.activeChildDetails;
  List<ActivityType> get activityTypes => _dashboard.activityTypes;
  Map<int, ActivityItem> get latestActivitiesByType =>
      _dashboard.latestActivitiesByType;
  Map<int, int> get todayCountByType => _dashboard.todayCountByType;
  List<Reminder> get recentReminders => _dashboard.recentReminders;
  bool get hasAnyContent => _dashboard.hasAnyContent;

  bool isUpdatingReminder(int reminderId) =>
      _updatingReminderIds.contains(reminderId);

  Future<void> load() async {
    setLoading();

    try {
      _dashboard = await _interactor.loadDashboard();
      setSuccess();
    } catch (error) {
      handleException(error);
    }
  }

  Future<ThemeVariant?> selectChild(int childId) async {
    if (activeChild?.id == childId) return null;

    try {
      await _interactor.selectChild(childId);
      final themeVariant = await services.resolveThemeVariant(
        selectedChildId: childId,
      );
      await load();
      return themeVariant;
    } catch (error) {
      setActionError(error);
      return null;
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
        children: _dashboard.children,
        activeChild: _dashboard.activeChild,
        activeChildDetails: _dashboard.activeChildDetails,
        activityTypes: _dashboard.activityTypes,
        latestActivitiesByType: _dashboard.latestActivitiesByType,
        todayCountByType: _dashboard.todayCountByType,
        recentReminders: currentReminders,
      );
    } catch (error) {
      setActionError(error);
    } finally {
      _updatingReminderIds.remove(reminderId);
      notifyListeners();
    }
  }
}
