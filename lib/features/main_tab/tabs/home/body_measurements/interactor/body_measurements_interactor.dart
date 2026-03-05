import 'package:novda/core/services/services.dart';
import 'package:novda_sdk/novda_sdk.dart';

class BodyMeasurementsInteractor {
  BodyMeasurementsInteractor({MeasurementsUseCase? measurementsUseCase})
    : _measurementsUseCase = measurementsUseCase ?? services.sdk.measurements;

  final MeasurementsUseCase _measurementsUseCase;

  Future<List<Measurement>> loadMeasurements(int childId) async {
    final measurements = await _measurementsUseCase.getMeasurements(
      childId,
      limit: 300,
    );

    final supported =
        measurements
            .where(
              (item) =>
                  item.type == MeasurementType.weight ||
                  item.type == MeasurementType.height,
            )
            .toList()
          ..sort((a, b) => b.takenAt.compareTo(a.takenAt));

    return supported;
  }

  Future<Measurement> createMeasurement({
    required int childId,
    required MeasurementType type,
    required double value,
    required DateTime takenAt,
  }) {
    return _measurementsUseCase.createMeasurement(
      childId,
      type: type,
      value: value,
      takenAt: takenAt,
    );
  }

  Future<Measurement> updateMeasurement({
    required int measurementId,
    required double value,
    DateTime? takenAt,
  }) {
    return _measurementsUseCase.updateMeasurement(
      measurementId,
      value: value,
      takenAt: takenAt,
    );
  }

  Future<void> deleteMeasurement(int measurementId) {
    return _measurementsUseCase.deleteMeasurement(measurementId);
  }
}
