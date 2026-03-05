import '../core/cache/in_memory_cache.dart';
import '../models/activity.dart';
import '../models/enums.dart';
import 'activities_use_case.dart';

/// Caching decorator for [ActivitiesUseCase].
///
/// Caches [getActivityTypes] and [getConditionTypes] with a 10-minute TTL
/// since these rarely change.
/// Other methods are not cached as they are context-sensitive or change frequently.
class CachedActivitiesUseCase implements ActivitiesUseCase {
  CachedActivitiesUseCase(this._inner);

  final ActivitiesUseCase _inner;
  final _activityTypesCache = InMemoryCache<List<ActivityType>>(
    ttl: Duration(minutes: 10),
  );
  final _conditionTypesCache = InMemoryCache<List<ConditionType>>(
    ttl: Duration(minutes: 10),
  );

  @override
  Future<List<ActivityType>> getActivityTypes() async {
    final cached = _activityTypesCache.value;
    if (cached != null) return cached;
    final result = await _inner.getActivityTypes();
    _activityTypesCache.set(result);
    return result;
  }

  @override
  Future<List<ConditionType>> getConditionTypes() async {
    final cached = _conditionTypesCache.value;
    if (cached != null) return cached;
    final result = await _inner.getConditionTypes();
    _conditionTypesCache.set(result);
    return result;
  }

  @override
  Future<List<ActivityItem>> getActivities(
    int childId, {
    String? type,
    DateTime? from,
    DateTime? to,
    int? limit,
  }) =>
      _inner.getActivities(childId, type: type, from: from, to: to, limit: limit);

  @override
  Future<ActivityItem> getActivity(int activityId) =>
      _inner.getActivity(activityId);

  @override
  Future<ActivitySummary> getActivitySummary(int childId) =>
      _inner.getActivitySummary(childId);

  @override
  Future<ActivityItem> createActivity(
    int childId, {
    required int activityType,
    required DateTime startDate,
    DateTime? endDate,
    Quality? quality,
    String? comments,
    Map<String, dynamic>? metadata,
  }) =>
      _inner.createActivity(
        childId,
        activityType: activityType,
        startDate: startDate,
        endDate: endDate,
        quality: quality,
        comments: comments,
        metadata: metadata,
      );

  @override
  Future<ActivityItem> updateActivity(
    int activityId, {
    DateTime? startDate,
    DateTime? endDate,
    Quality? quality,
    String? comments,
    Map<String, dynamic>? metadata,
  }) =>
      _inner.updateActivity(
        activityId,
        startDate: startDate,
        endDate: endDate,
        quality: quality,
        comments: comments,
        metadata: metadata,
      );

  @override
  Future<void> deleteActivity(int activityId) =>
      _inner.deleteActivity(activityId);
}
