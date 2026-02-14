import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/services/services.dart';

class AddActionSheetInteractor {
  AddActionSheetInteractor({ActivitiesUseCase? activitiesUseCase})
    : _activitiesUseCase = activitiesUseCase ?? services.sdk.activities;

  final ActivitiesUseCase _activitiesUseCase;

  Future<List<ActivityType>> loadActivityTypes() async {
    final types = await _activitiesUseCase.getActivityTypes();

    final active = types.where((type) => type.isActive).toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    return active;
  }
}
