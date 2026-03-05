import 'package:novda_sdk/novda_sdk.dart';

class BodyMeasurementEntry {
  const BodyMeasurementEntry({required this.takenAt, this.weight, this.height});

  final DateTime takenAt;
  final Measurement? weight;
  final Measurement? height;

  String get entryKey => takenAt.toUtc().toIso8601String();

  bool get hasAnyValue => weight != null || height != null;
}
