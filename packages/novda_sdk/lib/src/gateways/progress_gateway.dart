import '../core/network/api_client.dart';
import '../models/progress.dart';

/// Gateway interface for progress operations
abstract interface class ProgressGateway {
  Future<ProgressCrisisCalendar> getCrisisCalendar(int childId);

  Future<ProgressGuide> getCurrentProgress({
    required int ageDays,
    ProgressGenderFilter? gender,
  });

  Future<ProgressPeriodSelector> getPeriodSelector(
    ProgressPeriodSelectorQuery query,
  );

  Future<ProgressGuide> getPeriodDetail({
    required ProgressPeriodUnit periodUnit,
    required int periodIndex,
    ProgressGenderFilter? gender,
  });

  Future<ProgressAllPeriods> getAllPeriods({ProgressGenderFilter? gender});

  Future<ProgressSharedPeriodContent> getSharedPeriodContent({
    required ProgressPeriodUnit periodUnit,
    required int periodIndex,
    ProgressGenderFilter? gender,
  });

  Future<ProgressChildPeriodSuggestions> getChildPeriodSuggestions({
    required int childId,
    required ProgressPeriodUnit periodUnit,
    required int periodIndex,
  });
}

/// Implementation of ProgressGateway
class ProgressGatewayImpl implements ProgressGateway {
  ProgressGatewayImpl(this._client);

  final ApiClient _client;

  @override
  Future<ProgressCrisisCalendar> getCrisisCalendar(int childId) {
    return _client.get(
      '/api/v1/children/$childId/progress/crisis-calendar',
      fromJson: (json) => ProgressCrisisCalendar.fromJson(_extractMap(json)),
    );
  }

  @override
  Future<ProgressGuide> getCurrentProgress({
    required int ageDays,
    ProgressGenderFilter? gender,
  }) {
    return _client.get(
      '/api/v1/progress/current',
      queryParameters: {
        'age_days': ageDays.toString(),
        if (gender != null) 'gender': gender.value,
      },
      fromJson: (json) => ProgressGuide.fromJson(_extractMap(json)),
    );
  }

  @override
  Future<ProgressPeriodSelector> getPeriodSelector(
    ProgressPeriodSelectorQuery query,
  ) {
    return _client.get(
      '/api/v1/progress/periods',
      queryParameters: query.toQueryParams(),
      fromJson: (json) => ProgressPeriodSelector.fromJson(_extractMap(json)),
    );
  }

  @override
  Future<ProgressGuide> getPeriodDetail({
    required ProgressPeriodUnit periodUnit,
    required int periodIndex,
    ProgressGenderFilter? gender,
  }) {
    _ensureValidPeriodUnit(periodUnit);

    return _client.get(
      '/api/v1/progress/periods/${periodUnit.value}/$periodIndex',
      queryParameters: {if (gender != null) 'gender': gender.value},
      fromJson: (json) => ProgressGuide.fromJson(_extractMap(json)),
    );
  }

  @override
  Future<ProgressAllPeriods> getAllPeriods({ProgressGenderFilter? gender}) {
    return _client.get(
      '/api/v1/progress/periods/all',
      queryParameters: {if (gender != null) 'gender': gender.value},
      fromJson: (json) => ProgressAllPeriods.fromJson(_extractMap(json)),
    );
  }

  @override
  Future<ProgressSharedPeriodContent> getSharedPeriodContent({
    required ProgressPeriodUnit periodUnit,
    required int periodIndex,
    ProgressGenderFilter? gender,
  }) {
    _ensureValidPeriodUnit(periodUnit);

    return _client.get(
      '/api/v2/progress/periods/${periodUnit.value}/$periodIndex',
      queryParameters: {if (gender != null) 'gender': gender.value},
      fromJson: (json) =>
          ProgressSharedPeriodContent.fromJson(_extractDataMap(json)),
    );
  }

  @override
  Future<ProgressChildPeriodSuggestions> getChildPeriodSuggestions({
    required int childId,
    required ProgressPeriodUnit periodUnit,
    required int periodIndex,
  }) {
    _ensureValidPeriodUnit(periodUnit);

    return _client.get(
      '/api/v2/children/$childId/progress/periods/${periodUnit.value}/$periodIndex/suggestions',
      fromJson: (json) =>
          ProgressChildPeriodSuggestions.fromJson(_extractDataMap(json)),
    );
  }

  Map<String, dynamic> _extractMap(Object? json) {
    if (json is Map<String, dynamic>) return json;
    if (json is Map) return Map<String, dynamic>.from(json);
    throw const FormatException('Expected an object response');
  }

  Map<String, dynamic> _extractDataMap(Object? json) {
    final root = _extractMap(json);
    final data = root['data'];
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return root;
  }

  void _ensureValidPeriodUnit(ProgressPeriodUnit periodUnit) {
    if (periodUnit != ProgressPeriodUnit.unknown) return;

    throw ArgumentError.value(
      periodUnit,
      'periodUnit',
      'Unknown period unit cannot be used in path params',
    );
  }
}
