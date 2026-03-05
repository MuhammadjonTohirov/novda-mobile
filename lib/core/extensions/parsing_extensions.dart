extension DateParsing on DateTime {
  static DateTime? tryParseBirthDate({
    required String day,
    required String month,
    required String year,
  }) {
    final d = int.tryParse(day.trim());
    final m = int.tryParse(month.trim());
    final y = int.tryParse(year.trim());

    if (d == null || m == null || y == null) return null;
    if (y < 1900 || y > DateTime.now().year) return null;
    if (m < 1 || m > 12) return null;
    if (d < 1 || d > 31) return null;

    final date = DateTime(y, m, d);
    if (date.year != y || date.month != m || date.day != d) return null;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (date.isAfter(today)) return null;

    return date;
  }
}

extension MetricParsing on String {
  double? toMetricValue({required double max}) {
    final normalized = trim().replaceAll(',', '.');
    if (normalized.isEmpty) return null;

    final value = double.tryParse(normalized);
    if (value == null || value <= 0 || value > max) return null;

    return value;
  }
}

extension MetricFormatting on double {
  String toMetricString() {
    final fixed = toStringAsFixed(2);
    return fixed.replaceFirst(RegExp(r'\.?0+$'), '');
  }
}
