import 'package:flutter_test/flutter_test.dart';
import 'package:novda/core/extensions/parsing_extensions.dart';

void main() {
  group('DateParsing.tryParseBirthDate', () {
    test('parses valid date', () {
      final result = DateParsing.tryParseBirthDate(
        day: '15',
        month: '6',
        year: '2023',
      );

      expect(result, DateTime(2023, 6, 15));
    });

    test('returns null for non-numeric input', () {
      expect(
        DateParsing.tryParseBirthDate(day: 'x', month: '1', year: '2023'),
        isNull,
      );
    });

    test('returns null for year before 1900', () {
      expect(
        DateParsing.tryParseBirthDate(day: '1', month: '1', year: '1800'),
        isNull,
      );
    });

    test('returns null for future date', () {
      expect(
        DateParsing.tryParseBirthDate(day: '1', month: '1', year: '2099'),
        isNull,
      );
    });

    test('returns null for invalid day like Feb 30', () {
      expect(
        DateParsing.tryParseBirthDate(day: '30', month: '2', year: '2024'),
        isNull,
      );
    });

    test('handles whitespace in inputs', () {
      final result = DateParsing.tryParseBirthDate(
        day: ' 5 ',
        month: ' 3 ',
        year: ' 2023 ',
      );

      expect(result, DateTime(2023, 3, 5));
    });

    test('returns null for month out of range', () {
      expect(
        DateParsing.tryParseBirthDate(day: '1', month: '13', year: '2023'),
        isNull,
      );
    });
  });

  group('MetricParsing.toMetricValue', () {
    test('parses valid decimal string', () {
      expect('3.5'.toMetricValue(max: 200), 3.5);
    });

    test('handles comma as decimal separator', () {
      expect('3,5'.toMetricValue(max: 200), 3.5);
    });

    test('returns null for empty string', () {
      expect(''.toMetricValue(max: 200), isNull);
    });

    test('returns null for zero', () {
      expect('0'.toMetricValue(max: 200), isNull);
    });

    test('returns null for negative value', () {
      expect('-5'.toMetricValue(max: 200), isNull);
    });

    test('returns null for value exceeding max', () {
      expect('201'.toMetricValue(max: 200), isNull);
    });

    test('returns value at exact max', () {
      expect('200'.toMetricValue(max: 200), 200.0);
    });

    test('handles whitespace', () {
      expect(' 3.5 '.toMetricValue(max: 200), 3.5);
    });

    test('returns null for non-numeric string', () {
      expect('abc'.toMetricValue(max: 200), isNull);
    });
  });

  group('MetricFormatting.toMetricString', () {
    test('formats whole number without trailing zeros', () {
      expect(3.0.toMetricString(), '3');
    });

    test('formats decimal with trailing zeros removed', () {
      expect(3.50.toMetricString(), '3.5');
    });

    test('formats two decimal places', () {
      expect(3.14.toMetricString(), '3.14');
    });

    test('rounds to two decimal places', () {
      expect(3.146.toMetricString(), '3.15');
    });
  });
}
