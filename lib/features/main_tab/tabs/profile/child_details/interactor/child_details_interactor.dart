import 'package:novda/core/services/services.dart';
import 'package:novda_sdk/novda_sdk.dart';

class ChildDetailsInteractor {
  ChildDetailsInteractor({
    ChildrenUseCase? childrenUseCase,
    MeasurementsUseCase? measurementsUseCase,
  }) : _childrenUseCase = childrenUseCase ?? services.sdk.children,
       _measurementsUseCase = measurementsUseCase ?? services.sdk.measurements;

  final ChildrenUseCase _childrenUseCase;
  final MeasurementsUseCase _measurementsUseCase;

  Future<Child> loadChild(int childId) {
    return _childrenUseCase.getChild(childId);
  }

  Future<Child> createChild({
    required String name,
    required Gender gender,
    required DateTime birthDate,
  }) {
    return _childrenUseCase.createChild(
      name: name,
      gender: gender,
      birthDate: birthDate,
    );
  }

  Future<Child> updateChild({
    required int childId,
    required String name,
    required Gender gender,
    required DateTime birthDate,
  }) {
    return _childrenUseCase.updateChild(
      childId,
      name: name,
      gender: gender,
      birthDate: birthDate,
    );
  }

  Future<void> selectChild(int childId) {
    return _childrenUseCase.selectChild(childId);
  }

  Future<void> createMeasurements({
    required int childId,
    required DateTime takenAt,
    double? weightKg,
    double? heightCm,
  }) async {
    final tasks = <Future<void>>[];

    if (weightKg != null) {
      tasks.add(
        _measurementsUseCase
            .createMeasurement(
              childId,
              type: MeasurementType.weight,
              value: weightKg,
              takenAt: takenAt,
            )
            .then((_) {}),
      );
    }

    if (heightCm != null) {
      tasks.add(
        _measurementsUseCase
            .createMeasurement(
              childId,
              type: MeasurementType.height,
              value: heightCm,
              takenAt: takenAt,
            )
            .then((_) {}),
      );
    }

    if (tasks.isEmpty) return;
    await Future.wait(tasks);
  }

}
