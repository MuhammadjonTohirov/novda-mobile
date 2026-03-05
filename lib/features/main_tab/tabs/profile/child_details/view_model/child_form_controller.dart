import 'package:flutter/material.dart';
import 'package:novda/core/extensions/parsing_extensions.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../models/child_form_state.dart';

class ChildFormController {
  ChildFormController({VoidCallback? onChanged}) : _onChanged = onChanged {
    nameController.addListener(_notify);
    dayController.addListener(_notify);
    monthController.addListener(_notify);
    yearController.addListener(_notify);
    weightController.addListener(_notify);
    heightController.addListener(_notify);
  }

  final VoidCallback? _onChanged;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController dayController = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  Gender? _gender;
  String _initialName = '';
  double? _initialWeight;
  double? _initialHeight;

  Gender? get gender => _gender;

  ChildFormState get formState => ChildFormState(
        name: nameController.text,
        day: dayController.text,
        month: monthController.text,
        year: yearController.text,
        weight: weightController.text,
        height: heightController.text,
        gender: _gender,
      );

  bool hasChanges({required bool isEditMode}) {
    if (!isEditMode) return true;
    if (nameController.text.trim() != _initialName) return true;
    if (_isMetricChanged(current: formState.weightValue, initial: _initialWeight)) return true;
    if (_isMetricChanged(current: formState.heightValue, initial: _initialHeight)) return true;
    return false;
  }

  void setGender(Gender gender) {
    if (_gender == gender) return;
    _gender = gender;
    _notify();
  }

  void applyChild(Child child) {
    nameController.text = child.name;
    _initialName = child.name.trim();
    dayController.text = child.birthDate.day.toString();
    monthController.text = child.birthDate.month.toString();
    yearController.text = child.birthDate.year.toString();

    final measurements = child.latestMeasurements;
    final weight = measurements?.weight?.value;
    final height = measurements?.height?.value;

    weightController.text = weight?.toMetricString() ?? '';
    heightController.text = height?.toMetricString() ?? '';

    _initialWeight = weight;
    _initialHeight = height;

    _gender = switch (child.gender) {
      Gender.boy => Gender.boy,
      Gender.girl => Gender.girl,
      _ => null,
    };
  }

  void applyDefaults() {
    final now = DateTime.now();

    nameController.clear();
    _initialName = '';
    dayController.text = now.day.toString();
    monthController.text = now.month.toString();
    yearController.text = now.year.toString();
    weightController.clear();
    heightController.clear();

    _gender = null;
    _initialWeight = null;
    _initialHeight = null;
  }

  void updateInitialMeasurements({
    required double weight,
    required double height,
  }) {
    _initialWeight = weight;
    _initialHeight = height;
  }

  bool shouldSaveWeight(double weight) =>
      _initialWeight == null || (weight - _initialWeight!).abs() > 0.0001;

  bool shouldSaveHeight(double height) =>
      _initialHeight == null || (height - _initialHeight!).abs() > 0.0001;

  void _notify() => _onChanged?.call();

  bool _isMetricChanged({required double? current, required double? initial}) {
    if (current == null || initial == null) return current != initial;
    return (current - initial).abs() > 0.0001;
  }

  void dispose() {
    nameController.removeListener(_notify);
    dayController.removeListener(_notify);
    monthController.removeListener(_notify);
    yearController.removeListener(_notify);
    weightController.removeListener(_notify);
    heightController.removeListener(_notify);

    nameController.dispose();
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
    weightController.dispose();
    heightController.dispose();
  }
}
