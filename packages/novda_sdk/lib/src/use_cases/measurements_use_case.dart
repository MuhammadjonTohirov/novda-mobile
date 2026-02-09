import '../gateways/measurements_gateway.dart';
import '../models/enums.dart';
import '../models/measurement.dart';

/// Use case interface for measurement operations
abstract interface class MeasurementsUseCase {
  /// Get measurements for a child with optional filters
  Future<List<Measurement>> getMeasurements(
    int childId, {
    MeasurementType? type,
    DateTime? from,
    DateTime? to,
    int? limit,
  });

  /// Get latest measurements of each type for a child
  Future<LatestMeasurements> getLatestMeasurements(int childId);

  /// Get chart data for measurements
  Future<ChartData> getChartData(
    int childId, {
    required MeasurementType type,
    ChartPeriod period,
  });

  /// Create a new measurement for a child
  Future<Measurement> createMeasurement(
    int childId, {
    required MeasurementType type,
    required double value,
    required DateTime takenAt,
    String? notes,
  });

  /// Delete a measurement
  Future<void> deleteMeasurement(int measurementId);
}

/// Implementation of MeasurementsUseCase
class MeasurementsUseCaseImpl implements MeasurementsUseCase {
  MeasurementsUseCaseImpl(this._gateway);

  final MeasurementsGateway _gateway;

  @override
  Future<List<Measurement>> getMeasurements(
    int childId, {
    MeasurementType? type,
    DateTime? from,
    DateTime? to,
    int? limit,
  }) {
    return _gateway.getMeasurements(
      childId,
      MeasurementListQuery(type: type, from: from, to: to, limit: limit),
    );
  }

  @override
  Future<LatestMeasurements> getLatestMeasurements(int childId) {
    return _gateway.getLatestMeasurements(childId);
  }

  @override
  Future<ChartData> getChartData(
    int childId, {
    required MeasurementType type,
    ChartPeriod period = ChartPeriod.sixMonths,
  }) {
    return _gateway.getChartData(
      childId,
      ChartDataQuery(type: type, period: period),
    );
  }

  @override
  Future<Measurement> createMeasurement(
    int childId, {
    required MeasurementType type,
    required double value,
    required DateTime takenAt,
    String? notes,
  }) {
    return _gateway.createMeasurement(
      childId,
      MeasurementCreateRequest(
        type: type,
        value: value,
        takenAt: takenAt,
        notes: notes,
      ),
    );
  }

  @override
  Future<void> deleteMeasurement(int measurementId) {
    return _gateway.deleteMeasurement(measurementId);
  }
}
