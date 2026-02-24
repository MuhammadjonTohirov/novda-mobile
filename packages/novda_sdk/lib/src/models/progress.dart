import 'package:equatable/equatable.dart';

enum ProgressGenderFilter {
  boy('boy'),
  girl('girl'),
  all('all');

  const ProgressGenderFilter(this.value);
  final String value;

  static ProgressGenderFilter fromString(String? value) {
    return ProgressGenderFilter.values.firstWhere(
      (item) => item.value == value || item.name == value,
      orElse: () => ProgressGenderFilter.all,
    );
  }
}

enum ProgressPeriodUnit {
  week('week'),
  month('month'),
  year('year'),
  custom('custom'),
  unknown('unknown');

  const ProgressPeriodUnit(this.value);
  final String value;

  static ProgressPeriodUnit fromString(String? value) {
    return ProgressPeriodUnit.values.firstWhere(
      (item) => item.value == value || item.name == value,
      orElse: () => ProgressPeriodUnit.unknown,
    );
  }
}

class ProgressContentItem extends Equatable {
  const ProgressContentItem({
    required this.data,
    this.title,
    this.description,
    this.icon,
    this.order,
  });

  final Map<String, dynamic> data;
  final String? title;
  final String? description;
  final String? icon;
  final int? order;

  factory ProgressContentItem.fromJson(Object? json) {
    if (json is Map) {
      final data = Map<String, dynamic>.from(json);
      return ProgressContentItem(
        data: data,
        title: _readString(data, const ['title', 'name', 'headline']),
        description: _readString(data, const [
          'description',
          'summary',
          'text',
          'body',
        ]),
        icon: _readString(data, const ['icon', 'icon_url']),
        order: _toInt(data['order']),
      );
    }

    if (json is String) {
      return ProgressContentItem(data: {'value': json}, title: json);
    }

    return ProgressContentItem(data: {'value': json}, title: json?.toString());
  }

  @override
  List<Object?> get props => [data, title, description, icon, order];
}

class ProgressPeriod extends Equatable {
  const ProgressPeriod({
    required this.periodUnit,
    required this.periodIndex,
    this.weekNumber,
    this.ageStartDays,
    this.ageEndDays,
    this.dateRange,
    this.startDate,
    this.endDate,
    this.stageType,
    this.weekType,
    this.isCurrent = false,
    this.isPast = false,
    this.crisisWarning,
    this.crisisDescription,
  });

  final ProgressPeriodUnit periodUnit;
  final int periodIndex;
  final int? weekNumber;
  final int? ageStartDays;
  final int? ageEndDays;
  final String? dateRange;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? stageType;
  final String? weekType;
  final bool isCurrent;
  final bool isPast;
  final String? crisisWarning;
  final String? crisisDescription;

  factory ProgressPeriod.fromJson(Map<String, dynamic> json) {
    final periodUnitValue = _toNullableString(json['period_unit']);
    return ProgressPeriod(
      periodUnit: ProgressPeriodUnit.fromString(periodUnitValue),
      periodIndex: _toInt(json['period_index']) ?? 0,
      weekNumber: _toInt(json['week_number']),
      ageStartDays: _toInt(json['age_start_days']),
      ageEndDays: _toInt(json['age_end_days']),
      dateRange: _toNullableString(json['date_range']),
      startDate: _toDateTime(json['start_date']),
      endDate: _toDateTime(json['end_date']),
      stageType: _toNullableString(json['stage_type']),
      weekType: _toNullableString(json['week_type']),
      isCurrent: _toBool(json['is_current']),
      isPast: _toBool(json['is_past']),
      crisisWarning: _toNullableString(json['crisis_warning']),
      crisisDescription: _toNullableString(json['crisis_description']),
    );
  }

  @override
  List<Object?> get props => [
    periodUnit,
    periodIndex,
    weekNumber,
    ageStartDays,
    ageEndDays,
    dateRange,
    startDate,
    endDate,
    stageType,
    weekType,
    isCurrent,
    isPast,
    crisisWarning,
    crisisDescription,
  ];
}

class ProgressGuide extends Equatable {
  const ProgressGuide({
    required this.periodUnit,
    required this.periodIndex,
    this.weekNumber,
    this.stageType,
    this.weekType,
    this.dateRange,
    this.startDate,
    this.endDate,
    this.headline,
    this.summary,
    this.crisisWarning,
    this.crisisDescription,
    required this.exercises,
    required this.suggestions,
    required this.recommendations,
  });

  final ProgressPeriodUnit periodUnit;
  final int periodIndex;
  final int? weekNumber;
  final String? stageType;
  final String? weekType;
  final String? dateRange;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? headline;
  final String? summary;
  final String? crisisWarning;
  final String? crisisDescription;
  final List<ProgressContentItem> exercises;
  final List<ProgressContentItem> suggestions;
  final List<ProgressContentItem> recommendations;

  factory ProgressGuide.fromJson(Map<String, dynamic> json) {
    final periodUnitValue = _toNullableString(json['period_unit']);
    return ProgressGuide(
      periodUnit: ProgressPeriodUnit.fromString(periodUnitValue),
      periodIndex: _toInt(json['period_index']) ?? 0,
      weekNumber: _toInt(json['week_number']),
      stageType: _toNullableString(json['stage_type']),
      weekType: _toNullableString(json['week_type']),
      dateRange: _toNullableString(json['date_range']),
      startDate: _toDateTime(json['start_date']),
      endDate: _toDateTime(json['end_date']),
      headline: _toNullableString(json['headline']),
      summary: _toNullableString(json['summary']),
      crisisWarning: _toNullableString(json['crisis_warning']),
      crisisDescription: _toNullableString(json['crisis_description']),
      exercises: _contentList(json['exercises']),
      suggestions: _contentList(json['suggestions']),
      recommendations: _contentList(json['recommendations']),
    );
  }

  @override
  List<Object?> get props => [
    periodUnit,
    periodIndex,
    weekNumber,
    stageType,
    weekType,
    dateRange,
    startDate,
    endDate,
    headline,
    summary,
    crisisWarning,
    crisisDescription,
    exercises,
    suggestions,
    recommendations,
  ];
}

class ProgressPeriodSelector extends Equatable {
  const ProgressPeriodSelector({
    this.currentPeriodUnit,
    this.currentPeriodIndex,
    this.currentWeekNumber,
    required this.periods,
  });

  final ProgressPeriodUnit? currentPeriodUnit;
  final int? currentPeriodIndex;
  final int? currentWeekNumber;
  final List<ProgressPeriod> periods;

  factory ProgressPeriodSelector.fromJson(Map<String, dynamic> json) {
    return ProgressPeriodSelector(
      currentPeriodUnit: _readPeriodUnit(json, const ['current_period_unit']),
      currentPeriodIndex: _readInt(json, const [
        'current_period_index',
        'current_week',
      ]),
      currentWeekNumber: _readInt(json, const [
        'current_week_number',
        'current_week',
      ]),
      periods: _periodList(json['periods'] ?? json['weeks']),
    );
  }

  @override
  List<Object?> get props => [
    currentPeriodUnit,
    currentPeriodIndex,
    currentWeekNumber,
    periods,
  ];
}

class ProgressCrisisCalendar extends Equatable {
  const ProgressCrisisCalendar({
    this.currentPeriod,
    this.maxPeriodIndex,
    this.currentWeekNumber,
    this.maxWeek,
    required this.weeks,
  });

  final ProgressPeriod? currentPeriod;
  final int? maxPeriodIndex;
  final int? currentWeekNumber;
  final int? maxWeek;
  final List<ProgressPeriod> weeks;

  factory ProgressCrisisCalendar.fromJson(Map<String, dynamic> json) {
    final currentPeriodRaw = json['current_period'];
    return ProgressCrisisCalendar(
      currentPeriod: currentPeriodRaw is Map
          ? ProgressPeriod.fromJson(Map<String, dynamic>.from(currentPeriodRaw))
          : null,
      maxPeriodIndex: _toInt(json['max_period_index']),
      currentWeekNumber: _toInt(json['current_week_number']),
      maxWeek: _toInt(json['max_week']),
      weeks: _periodList(json['weeks']),
    );
  }

  @override
  List<Object?> get props => [
    currentPeriod,
    maxPeriodIndex,
    currentWeekNumber,
    maxWeek,
    weeks,
  ];
}

class ProgressAllPeriods extends Equatable {
  const ProgressAllPeriods({required this.total, required this.periods});

  final int total;
  final List<ProgressPeriod> periods;

  factory ProgressAllPeriods.fromJson(Map<String, dynamic> json) {
    return ProgressAllPeriods(
      total: _toInt(json['total']) ?? 0,
      periods: _periodList(json['periods']),
    );
  }

  @override
  List<Object?> get props => [total, periods];
}

class ProgressPeriodSelectorQuery {
  const ProgressPeriodSelectorQuery({
    this.ageDays,
    this.gender,
    this.before,
    this.after,
    this.periodUnit,
    this.periodIndex,
  });

  final int? ageDays;
  final ProgressGenderFilter? gender;
  final int? before;
  final int? after;
  final ProgressPeriodUnit? periodUnit;
  final int? periodIndex;

  Map<String, dynamic> toQueryParams() => {
    if (ageDays != null) 'age_days': ageDays.toString(),
    if (gender != null) 'gender': gender!.value,
    if (before != null) 'before': before.toString(),
    if (after != null) 'after': after.toString(),
    if (periodUnit != null && periodUnit != ProgressPeriodUnit.unknown)
      'period_unit': periodUnit!.value,
    if (periodIndex != null) 'period_index': periodIndex.toString(),
  };
}

List<ProgressContentItem> _contentList(Object? value) {
  if (value is! List<dynamic>) return const [];
  return value.map(ProgressContentItem.fromJson).toList();
}

List<ProgressPeriod> _periodList(Object? value) {
  if (value is! List<dynamic>) return const [];
  final periods = <ProgressPeriod>[];
  for (final item in value) {
    if (item is Map) {
      periods.add(ProgressPeriod.fromJson(Map<String, dynamic>.from(item)));
    }
  }
  return periods;
}

String? _readString(Map<String, dynamic> map, List<String> keys) {
  for (final key in keys) {
    final value = _toNullableString(map[key]);
    if (value != null) return value;
  }
  return null;
}

int? _readInt(Map<String, dynamic> map, List<String> keys) {
  for (final key in keys) {
    final value = _toInt(map[key]);
    if (value != null) return value;
  }
  return null;
}

ProgressPeriodUnit? _readPeriodUnit(
  Map<String, dynamic> map,
  List<String> keys,
) {
  for (final key in keys) {
    final raw = _toNullableString(map[key]);
    if (raw != null) {
      return ProgressPeriodUnit.fromString(raw);
    }
  }
  return null;
}

String? _toNullableString(Object? value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

int? _toInt(Object? value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
}

bool _toBool(Object? value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  final text = value?.toString().toLowerCase();
  if (text == 'true' || text == '1') return true;
  if (text == 'false' || text == '0') return false;
  return false;
}

DateTime? _toDateTime(Object? value) {
  final text = _toNullableString(value);
  if (text == null) return null;
  return DateTime.tryParse(text);
}
