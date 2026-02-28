/// Date comparison helpers on [DateTime].
extension DateTimeComparisonExtension on DateTime {
  /// Whether this date falls on the same calendar day as [other].
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Whether this date is today (local time).
  bool get isToday => isSameDate(DateTime.now());

  /// Whether this date is tomorrow (local time).
  bool get isTomorrow =>
      isSameDate(DateTime.now().add(const Duration(days: 1)));
}
