import '../core/network/api_client.dart';
import '../models/activity.dart';

/// Gateway interface for activity operations
abstract interface class ActivitiesGateway {
  Future<List<ActivityType>> getActivityTypes();
  Future<List<ConditionType>> getConditionTypes();
  Future<List<ActivityItem>> getActivities(int childId, ActivityListQuery query);
  Future<ActivityItem> getActivity(int activityId);
  Future<ActivitySummary> getActivitySummary(int childId);
  Future<ActivityItem> createActivity(int childId, ActivityCreateRequest request);
  Future<ActivityItem> updateActivity(int activityId, ActivityUpdateRequest request);
  Future<void> deleteActivity(int activityId);
}

/// Implementation of ActivitiesGateway
class ActivitiesGatewayImpl implements ActivitiesGateway {
  ActivitiesGatewayImpl(this._client);

  final ApiClient _client;

  @override
  Future<List<ActivityType>> getActivityTypes() async {
    return _client.get(
      '/api/v1/activities/types',
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ActivityType.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<List<ConditionType>> getConditionTypes() async {
    return _client.get(
      '/api/v1/activities/condition-types',
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ConditionType.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<List<ActivityItem>> getActivities(
    int childId,
    ActivityListQuery query,
  ) async {
    return _client.get(
      '/api/v1/children/$childId/activities',
      queryParameters: query.toQueryParams(),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ActivityItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Future<ActivityItem> getActivity(int activityId) async {
    return _client.get(
      '/api/v1/activities/$activityId',
      fromJson: (json) => ActivityItem.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ActivitySummary> getActivitySummary(int childId) async {
    return _client.get(
      '/api/v1/children/$childId/activities/summary',
      fromJson: (json) => ActivitySummary.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ActivityItem> createActivity(
    int childId,
    ActivityCreateRequest request,
  ) async {
    return _client.post(
      '/api/v1/children/$childId/activities/create',
      data: request.toJson(),
      fromJson: (json) => ActivityItem.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ActivityItem> updateActivity(
    int activityId,
    ActivityUpdateRequest request,
  ) async {
    return _client.patch(
      '/api/v1/activities/$activityId/update',
      data: request.toJson(),
      fromJson: (json) => ActivityItem.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<void> deleteActivity(int activityId) async {
    await _client.delete('/api/v1/activities/$activityId/delete');
  }
}
