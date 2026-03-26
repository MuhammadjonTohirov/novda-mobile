import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:novda_sdk/novda_sdk.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../../core/extensions/extensions.dart';
import '../../../../../../core/theme/app_theme.dart';

class MeasurementLineChart extends StatelessWidget {
  const MeasurementLineChart({
    super.key,
    required this.measurements,
    required this.emptyText,
  });

  final List<Measurement> measurements;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final sorted = [...measurements]
      ..sort((a, b) => a.takenAt.compareTo(b.takenAt));

    if (sorted.isEmpty) {
      return Text(
        emptyText,
        style: AppTypography.bodyMRegular.copyWith(color: colors.textSecondary),
        textAlign: TextAlign.center,
      ).center().container(height: 132);
    }

    final points = sorted
        .map(
          (item) =>
              _MeasurementChartPoint(takenAt: item.takenAt.toLocal(), value: item.value),
        )
        .toList(growable: false);
    final values = points.map((item) => item.value).toList(growable: false);
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final minAxis = _resolveAxisMin(minValue: minValue, maxValue: maxValue);
    final maxAxis = _resolveAxisMax(minValue: minValue, maxValue: maxValue);

    return RepaintBoundary(
      child: SizedBox(
        height: 178,
        child: SfCartesianChart(
        margin: EdgeInsets.zero,
        plotAreaBorderWidth: 0,
        primaryXAxis: DateTimeAxis(
          dateFormat: DateFormat('MMM d'),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          majorGridLines: MajorGridLines(color: colors.border, width: 1),
          majorTickLines: const MajorTickLines(size: 0),
          axisLine: AxisLine(color: colors.border, width: 1),
          labelStyle: AppTypography.bodySRegular.copyWith(
            color: colors.textSecondary,
            fontSize: 11,
          ),
        ),
        primaryYAxis: NumericAxis(
          minimum: minAxis,
          maximum: maxAxis,
          desiredIntervals: 4,
          numberFormat: NumberFormat('0.#'),
          majorGridLines: MajorGridLines(color: colors.border, width: 1),
          majorTickLines: const MajorTickLines(size: 0),
          axisLine: AxisLine(color: colors.border, width: 1),
          labelStyle: AppTypography.bodySRegular.copyWith(
            color: colors.textSecondary,
            fontSize: 11,
          ),
        ),
        series: [
          AreaSeries<_MeasurementChartPoint, DateTime>(
            dataSource: points,
            xValueMapper: (item, _) => item.takenAt,
            yValueMapper: (item, _) => item.value,
            color: colors.accent.withValues(alpha: 0.14),
            borderWidth: 0,
            animationDuration: 800,
          ),
          LineSeries<_MeasurementChartPoint, DateTime>(
            dataSource: points,
            xValueMapper: (item, _) => item.takenAt,
            yValueMapper: (item, _) => item.value,
            color: colors.accent,
            width: 2.2,
            animationDuration: 800,
            markerSettings: MarkerSettings(
              isVisible: true,
              width: 7,
              height: 7,
              color: colors.accent,
              borderColor: colors.bgPrimary,
              borderWidth: 2,
            ),
          ),
        ],
      ),
      ),
    );
  }

  double _resolveAxisMin({required double minValue, required double maxValue}) {
    if ((maxValue - minValue).abs() < 0.0001) {
      final delta = math.max(0.5, maxValue.abs() * 0.12);
      return math.max(0.0, minValue - delta);
    }

    final padding = (maxValue - minValue) * 0.12;
    return math.max(0.0, minValue - padding);
  }

  double _resolveAxisMax({required double minValue, required double maxValue}) {
    if ((maxValue - minValue).abs() < 0.0001) {
      final delta = math.max(0.5, maxValue.abs() * 0.12);
      return maxValue + delta;
    }

    final padding = (maxValue - minValue) * 0.12;
    return maxValue + padding;
  }
}

class _MeasurementChartPoint {
  const _MeasurementChartPoint({required this.takenAt, required this.value});

  final DateTime takenAt;
  final double value;
}
