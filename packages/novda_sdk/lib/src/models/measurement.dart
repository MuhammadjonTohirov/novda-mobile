import 'package:equatable/equatable.dart';

import 'enums.dart';

/// Measurement model
class Measurement extends Equatable {
  const Measurement({
    required this.id,
    required this.child,
    required this.childName,
    required this.type,
    required this.value,
    required this.unit,
    required this.takenAt,
    this.notes,
    required this.createdAt,
  });

  final int id;
  final int child;
  final String childName;
  final MeasurementType type;
  final double value;
  final String unit;
  final DateTime takenAt;
  final String? notes;
  final DateTime createdAt;

  factory Measurement.fromJson(Map<String, dynamic> json) {
    return Measurement(
      id: json['id'] as int,
      child: json['child'] as int,
      childName: json['child_name'] as String,
      type: MeasurementType.fromString(json['type'] as String),
      value: double.parse(json['value'].toString()),
      unit: json['unit'] as String,
      takenAt: DateTime.parse(json['taken_at'] as String),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  @override
  List<Object?> get props => [
        id,
        child,
        childName,
        type,
        value,
        unit,
        takenAt,
        notes,
        createdAt,
      ];
}

/// Latest measurements of each type
class LatestMeasurements extends Equatable {
  const LatestMeasurements({
    this.weight,
    this.height,
    this.headCircumference,
  });

  final Measurement? weight;
  final Measurement? height;
  final Measurement? headCircumference;

  factory LatestMeasurements.fromJson(Map<String, dynamic> json) {
    return LatestMeasurements(
      weight: json['weight'] != null
          ? Measurement.fromJson(json['weight'] as Map<String, dynamic>)
          : null,
      height: json['height'] != null
          ? Measurement.fromJson(json['height'] as Map<String, dynamic>)
          : null,
      headCircumference: json['head_circumference'] != null
          ? Measurement.fromJson(
              json['head_circumference'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  List<Object?> get props => [weight, height, headCircumference];
}

/// Chart data for measurements
class ChartData extends Equatable {
  const ChartData({
    required this.labels,
    required this.values,
    required this.unit,
    this.min,
    this.max,
    this.average,
  });

  final List<DateTime> labels;
  final List<double> values;
  final String unit;
  final double? min;
  final double? max;
  final double? average;

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      labels: (json['labels'] as List<dynamic>)
          .map((e) => DateTime.parse(e as String))
          .toList(),
      values: (json['values'] as List<dynamic>)
          .map((e) => double.parse(e.toString()))
          .toList(),
      unit: json['unit'] as String,
      min: json['min'] != null ? double.parse(json['min'].toString()) : null,
      max: json['max'] != null ? double.parse(json['max'].toString()) : null,
      average: json['average'] != null
          ? double.parse(json['average'].toString())
          : null,
    );
  }

  @override
  List<Object?> get props => [labels, values, unit, min, max, average];
}

/// Request for creating a measurement
class MeasurementCreateRequest {
  const MeasurementCreateRequest({
    required this.type,
    required this.value,
    required this.takenAt,
    this.notes,
  });

  final MeasurementType type;
  final double value;
  final DateTime takenAt;
  final String? notes;

  Map<String, dynamic> toJson() => {
        'type': type.value,
        'value': value.toString(),
        'taken_at': takenAt.toUtc().toIso8601String(),
        if (notes != null) 'notes': notes,
      };
}

/// Query parameters for measurement list
class MeasurementListQuery {
  const MeasurementListQuery({
    this.type,
    this.from,
    this.to,
    this.limit,
  });

  final MeasurementType? type;
  final DateTime? from;
  final DateTime? to;
  final int? limit;

  Map<String, dynamic> toQueryParams() => {
        if (type != null) 'type': type!.value,
        if (from != null) 'from': from!.toIso8601String(),
        if (to != null) 'to': to!.toIso8601String(),
        if (limit != null) 'limit': limit.toString(),
      };
}

/// Query parameters for chart data
class ChartDataQuery {
  const ChartDataQuery({
    required this.type,
    this.period = ChartPeriod.sixMonths,
  });

  final MeasurementType type;
  final ChartPeriod period;

  Map<String, dynamic> toQueryParams() => {
        'type': type.value,
        'period': period.value,
      };
}
