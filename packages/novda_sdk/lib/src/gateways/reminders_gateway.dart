import '../core/network/api_client.dart';
import '../core/network/json_helpers.dart';
import '../models/reminder.dart';

/// Gateway interface for reminder operations
abstract interface class RemindersGateway {
  Future<List<Reminder>> getReminders(int childId, ReminderListQuery query);
  Future<Reminder> getReminder(int reminderId);
  Future<List<CalendarDay>> getCalendar(int childId, String month);
  Future<List<Reminder>> searchReminders(
    int childId,
    String query, {
    int? limit,
  });
  Future<Reminder> createReminder(int childId, ReminderCreateRequest request);
  Future<Reminder> updateReminder(
    int reminderId,
    ReminderUpdateRequest request,
  );
  Future<Reminder> completeReminder(int reminderId);
  Future<void> deleteReminder(int reminderId);
}

/// Implementation of RemindersGateway
class RemindersGatewayImpl implements RemindersGateway {
  RemindersGatewayImpl(this._client);

  final ApiClient _client;

  @override
  Future<List<Reminder>> getReminders(
    int childId,
    ReminderListQuery query,
  ) async {
    return _client.get(
      '/api/v1/children/$childId/reminders',
      queryParameters: query.toQueryParams(),
      fromJson: (json) => extractList(
        json,
        candidateKeys: const ['reminders', 'results'],
      ).map((e) => Reminder.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  @override
  Future<Reminder> getReminder(int reminderId) async {
    return _client.get(
      '/api/v1/reminders/$reminderId',
      fromJson: (json) => Reminder.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<List<CalendarDay>> getCalendar(int childId, String month) async {
    return _client.get(
      '/api/v1/children/$childId/reminders/calendar',
      queryParameters: {'month': month},
      fromJson: (json) => extractList(
        json,
        candidateKeys: const ['calendar', 'days', 'results'],
      ).map((e) => CalendarDay.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  @override
  Future<List<Reminder>> searchReminders(
    int childId,
    String query, {
    int? limit,
  }) async {
    return _client.get(
      '/api/v1/children/$childId/reminders/search',
      queryParameters: {
        'q': query,
        if (limit != null) 'limit': limit.toString(),
      },
      fromJson: (json) => extractList(
        json,
        candidateKeys: const ['reminders', 'results'],
      ).map((e) => Reminder.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  @override
  Future<Reminder> createReminder(
    int childId,
    ReminderCreateRequest request,
  ) async {
    return _client.post(
      '/api/v1/children/$childId/reminders/create',
      data: request.toJson(),
      fromJson: (json) => Reminder.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Reminder> updateReminder(
    int reminderId,
    ReminderUpdateRequest request,
  ) async {
    return _client.patch(
      '/api/v1/reminders/$reminderId/update',
      data: request.toJson(),
      fromJson: (json) => Reminder.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<Reminder> completeReminder(int reminderId) async {
    return _client.post(
      '/api/v1/reminders/$reminderId/complete',
      fromJson: (json) => Reminder.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<void> deleteReminder(int reminderId) async {
    await _client.delete('/api/v1/reminders/$reminderId/delete');
  }
}
