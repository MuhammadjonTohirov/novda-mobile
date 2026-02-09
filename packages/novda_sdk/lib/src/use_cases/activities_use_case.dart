import '../gateways/activities_gateway.dart';
import '../models/activity.dart';
import '../models/enums.dart';

/// Use case interface for activity operations
abstract interface class ActivitiesUseCase {
  /// Get all available activity types
  Future<List<ActivityType>> getActivityTypes();

  /// Get all condition types for illness tracking
  Future<List<ConditionType>> getConditionTypes();

  /// Get activities for a child with optional filters
  Future<List<ActivityItem>> getActivities(
    int childId, {
    String? type,
    DateTime? from,
    DateTime? to,
    int? limit,
  });

  /// Get single activity by ID
  Future<ActivityItem> getActivity(int activityId);

  /// Get activity summary/dashboard data for a child
  Future<ActivitySummary> getActivitySummary(int childId);

  /// Create a new activity for a child
  Future<ActivityItem> createActivity(
    int childId, {
    required int activityType,
    required DateTime startDate,
    DateTime? endDate,
    Quality? quality,
    String? comments,
    Map<String, dynamic>? metadata,
  });

  /// Update an existing activity
  Future<ActivityItem> updateActivity(
    int activityId, {
    DateTime? startDate,
    DateTime? endDate,
    Quality? quality,
    String? comments,
    Map<String, dynamic>? metadata,
  });

  /// Delete an activity
  Future<void> deleteActivity(int activityId);
}

/// Implementation of ActivitiesUseCase
class ActivitiesUseCaseImpl implements ActivitiesUseCase {
  ActivitiesUseCaseImpl(this._gateway);

  final ActivitiesGateway _gateway;

  @override
  Future<List<ActivityType>> getActivityTypes() {
    return _gateway.getActivityTypes();
  }

  @override
  Future<List<ConditionType>> getConditionTypes() {
    return _gateway.getConditionTypes();
  }

  @override
  Future<List<ActivityItem>> getActivities(
    int childId, {
    String? type,
    DateTime? from,
    DateTime? to,
    int? limit,
  }) {
    return _gateway.getActivities(
      childId,
      ActivityListQuery(type: type, from: from, to: to, limit: limit),
    );
  }

  @override
  Future<ActivityItem> getActivity(int activityId) {
    return _gateway.getActivity(activityId);
  }

  @override
  Future<ActivitySummary> getActivitySummary(int childId) {
    return _gateway.getActivitySummary(childId);
  }

  @override
  Future<ActivityItem> createActivity(
    int childId, {
    required int activityType,
    required DateTime startDate,
    DateTime? endDate,
    Quality? quality,
    String? comments,
    Map<String, dynamic>? metadata,
  }) {
    return _gateway.createActivity(
      childId,
      ActivityCreateRequest(
        activityType: activityType,
        startDate: startDate,
        endDate: endDate,
        quality: quality,
        comments: comments,
        metadata: metadata,
      ),
    );
  }

  @override
  Future<ActivityItem> updateActivity(
    int activityId, {
    DateTime? startDate,
    DateTime? endDate,
    Quality? quality,
    String? comments,
    Map<String, dynamic>? metadata,
  }) {
    return _gateway.updateActivity(
      activityId,
      ActivityUpdateRequest(
        startDate: startDate,
        endDate: endDate,
        quality: quality,
        comments: comments,
        metadata: metadata,
      ),
    );
  }

  @override
  Future<void> deleteActivity(int activityId) {
    return _gateway.deleteActivity(activityId);
  }
}
