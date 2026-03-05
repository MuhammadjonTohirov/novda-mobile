import 'package:flutter/material.dart';
import 'package:novda/core/base/base_view_model.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../interactor/parent_details_interactor.dart';

class ParentDetailsViewModel extends BaseViewModel with ActionErrorMixin {
  ParentDetailsViewModel({ParentDetailsInteractor? interactor})
    : _interactor = interactor ?? ParentDetailsInteractor() {
    _nameController.addListener(_onFormChanged);
  }

  final ParentDetailsInteractor _interactor;
  final TextEditingController _nameController = TextEditingController();

  User? _currentUser;
  bool _hasLoadedForm = false;
  bool _isSaving = false;

  TextEditingController get nameController => _nameController;
  bool get hasLoadedForm => _hasLoadedForm;
  bool get isSaving => _isSaving;

  String get phone => _currentUser?.phone ?? '-';

  bool get canSubmit {
    if (_isSaving) return false;
    if (_currentUser == null) return false;

    final updatedName = _nameController.text.trim();
    if (updatedName.isEmpty) return false;

    return updatedName != _currentUser!.name.trim();
  }

  Future<void> load() async {
    setLoading();

    try {
      final user = await _interactor.loadUserProfile();
      _currentUser = user;
      _nameController.text = user.name;
      _hasLoadedForm = true;
      setSuccess();
    } catch (error) {
      handleException(error);
    }
  }

  Future<bool> save() async {
    if (!canSubmit) return false;

    final user = _currentUser;
    if (user == null) return false;

    _isSaving = true;
    notifyListeners();

    try {
      final updated = await _interactor.updateParentName(
        currentUser: user,
        name: _nameController.text.trim(),
      );
      _currentUser = updated;
      _nameController.text = updated.name;
      return true;
    } catch (error) {
      setActionError(error);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void _onFormChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _nameController.removeListener(_onFormChanged);
    _nameController.dispose();
    super.dispose();
  }
}
