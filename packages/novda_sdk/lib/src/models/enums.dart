/// Gender options for child
enum Gender {
  boy,
  girl,
  undisclosed;

  static Gender fromString(String value) {
    return Gender.values.firstWhere(
      (e) => e.name == value,
      orElse: () => Gender.undisclosed,
    );
  }
}

/// Quality rating for activities
enum Quality {
  good,
  normal,
  bad;

  static Quality? fromString(String? value) {
    if (value == null || value.isEmpty) return null;
    return Quality.values.firstWhere(
      (e) => e.name == value,
      orElse: () => Quality.normal,
    );
  }
}

/// Theme preference options
enum ThemePreference {
  warm,
  calm,
  auto;

  static ThemePreference fromString(String value) {
    return ThemePreference.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ThemePreference.auto,
    );
  }
}

/// Measurement types
enum MeasurementType {
  weight,
  height,
  headCircumference('head_circumference');

  const MeasurementType([this._value]);
  final String? _value;

  String get value => _value ?? name;

  static MeasurementType fromString(String value) {
    return MeasurementType.values.firstWhere(
      (e) => e.value == value || e.name == value,
      orElse: () => MeasurementType.weight,
    );
  }
}

/// Chart period options
enum ChartPeriod {
  oneMonth('1m'),
  threeMonths('3m'),
  sixMonths('6m'),
  oneYear('1y'),
  all('all');

  const ChartPeriod(this.value);
  final String value;

  static ChartPeriod fromString(String value) {
    return ChartPeriod.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ChartPeriod.sixMonths,
    );
  }
}

/// Reminder status options
enum ReminderStatus {
  pending,
  completed,
  cancelled;

  static ReminderStatus fromString(String value) {
    return ReminderStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ReminderStatus.pending,
    );
  }
}

/// OTP request purpose
enum OtpPurpose {
  auth,
  changePhone('change_phone');

  const OtpPurpose([this._value]);
  final String? _value;

  String get value => _value ?? name;
}

/// Preferred locale options
enum PreferredLocale {
  en,
  uz,
  ru;

  static PreferredLocale fromString(String value) {
    return PreferredLocale.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PreferredLocale.en,
    );
  }
}
