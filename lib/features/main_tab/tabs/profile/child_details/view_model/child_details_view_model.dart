import 'package:flutter/material.dart';
import 'package:novda/core/app/app.dart';
import 'package:novda/core/base/base_view_model.dart';
import 'package:novda/core/services/services.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../interactor/child_details_interactor.dart';
import '../models/child_form_state.dart';
import 'child_form_controller.dart';

class ChildDetailsViewModel extends BaseViewModel with ActionErrorMixin {
  ChildDetailsViewModel({this.childId, ChildDetailsInteractor? interactor})
    : _interactor = interactor ?? ChildDetailsInteractor() {
    _form = ChildFormController(onChanged: notifyListeners);
  }

  final int? childId;
  final ChildDetailsInteractor _interactor;
  late final ChildFormController _form;

  bool _hasLoadedForm = false;
  bool _isSaving = false;
  ThemeVariant? _resolvedThemeVariant;

  TextEditingController get nameController => _form.nameController;
  TextEditingController get dayController => _form.dayController;
  TextEditingController get monthController => _form.monthController;
  TextEditingController get yearController => _form.yearController;
  TextEditingController get weightController => _form.weightController;
  TextEditingController get heightController => _form.heightController;

  Gender? get selectedGender => _form.gender;
  bool get hasLoadedForm => _hasLoadedForm;
  bool get isSaving => _isSaving;
  bool get isEditMode => childId != null;
  ThemeVariant? get resolvedThemeVariant => _resolvedThemeVariant;

  ChildFormState get _formState => _form.formState;

  DateTime? get birthDate => _formState.birthDate;
  double? get weightValue => _formState.weightValue;
  double? get heightValue => _formState.heightValue;
  bool get hasBirthDateError => _formState.hasBirthDateError;
  bool get hasWeightError => _formState.hasWeightError;
  bool get hasHeightError => _formState.hasHeightError;

  bool get canSubmit {
    if (_isSaving) return false;
    if (!_formState.isComplete) return false;
    if (isEditMode && !_form.hasChanges(isEditMode: true)) return false;
    return true;
  }

  Future<void> load() async {
    setLoading();

    try {
      if (isEditMode) {
        final child = await _interactor.loadChild(childId!);
        _form.applyChild(child);
      } else {
        _form.applyDefaults();
      }

      _hasLoadedForm = true;
      setSuccess();
    } catch (error) {
      handleException(error);
    }
  }

  void setGender(Gender gender) => _form.setGender(gender);

  void setWeightInput(String value) {
    _form.weightController.text = value;
  }

  void setHeightInput(String value) {
    _form.heightController.text = value;
  }

  Future<bool> save() async {
    if (!canSubmit) return false;

    final selectedGender = _form.gender;
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
      final childName = _form.nameController.text.trim();

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
        takenAt: DateTime.now(),
        weight: selectedWeight,
        height: selectedHeight,
      );

      _resolvedThemeVariant = await services.resolveThemeVariant(
        selectedChildId: child.id,
      );

      return true;
    } catch (error) {
      setActionError(error);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<void> _persistMeasurementsIfNeeded({
    required int childId,
    required DateTime takenAt,
    required double weight,
    required double height,
  }) async {
    final hasWeightChanged = _form.shouldSaveWeight(weight);
    final hasHeightChanged = _form.shouldSaveHeight(height);
    final shouldSave = !isEditMode || hasWeightChanged || hasHeightChanged;

    if (!shouldSave) return;

    await _interactor.createMeasurements(
      childId: childId,
      takenAt: takenAt,
      weightKg: weight,
      heightCm: height,
    );

    _form.updateInitialMeasurements(weight: weight, height: height);
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }
}
