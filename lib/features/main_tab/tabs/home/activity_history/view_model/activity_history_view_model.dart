import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../../core/base/base_view_model.dart';
import '../interactor/activity_history_interactor.dart';

class ActivityHistorySection {
  const ActivityHistorySection({required this.date, required this.items});

  final DateTime date;
  final List<ActivityItem> items;
}

class ActivityHistoryViewModel extends BaseViewModel {
  ActivityHistoryViewModel({
    required int childId,
    List<ActivityType> initialTypes = const [],
    ActivityHistoryInteractor? interactor,
  }) : _childId = childId,
       _initialTypes = initialTypes,
       _interactor = interactor ?? ActivityHistoryInteractor();

  final int _childId;
  final List<ActivityType> _initialTypes;
  final ActivityHistoryInteractor _interactor;

  List<ActivityType> _activityTypes = const [];
  List<ActivityItem> _activities = const [];
  final Set<int> _selectedTypeIds = <int>{};

  List<ActivityType> get activityTypes => _activityTypes;
  Set<int> get selectedTypeIds => _selectedTypeIds;

  List<ActivityItem> get filteredActivities {
    if (_selectedTypeIds.isEmpty) return _activities;

    return _activities
        .where((item) => _selectedTypeIds.contains(item.activityType))
        .toList();
  }

  List<ActivityHistorySection> get sections {
    final groups = <String, List<ActivityItem>>{};
    final dates = <String, DateTime>{};

    for (final item in filteredActivities) {
      final local = item.startDate.toLocal();
      final date = DateTime(local.year, local.month, local.day);
      final key = '${date.year}-${date.month}-${date.day}';

      groups.putIfAbsent(key, () => <ActivityItem>[]).add(item);
      dates.putIfAbsent(key, () => date);
    }

    final sectionKeys = groups.keys.toList()
      ..sort((a, b) => dates[b]!.compareTo(dates[a]!));

    return sectionKeys
        .map(
          (key) =>
              ActivityHistorySection(date: dates[key]!, items: groups[key]!),
        )
        .toList();
  }

  bool get hasActivityTypes => _activityTypes.isNotEmpty;
  bool get hasActivities => _activities.isNotEmpty;

  Future<void> load() async {
    setLoading();

    try {
      final typesFuture = _initialTypes.isNotEmpty
          ? Future.value(_initialTypes)
          : _interactor.loadActivityTypes();

      final results = await Future.wait([
        typesFuture,
        _interactor.loadActivities(_childId),
      ]);

      _activityTypes = results[0] as List<ActivityType>;
      _activities = results[1] as List<ActivityItem>;

      setSuccess();
    } catch (error) {
      handleException(error);
    }
  }

  void toggleTypeFilter(int activityTypeId) {
    if (_selectedTypeIds.contains(activityTypeId)) {
      _selectedTypeIds.remove(activityTypeId);
    } else {
      _selectedTypeIds.add(activityTypeId);
    }

    notifyListeners();
  }
}
