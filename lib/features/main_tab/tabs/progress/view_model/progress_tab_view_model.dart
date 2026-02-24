import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/base/base_view_model.dart';
import '../interactor/progress_tab_interactor.dart';

class ProgressTabViewModel extends BaseViewModel {
  ProgressTabViewModel({ProgressTabInteractor? interactor})
    : _interactor = interactor ?? ProgressTabInteractor();

  final ProgressTabInteractor _interactor;

  ProgressTabChildContext? _activeChild;
  List<ProgressPeriod> _periods = const [];
  ProgressPeriod? _selectedPeriod;
  ProgressGuide? _guide;
  bool _isDetailLoading = false;
  String? _actionErrorMessage;

  ProgressTabChildContext? get activeChild => _activeChild;
  DateTime? get childBirthDate => _activeChild?.birthDate;
  List<ProgressPeriod> get periods => _periods;
  ProgressPeriod? get selectedPeriod => _selectedPeriod;
  ProgressGuide? get guide => _guide;
  bool get isDetailLoading => _isDetailLoading;

  bool get hasChild => _activeChild != null;
  bool get hasContent => hasChild && (_periods.isNotEmpty || _guide != null);

  bool isSelectedPeriod(ProgressPeriod period) {
    final selected = _selectedPeriod;
    if (selected == null) return false;
    return _isSamePeriod(selected, period);
  }

  String? consumeActionError() {
    final error = _actionErrorMessage;
    _actionErrorMessage = null;
    return error;
  }

  Future<void> load() async {
    setLoading();

    try {
      _activeChild = await _interactor.resolveActiveChild();
      _periods = const [];
      _selectedPeriod = null;
      _guide = null;

      final child = _activeChild;
      if (child == null) {
        setSuccess();
        return;
      }

      final allPeriods = await _interactor.loadAllPeriods();
      final sortedAllPeriods = _sortPeriods(allPeriods);
      final ageDays = _interactor.ageInDays(child.birthDate);
      _selectedPeriod = _resolveCurrentPeriodByAge(
        periods: sortedAllPeriods,
        ageDays: ageDays,
      );
      _periods = _windowPeriods(
        periods: sortedAllPeriods,
        selected: _selectedPeriod,
        sideCount: 2,
      );

      if (_selectedPeriod != null) {
        _guide = await _interactor.loadPeriodDetail(
          child: child,
          period: _selectedPeriod!,
        );
      } else {
        _guide = await _interactor.loadCurrentProgress(child: child);
        _selectedPeriod = _periodFromGuide(_guide!);
        if (_selectedPeriod != null) {
          _periods = _windowPeriods(
            periods: _sortPeriods([...sortedAllPeriods, _selectedPeriod!]),
            selected: _selectedPeriod,
            sideCount: 2,
          );
        }
      }

      setSuccess();
    } catch (error) {
      handleException(error);
    }
  }

  Future<void> selectPeriod(ProgressPeriod period) async {
    final child = _activeChild;
    if (child == null || _isDetailLoading) return;

    if (isSelectedPeriod(period) && _guide != null) return;

    final previousGuide = _guide;
    _selectedPeriod = period;
    _isDetailLoading = true;
    notifyListeners();

    try {
      _guide = await _interactor.loadPeriodDetail(child: child, period: period);
    } catch (error) {
      _guide = previousGuide;
      _actionErrorMessage = _errorText(error);
    } finally {
      _isDetailLoading = false;
      notifyListeners();
    }
  }

  ProgressPeriod? _resolveCurrentPeriodByAge({
    required List<ProgressPeriod> periods,
    required int ageDays,
  }) {
    if (periods.isEmpty) return null;

    for (final period in periods) {
      if (period.isCurrent) return period;
    }

    final containing = periods.where((period) {
      final start = period.ageStartDays;
      final end = period.ageEndDays;
      if (start == null || end == null) return false;
      return ageDays >= start && ageDays <= end;
    }).toList();

    if (containing.isNotEmpty) {
      containing.sort((left, right) {
        final unitCompare = _periodUnitPriority(
          left.periodUnit,
        ).compareTo(_periodUnitPriority(right.periodUnit));
        if (unitCompare != 0) return unitCompare;

        final leftRange =
            (left.ageEndDays ?? left.ageStartDays ?? 0) -
            (left.ageStartDays ?? 0);
        final rightRange =
            (right.ageEndDays ?? right.ageStartDays ?? 0) -
            (right.ageStartDays ?? 0);
        if (leftRange != rightRange) return leftRange.compareTo(rightRange);

        return left.periodIndex.compareTo(right.periodIndex);
      });
      return containing.first;
    }

    ProgressPeriod? nearest;
    var nearestDistance = 1 << 30;

    for (final period in periods) {
      final start = period.ageStartDays;
      final end = period.ageEndDays;
      if (start == null && end == null) continue;

      final center =
          ((start ?? end ?? ageDays) + (end ?? start ?? ageDays)) ~/ 2;
      final distance = (center - ageDays).abs();
      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearest = period;
      }
    }

    return nearest ?? periods.first;
  }

  ProgressPeriod? _periodFromGuide(ProgressGuide guide) {
    if (guide.periodIndex <= 0) return null;

    return ProgressPeriod(
      periodUnit: guide.periodUnit,
      periodIndex: guide.periodIndex,
      weekNumber: guide.weekNumber,
      stageType: guide.stageType,
      weekType: guide.weekType,
      crisisWarning: guide.crisisWarning,
      crisisDescription: guide.crisisDescription,
    );
  }

  bool _isSamePeriod(ProgressPeriod left, ProgressPeriod right) {
    return left.periodUnit == right.periodUnit &&
        left.periodIndex == right.periodIndex;
  }

  String _errorText(Object error) {
    if (error is ApiException) return error.message;
    return error.toString();
  }

  List<ProgressPeriod> _sortPeriods(List<ProgressPeriod> periods) {
    final sorted = [...periods];
    sorted.sort((left, right) {
      final unitCompare = _periodUnitPriority(
        left.periodUnit,
      ).compareTo(_periodUnitPriority(right.periodUnit));
      if (unitCompare != 0) return unitCompare;

      final leftStart = left.ageStartDays ?? (left.periodIndex * 1000);
      final rightStart = right.ageStartDays ?? (right.periodIndex * 1000);
      if (leftStart != rightStart) return leftStart.compareTo(rightStart);

      return left.periodIndex.compareTo(right.periodIndex);
    });
    return sorted;
  }

  List<ProgressPeriod> _windowPeriods({
    required List<ProgressPeriod> periods,
    required ProgressPeriod? selected,
    required int sideCount,
  }) {
    if (periods.isEmpty) return const [];
    if (selected == null) {
      return periods.take((sideCount * 2) + 1).toList();
    }

    var scope = periods.where((period) {
      return period.periodUnit == selected.periodUnit;
    }).toList();

    if (scope.length < 3) {
      scope = periods;
    }

    final selectedIndex = scope.indexWhere((period) {
      return _isSamePeriod(period, selected);
    });
    if (selectedIndex < 0) {
      return scope.take((sideCount * 2) + 1).toList();
    }

    final start = (selectedIndex - sideCount).clamp(0, scope.length - 1);
    final end = (selectedIndex + sideCount + 1).clamp(start + 1, scope.length);
    return scope.sublist(start, end);
  }

  int _periodUnitPriority(ProgressPeriodUnit unit) {
    return switch (unit) {
      ProgressPeriodUnit.week => 0,
      ProgressPeriodUnit.month => 1,
      ProgressPeriodUnit.year => 2,
      ProgressPeriodUnit.custom => 3,
      ProgressPeriodUnit.unknown => 4,
    };
  }
}
