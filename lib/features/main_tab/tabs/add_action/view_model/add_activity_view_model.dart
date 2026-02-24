import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/base/base_view_model.dart';
import '../interactor/add_activity_interactor.dart';

enum FeedingType { breast, bottle }

class AddActivityViewModel extends BaseViewModel {
  AddActivityViewModel({
    required ActivityType activityType,
    ActivityItem? initialActivity,
    AddActivityInteractor? interactor,
  }) : _activityType = activityType,
       _initialActivity = initialActivity,
       _interactor = interactor ?? AddActivityInteractor();

  final ActivityType _activityType;
  final ActivityItem? _initialActivity;
  final AddActivityInteractor _interactor;

  int? _childId;
  DateTime? _startDate;
  DateTime? _endDate;
  Quality? _quality;
  String _comments = '';
  FeedingType _feedingType = FeedingType.breast;
  String _bottleAmountInput = '';
  List<Reminder> _pendingReminders = const [];
  final Set<int> _selectedReminderIds = <int>{};
  List<ConditionType> _conditionTypes = const [];
  final Set<String> _selectedConditionSlugs = <String>{};
  bool _isSubmitting = false;
  String? _actionErrorMessage;
  ActivityItem? _createdActivity;

  ActivityType get activityType => _activityType;
  bool get isEditMode => _initialActivity != null;
  int? get childId => _childId;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  Quality? get quality => _quality;
  String get comments => _comments;
  FeedingType get feedingType => _feedingType;
  String get bottleAmountInput => _bottleAmountInput;
  List<Reminder> get pendingReminders => _pendingReminders;
  Set<int> get selectedReminderIds => _selectedReminderIds;
  List<ConditionType> get conditionTypes => _conditionTypes;
  Set<String> get selectedConditionSlugs => _selectedConditionSlugs;
  bool get isSubmitting => _isSubmitting;
  ActivityItem? get createdActivity => _createdActivity;

  bool get hasChild => _childId != null;
  bool get hasDuration => _activityType.hasDuration;
  bool get hasQuality => _activityType.hasQuality;
  bool get isFeedingActivity {
    final slug = _activityType.slug.toLowerCase();
    return slug.contains('feed') || slug.contains('food');
  }

  bool get isIllnessActivity => _activityType.slug.toLowerCase() == 'illness';

  bool get needsBottleAmount =>
      isFeedingActivity && _feedingType == FeedingType.bottle;

  int? get bottleAmountMl => int.tryParse(_bottleAmountInput.trim());

  bool get canSubmit {
    if (_isSubmitting || _startDate == null) return false;
    if (!isEditMode && !hasChild) return false;

    if (hasDuration) {
      final end = _endDate;
      if (end == null || !end.isAfter(_startDate!)) {
        return false;
      }
    }

    if (needsBottleAmount) {
      final amount = bottleAmountMl;
      if (amount == null || amount <= 0) {
        return false;
      }
    }

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
      _pendingReminders = const [];
      _conditionTypes = const [];
      _selectedReminderIds.clear();
      _selectedConditionSlugs.clear();
      _applyInitialActivity();

      _childId = _initialActivity?.child;
      _childId ??= await _interactor.resolveActiveChildId();

      if (_childId != null) {
        final remindersFuture = _interactor.loadPendingReminders(
          _childId!,
          activityTypeId: _activityType.id,
        );

        final conditionTypesFuture = isIllnessActivity
            ? _interactor.loadConditionTypes()
            : Future.value(const <ConditionType>[]);

        final results = await Future.wait([
          remindersFuture,
          conditionTypesFuture,
        ]);

        _pendingReminders = results[0] as List<Reminder>;
        _conditionTypes = results[1] as List<ConditionType>;
      }

      if (_startDate == null) {
        final now = DateTime.now();
        _startDate = now;
        if (hasDuration) {
          _endDate = now.add(const Duration(minutes: 30));
        }
      }

      setSuccess();
    } catch (error) {
      handleException(error);
    }
  }

  void setStartDate(DateTime value) {
    _startDate = value;

    if (hasDuration && _endDate != null && !_endDate!.isAfter(value)) {
      _endDate = value.add(const Duration(minutes: 15));
    }

    notifyListeners();
  }

  void setEndDate(DateTime value) {
    _endDate = value;
    notifyListeners();
  }

  void setQuality(Quality? value) {
    _quality = value;
    notifyListeners();
  }

  void setComments(String value) {
    _comments = value;
    notifyListeners();
  }

  void setFeedingType(FeedingType value) {
    if (_feedingType == value) return;

    _feedingType = value;
    if (_feedingType != FeedingType.bottle) {
      _bottleAmountInput = '';
    }

    notifyListeners();
  }

  void setBottleAmountInput(String value) {
    final numericValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    _bottleAmountInput = numericValue;
    notifyListeners();
  }

  void toggleReminderSelection(int reminderId) {
    if (_selectedReminderIds.contains(reminderId)) {
      _selectedReminderIds.remove(reminderId);
    } else {
      _selectedReminderIds.add(reminderId);
    }

    notifyListeners();
  }

  void toggleConditionSelection(String conditionSlug) {
    if (_selectedConditionSlugs.contains(conditionSlug)) {
      _selectedConditionSlugs.remove(conditionSlug);
    } else {
      _selectedConditionSlugs.add(conditionSlug);
    }

    notifyListeners();
  }

  Future<bool> submit() async {
    if (!canSubmit) return false;

    final childId = _childId;
    final startDate = _startDate;
    if (childId == null || startDate == null) return false;

    _isSubmitting = true;
    notifyListeners();

    try {
      if (isEditMode) {
        _createdActivity = await _interactor.updateActivity(
          activityId: _initialActivity!.id,
          startDate: startDate,
          endDate: hasDuration ? _endDate : null,
          quality: hasQuality ? _quality : null,
          comments: _comments.trim().isEmpty ? null : _comments.trim(),
          metadata: _buildMetadata(),
        );
      } else {
        _createdActivity = await _interactor.createActivity(
          childId: childId,
          activityTypeId: _activityType.id,
          startDate: startDate,
          endDate: hasDuration ? _endDate : null,
          quality: hasQuality ? _quality : null,
          comments: _comments.trim().isEmpty ? null : _comments.trim(),
          metadata: _buildMetadata(),
        );
      }

      if (_selectedReminderIds.isNotEmpty) {
        await _interactor.completeReminders(_selectedReminderIds);
      }

      return true;
    } catch (error) {
      _actionErrorMessage = _errorText(error);
      notifyListeners();
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Map<String, dynamic>? _buildMetadata() {
    final metadata = <String, dynamic>{};

    if (isFeedingActivity) {
      metadata['feeding_type'] = _feedingType.name;
      if (_feedingType == FeedingType.bottle && bottleAmountMl != null) {
        metadata['amount_ml'] = bottleAmountMl;
      }
    }

    if (isIllnessActivity && _selectedConditionSlugs.isNotEmpty) {
      metadata['conditions'] = _selectedConditionSlugs.toList()..sort();
    }

    if (metadata.isEmpty) return null;
    return metadata;
  }

  void _applyInitialActivity() {
    final item = _initialActivity;
    if (item == null) return;

    _startDate = item.startDate.toLocal();
    _endDate = item.endDate?.toLocal();
    _quality = item.quality;
    _comments = item.comments ?? '';

    final metadata = item.metadata ?? const <String, dynamic>{};

    final feedingType = metadata['feeding_type']?.toString().toLowerCase();
    if (feedingType == 'bottle') {
      _feedingType = FeedingType.bottle;
    } else {
      _feedingType = FeedingType.breast;
    }

    final amountMl = metadata['amount_ml'];
    final parsedAmount = int.tryParse('$amountMl');
    _bottleAmountInput = parsedAmount == null ? '' : parsedAmount.toString();

    final conditions = metadata['conditions'];
    if (conditions is List) {
      _selectedConditionSlugs
        ..clear()
        ..addAll(
          conditions
              .whereType<String>()
              .map((value) => value.trim())
              .where((value) => value.isNotEmpty),
        );
    }
  }

  String _errorText(Object error) {
    if (error is ApiException) {
      return error.message;
    }

    return error.toString();
  }
}
