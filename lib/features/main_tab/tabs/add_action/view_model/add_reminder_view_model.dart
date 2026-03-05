import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/base/base_view_model.dart';
import '../interactor/add_reminder_interactor.dart';

class AddReminderViewModel extends BaseViewModel with ActionErrorMixin {
  AddReminderViewModel({
    ActivityType? initialActivityType,
    DateTime? initialDueAt,
    AddReminderInteractor? interactor,
  }) : _initialActivityType = initialActivityType,
       _initialDueAt = initialDueAt,
       _interactor = interactor ?? AddReminderInteractor();

  final ActivityType? _initialActivityType;
  final DateTime? _initialDueAt;
  final AddReminderInteractor _interactor;

  int? _childId;
  DateTime? _dueAt;
  String _comments = '';
  List<ActivityType> _activityTypes = const [];
  int? _selectedActivityTypeId;
  bool _isSubmitting = false;
  bool _isReady = false;
  Reminder? _createdReminder;

  int? get childId => _childId;
  DateTime? get dueAt => _dueAt;
  String get comments => _comments;
  List<ActivityType> get activityTypes => _activityTypes;
  int? get selectedActivityTypeId => _selectedActivityTypeId;
  bool get isSubmitting => _isSubmitting;
  bool get isReady => _isReady;
  Reminder? get createdReminder => _createdReminder;

  bool get hasChild => _childId != null;
  bool get hasActivityTypes => _activityTypes.isNotEmpty;

  ActivityType? get selectedActivityType {
    final id = _selectedActivityTypeId;
    if (id == null) return null;

    for (final type in _activityTypes) {
      if (type.id == id) return type;
    }

    return null;
  }

  bool get canSubmit {
    if (_isSubmitting) return false;
    if (!hasChild) return false;
    if (_dueAt == null) return false;
    if (selectedActivityType == null) return false;
    return true;
  }

  Future<void> load() async {
    setLoading();

    try {
      _childId = await _interactor.resolveActiveChildId();
      _activityTypes = (await _interactor.loadActivityTypes())
          .where((type) => type.isReminderEnabled)
          .toList(growable: false);
      _selectedActivityTypeId = _resolveInitialTypeId();
      _dueAt ??= _initialDueAt?.toLocal();
      _isReady = true;
      setSuccess();
    } catch (error) {
      _isReady = true;
      handleException(error);
    }
  }

  void setDueAt(DateTime value) {
    _dueAt = value;
    notifyListeners();
  }

  void setComments(String value) {
    _comments = value;
    notifyListeners();
  }

  void selectActivityType(int activityTypeId) {
    var exists = false;
    for (final type in _activityTypes) {
      if (type.id == activityTypeId) {
        exists = true;
        break;
      }
    }
    if (!exists) return;

    if (_selectedActivityTypeId == activityTypeId) return;
    _selectedActivityTypeId = activityTypeId;
    notifyListeners();
  }

  Future<bool> submit() async {
    if (!canSubmit) return false;

    final childId = _childId;
    final dueAt = _dueAt;
    final activityType = selectedActivityType;

    if (childId == null || dueAt == null || activityType == null) return false;

    _isSubmitting = true;
    notifyListeners();

    try {
      final note = _comments.trim();

      _createdReminder = await _interactor.createReminder(
        childId: childId,
        activityTypeId: activityType.id,
        dueAt: dueAt,
        note: note.isEmpty ? null : note,
      );

      return true;
    } catch (error) {
      setActionError(error);
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  int? _resolveInitialTypeId() {
    final preferredId = _initialActivityType?.id;
    if (preferredId == null) return null;

    for (final type in _activityTypes) {
      if (type.id == preferredId) return preferredId;
    }

    return null;
  }

}
