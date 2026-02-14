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
  int? _selectedActivityTypeId;

  AddActionType get actionType => _actionType;
  List<ActivityType> get activityTypes => _activityTypes;
  int? get selectedActivityTypeId => _selectedActivityTypeId;

  ActivityType? get selectedActivityType {
    final id = _selectedActivityTypeId;
    if (id == null) return null;

    for (final type in _activityTypes) {
      if (type.id == id) return type;
    }

    return null;
  }

  bool get hasTypes => _activityTypes.isNotEmpty;

  Future<void> load() async {
    setLoading();

    try {
      _activityTypes = await _interactor.loadActivityTypes();
      _selectedActivityTypeId = _activityTypes.isEmpty
          ? null
          : _activityTypes.first.id;
      setSuccess();
    } catch (error) {
      handleException(error);
    }
  }

  void selectActionType(AddActionType type) {
    if (_actionType == type) return;
    _actionType = type;
    notifyListeners();
  }

  void selectActivityType(int activityTypeId) {
    if (_selectedActivityTypeId == activityTypeId) return;
    _selectedActivityTypeId = activityTypeId;
    notifyListeners();
  }

  AddActionSheetSelection? currentSelection() {
    final type = selectedActivityType;
    if (type == null) return null;

    return AddActionSheetSelection(actionType: _actionType, activityType: type);
  }
}
