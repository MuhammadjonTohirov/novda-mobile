import 'package:novda/core/base/base_view_model.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../interactor/body_measurements_interactor.dart';
import '../models/body_measurement_entry.dart';

class BodyMeasurementsViewModel extends BaseViewModel with ActionErrorMixin {
  BodyMeasurementsViewModel({
    required this.childId,
    BodyMeasurementsInteractor? interactor,
  }) : _interactor = interactor ?? BodyMeasurementsInteractor();

  final int childId;
  final BodyMeasurementsInteractor _interactor;

  List<Measurement> _measurements = const [];
  final Set<String> _mutatingEntryKeys = <String>{};

  // Cached computed properties - invalidated on _measurements change
  List<Measurement>? _cachedWeight;
  List<Measurement>? _cachedHeight;
  List<BodyMeasurementEntry>? _cachedEntries;

  bool get hasMeasurements => _measurements.isNotEmpty;

  List<Measurement> get weightMeasurements =>
      _cachedWeight ??= _typeMeasurements(MeasurementType.weight);

  List<Measurement> get heightMeasurements =>
      _cachedHeight ??= _typeMeasurements(MeasurementType.height);

  List<BodyMeasurementEntry> get entries =>
      _cachedEntries ??= _buildEntries();

  bool isMutatingEntry(String entryKey) =>
      _mutatingEntryKeys.contains(entryKey);

  Future<void> load() async {
    final hadContent = hasMeasurements;
    setLoading();

    try {
      await _reloadMeasurements();
      setSuccess();
    } catch (error) {
      if (hadContent) {
        setActionError(error);
        setSuccess();
      } else {
        handleException(error);
      }
    }
  }

  Future<void> refresh() {
    return load();
  }

  Future<bool> saveEntry({
    required BodyMeasurementEntry entry,
    double? weightValue,
    double? heightValue,
  }) {
    if (weightValue == null && heightValue == null) {
      return Future.value(false);
    }

    return _runEntryMutation(
      entry: entry,
      action: () async {
        await _saveTypeMeasurement(
          type: MeasurementType.weight,
          current: entry.weight,
          value: weightValue,
          takenAt: entry.takenAt,
        );
        await _saveTypeMeasurement(
          type: MeasurementType.height,
          current: entry.height,
          value: heightValue,
          takenAt: entry.takenAt,
        );

        await _reloadMeasurements();
        setSuccess();
      },
    );
  }

  Future<bool> deleteEntry(BodyMeasurementEntry entry) {
    return _runEntryMutation(
      entry: entry,
      action: () async {
        final tasks = <Future<void>>[];

        if (entry.weight != null) {
          tasks.add(_interactor.deleteMeasurement(entry.weight!.id));
        }
        if (entry.height != null) {
          tasks.add(_interactor.deleteMeasurement(entry.height!.id));
        }

        if (tasks.isEmpty) return;

        await Future.wait(tasks);
        await _reloadMeasurements();
        setSuccess();
      },
    );
  }

  List<Measurement> _typeMeasurements(MeasurementType type) {
    final values = _measurements.where((item) => item.type == type).toList()
      ..sort((a, b) => a.takenAt.compareTo(b.takenAt));
    return values;
  }

  List<BodyMeasurementEntry> _buildEntries() {
    final takenAtByKey = <String, DateTime>{};
    final weightByKey = <String, Measurement>{};
    final heightByKey = <String, Measurement>{};

    for (final measurement in _measurements) {
      final key = measurement.takenAt.toUtc().toIso8601String();
      takenAtByKey.putIfAbsent(key, () => measurement.takenAt);

      switch (measurement.type) {
        case MeasurementType.weight:
          final current = weightByKey[key];
          if (_isNewer(candidate: measurement, current: current)) {
            weightByKey[key] = measurement;
          }
          break;
        case MeasurementType.height:
          final current = heightByKey[key];
          if (_isNewer(candidate: measurement, current: current)) {
            heightByKey[key] = measurement;
          }
          break;
        case MeasurementType.headCircumference:
          break;
      }
    }

    final keys = takenAtByKey.keys.toList()
      ..sort((a, b) => takenAtByKey[b]!.compareTo(takenAtByKey[a]!));

    return keys
        .map(
          (key) => BodyMeasurementEntry(
            takenAt: takenAtByKey[key]!,
            weight: weightByKey[key],
            height: heightByKey[key],
          ),
        )
        .where((entry) => entry.hasAnyValue)
        .toList();
  }

  bool _isNewer({
    required Measurement candidate,
    required Measurement? current,
  }) {
    if (current == null) return true;
    return candidate.createdAt.isAfter(current.createdAt);
  }

  Future<void> _saveTypeMeasurement({
    required MeasurementType type,
    required Measurement? current,
    required double? value,
    required DateTime takenAt,
  }) async {
    if (value == null) {
      if (current != null) {
        await _interactor.deleteMeasurement(current.id);
      }
      return;
    }

    if (current == null) {
      await _interactor.createMeasurement(
        childId: childId,
        type: type,
        value: value,
        takenAt: takenAt,
      );
      return;
    }

    final unchanged = (current.value - value).abs() <= 0.0001;
    if (unchanged) return;

    await _interactor.updateMeasurement(
      measurementId: current.id,
      value: value,
      takenAt: takenAt,
    );
  }

  Future<void> _reloadMeasurements() async {
    _measurements = await _interactor.loadMeasurements(childId);
    _invalidateCache();
  }

  void _invalidateCache() {
    _cachedWeight = null;
    _cachedHeight = null;
    _cachedEntries = null;
  }

  Future<bool> _runEntryMutation({
    required BodyMeasurementEntry entry,
    required Future<void> Function() action,
  }) async {
    final key = entry.entryKey;
    if (_mutatingEntryKeys.contains(key)) return false;

    _mutatingEntryKeys.add(key);
    notifyListeners();

    try {
      await action();
      return true;
    } catch (error) {
      setActionError(error);
      return false;
    } finally {
      _mutatingEntryKeys.remove(key);
      notifyListeners();
    }
  }

}
