import 'package:novda_sdk/novda_sdk.dart';

class HomeDashboardData {
  const HomeDashboardData({
    required this.activeChild,
    required this.activeChildDetails,
    required this.activityTypes,
    required this.latestActivitiesByType,
    required this.todayCountByType,
    required this.recentReminders,
  });

  factory HomeDashboardData.empty() {
    return const HomeDashboardData(
      activeChild: null,
      activeChildDetails: null,
      activityTypes: [],
      latestActivitiesByType: {},
      todayCountByType: {},
      recentReminders: [],
    );
  }

  final ChildListItem? activeChild;
  final Child? activeChildDetails;
  final List<ActivityType> activityTypes;
  final Map<int, ActivityItem> latestActivitiesByType;
  final Map<int, int> todayCountByType;
  final List<Reminder> recentReminders;

  bool get hasAnyContent {
    return activeChild != null ||
        activityTypes.isNotEmpty ||
        recentReminders.isNotEmpty;
  }
}
