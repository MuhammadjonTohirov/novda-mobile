import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../../core/services/services.dart';

class ActivityHistoryInteractor {
  ActivityHistoryInteractor({ActivitiesUseCase? activitiesUseCase})
    : _activitiesUseCase = activitiesUseCase ?? services.sdk.activities;

  final ActivitiesUseCase _activitiesUseCase;

  Future<List<ActivityType>> loadActivityTypes() async {
    final types = await _activitiesUseCase.getActivityTypes();

    final active = types.where((type) => type.isActive).toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    return active;
  }

  Future<List<ActivityItem>> loadActivities(int childId) async {
    final activities = await _activitiesUseCase.getActivities(
      childId,
      limit: 300,
    );

    final sorted = [...activities]
      ..sort((a, b) => b.startDate.compareTo(a.startDate));

    return sorted;
  }
}
