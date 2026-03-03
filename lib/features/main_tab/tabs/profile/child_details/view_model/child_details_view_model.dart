import 'package:flutter/material.dart';
import 'package:novda/core/app/app.dart';
import 'package:novda/core/base/base_view_model.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../interactor/child_details_interactor.dart';

class ChildDetailsViewModel extends BaseViewModel {
  ChildDetailsViewModel({this.childId, ChildDetailsInteractor? interactor})
    : _interactor = interactor ?? ChildDetailsInteractor() {
    _nameController.addListener(_onFormChanged);
    _dayController.addListener(_onFormChanged);
    _monthController.addListener(_onFormChanged);
    _yearController.addListener(_onFormChanged);
    _weightController.addListener(_onFormChanged);
    _heightController.addListener(_onFormChanged);
  }

  final int? childId;
  final ChildDetailsInteractor _interactor;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  Gender? _selectedGender;
  bool _hasLoadedForm = false;
  bool _isSaving = false;
  String? _actionErrorMessage;
  String _initialName = '';
  double? _initialWeight;
  double? _initialHeight;
  ThemeVariant? _resolvedThemeVariant;

  TextEditingController get nameController => _nameController;
  TextEditingController get dayController => _dayController;
  TextEditingController get monthController => _monthController;
  TextEditingController get yearController => _yearController;
  TextEditingController get weightController => _weightController;
  TextEditingController get heightController => _heightController;

  Gender? get selectedGender => _selectedGender;
  bool get hasLoadedForm => _hasLoadedForm;
  bool get isSaving => _isSaving;
  bool get isEditMode => childId != null;
  ThemeVariant? get resolvedThemeVariant => _resolvedThemeVariant;

  bool get _isBirthDateInputComplete =>
      _dayController.text.trim().isNotEmpty &&
      _monthController.text.trim().isNotEmpty &&
      _yearController.text.trim().isNotEmpty;

  DateTime? get birthDate => _parseBirthDate();
  double? get weightValue => _parseMetric(_weightController.text, max: 200);
  double? get heightValue => _parseMetric(_heightController.text, max: 250);

  bool get hasBirthDateError => _isBirthDateInputComplete && birthDate == null;
  bool get hasWeightError =>
      _weightController.text.trim().isNotEmpty && weightValue == null;
  bool get hasHeightError =>
      _heightController.text.trim().isNotEmpty && heightValue == null;

  bool get hasChanges {
    if (!isEditMode) return true;
    if (_nameController.text.trim() != _initialName) return true;
    if (_isMetricChanged(current: weightValue, initial: _initialWeight)) {
      return true;
    }
    if (_isMetricChanged(current: heightValue, initial: _initialHeight)) {
      return true;
    }
    return false;
  }

  bool get canSubmit {
    if (_isSaving) return false;
    if (_nameController.text.trim().isEmpty) return false;
    if (_selectedGender == null) return false;
    if (birthDate == null) return false;
    if (weightValue == null) return false;
    if (heightValue == null) return false;
    if (isEditMode && !hasChanges) return false;
    return true;
  }

  String? consumeActionError() {
    final message = _actionErrorMessage;
    _actionErrorMessage = null;
    return message;
  }

  Future<void> load() async {
    setLoading();

    try {
      if (isEditMode) {
        await _loadExistingChild(childId!);
      } else {
        _applyDefaults();
      }

      _hasLoadedForm = true;
      setSuccess();
    } catch (error) {
      handleException(error);
    }
  }

  void setGender(Gender gender) {
    if (_selectedGender == gender) return;
    _selectedGender = gender;
    notifyListeners();
  }

  void setWeightInput(String value) {
    _weightController.text = value;
  }

  void setHeightInput(String value) {
    _heightController.text = value;
  }

  Future<bool> save() async {
    if (!canSubmit) return false;

    final selectedGender = _selectedGender;
    final selectedBirthDate = birthDate;
    final selectedWeight = weightValue;
    final selectedHeight = heightValue;

    if (selectedGender == null ||
        selectedBirthDate == null ||
        selectedWeight == null ||
        selectedHeight == null) {
      return false;
    }

    _isSaving = true;
    notifyListeners();

    try {
      final childName = _nameController.text.trim();

      final child = isEditMode
          ? await _interactor.updateChild(
              childId: childId!,
              name: childName,
              gender: selectedGender,
              birthDate: selectedBirthDate,
            )
          : await _interactor.createChild(
              name: childName,
              gender: selectedGender,
              birthDate: selectedBirthDate,
            );

      if (!isEditMode) {
        await _interactor.selectChild(child.id);
      }

      await _persistMeasurementsIfNeeded(
        childId: child.id,
        takenAt: selectedBirthDate,
        weight: selectedWeight,
        height: selectedHeight,
      );

      _resolvedThemeVariant = await _interactor.resolveThemeVariant(
        selectedChildId: child.id,
      );

      return true;
    } catch (error) {
      _actionErrorMessage = _errorText(error);
      notifyListeners();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<void> _loadExistingChild(int childId) async {
    final child = await _interactor.loadChild(childId);

    _nameController.text = child.name;
    _initialName = child.name.trim();
    _dayController.text = child.birthDate.day.toString();
    _monthController.text = child.birthDate.month.toString();
    _yearController.text = child.birthDate.year.toString();

    final latestMeasurements = child.latestMeasurements;
    final weight = latestMeasurements?.weight?.value;
    final height = latestMeasurements?.height?.value;

    _weightController.text = _formatMetric(weight);
    _heightController.text = _formatMetric(height);

    _initialWeight = weight;
    _initialHeight = height;

    _selectedGender = switch (child.gender) {
      Gender.boy => Gender.boy,
      Gender.girl => Gender.girl,
      _ => null,
    };
  }

  void _applyDefaults() {
    final now = DateTime.now();

    _nameController.clear();
    _initialName = '';
    _dayController.text = now.day.toString();
    _monthController.text = now.month.toString();
    _yearController.text = now.year.toString();
    _weightController.clear();
    _heightController.clear();

    _selectedGender = null;
    _initialWeight = null;
    _initialHeight = null;
  }

  Future<void> _persistMeasurementsIfNeeded({
    required int childId,
    required DateTime takenAt,
    required double weight,
    required double height,
  }) async {
    final shouldSaveWeight =
        !isEditMode ||
        _initialWeight == null ||
        (weight - _initialWeight!).abs() > 0.0001;
    final shouldSaveHeight =
        !isEditMode ||
        _initialHeight == null ||
        (height - _initialHeight!).abs() > 0.0001;

    await _interactor.createMeasurements(
      childId: childId,
      takenAt: takenAt,
      weightKg: shouldSaveWeight ? weight : null,
      heightCm: shouldSaveHeight ? height : null,
    );

    _initialWeight = weight;
    _initialHeight = height;
  }

  DateTime? _parseBirthDate() {
    final day = int.tryParse(_dayController.text.trim());
    final month = int.tryParse(_monthController.text.trim());
    final year = int.tryParse(_yearController.text.trim());

    if (day == null || month == null || year == null) return null;
    if (year < 1900 || year > DateTime.now().year) return null;
    if (month < 1 || month > 12) return null;
    if (day < 1 || day > 31) return null;

    final date = DateTime(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (date.isAfter(today)) return null;

    return date;
  }

  double? _parseMetric(String input, {required double max}) {
    final normalized = input.trim().replaceAll(',', '.');
    if (normalized.isEmpty) return null;

    final value = double.tryParse(normalized);
    if (value == null || value <= 0 || value > max) return null;

    return value;
  }

  String _formatMetric(double? value) {
    if (value == null) return '';

    final fixed = value.toStringAsFixed(2);
    return fixed.replaceFirst(RegExp(r'\.?0+$'), '');
  }

  String _errorText(Object error) {
    if (error is ApiException) return error.message;
    return error.toString();
  }

  bool _isMetricChanged({required double? current, required double? initial}) {
    if (current == null || initial == null) return current != initial;
    return (current - initial).abs() > 0.0001;
  }

  void _onFormChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _nameController.removeListener(_onFormChanged);
    _dayController.removeListener(_onFormChanged);
    _monthController.removeListener(_onFormChanged);
    _yearController.removeListener(_onFormChanged);
    _weightController.removeListener(_onFormChanged);
    _heightController.removeListener(_onFormChanged);

    _nameController.dispose();
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _weightController.dispose();
    _heightController.dispose();

    super.dispose();
  }
}
