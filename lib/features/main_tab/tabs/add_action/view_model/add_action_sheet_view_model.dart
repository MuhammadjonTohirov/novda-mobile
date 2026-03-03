import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/base/base_view_model.dart';
import '../interactor/add_action_sheet_interactor.dart';

enum AddActionType { activity, reminder }

class AddActionSheetSelection {
  const AddActionSheetSelection({
    required this.actionType,
    required this.activityType,
  });

  final AddActionType actionType;
  final ActivityType activityType;
}

class AddActionSheetViewModel extends BaseViewModel {
  AddActionSheetViewModel({AddActionSheetInteractor? interactor})
    : _interactor = interactor ?? AddActionSheetInteractor();

  final AddActionSheetInteractor _interactor;

  AddActionType _actionType = AddActionType.activity;
  List<ActivityType> _activityTypes = const [];
  List<ActivityType> _reminderActivityTypes = const [];
  int? _selectedActivityTypeId;

  AddActionType get actionType => _actionType;
  List<ActivityType> get activityTypes => _activityTypes;
  List<ActivityType> get reminderActivityTypes => _reminderActivityTypes;
  List<ActivityType> get currentActivityTypes =>
      _actionType == AddActionType.activity
      ? _activityTypes
      : _reminderActivityTypes;
  int? get selectedActivityTypeId => _selectedActivityTypeId;

  ActivityType? get selectedActivityType {
    final id = _selectedActivityTypeId;
    if (id == null) return null;

    for (final type in currentActivityTypes) {
      if (type.id == id) return type;
    }

    return null;
  }

  bool get hasTypes => currentActivityTypes.isNotEmpty;

  Future<void> load() async {
    setLoading();

    try {
      _activityTypes = await _interactor.loadActivityTypes();
      _reminderActivityTypes = _activityTypes
          .where((type) => type.isReminderEnabled)
          .toList(growable: false);
      _ensureSelectedActivityType();
      setSuccess();
    } catch (error) {
      handleException(error);
    }
  }

  void selectActionType(AddActionType type) {
    if (_actionType == type) return;
    _actionType = type;
    _ensureSelectedActivityType();
    notifyListeners();
  }

  void selectActivityType(int activityTypeId) {
    var exists = false;
    for (final type in currentActivityTypes) {
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

  AddActionSheetSelection? currentSelection() {
    final type = selectedActivityType;
    if (type == null) return null;

    return AddActionSheetSelection(actionType: _actionType, activityType: type);
  }

  void _ensureSelectedActivityType() {
    final selectedId = _selectedActivityTypeId;
    if (selectedId != null) {
      for (final type in currentActivityTypes) {
        if (type.id == selectedId) return;
      }
    }

    _selectedActivityTypeId = currentActivityTypes.isEmpty
        ? null
        : currentActivityTypes.first.id;
  }
}
