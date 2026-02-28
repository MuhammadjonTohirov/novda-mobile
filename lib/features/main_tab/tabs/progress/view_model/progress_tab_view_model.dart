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
  List<ProgressContentItem> _recommendedArticles = const [];
  bool _isDetailLoading = false;
  String? _actionErrorMessage;

  ProgressTabChildContext? get activeChild => _activeChild;
  DateTime? get childBirthDate => _activeChild?.birthDate;
  List<ProgressPeriod> get periods => _periods;
  ProgressPeriod? get selectedPeriod => _selectedPeriod;
  ProgressGuide? get guide => _guide;
  List<ProgressContentItem> get recommendedArticles => _recommendedArticles;
  bool get isDetailLoading => _isDetailLoading;

  bool get hasChild => _activeChild != null;
  bool get hasContent => hasChild && (_periods.isNotEmpty || _guide != null);

  bool isSelectedPeriod(ProgressPeriod period) {
    final selected = _selectedPeriod;
    if (selected == null) return false;
    return _interactor.isSamePeriod(selected, period);
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
      _recommendedArticles = const [];

      final child = _activeChild;
      if (child == null) {
        setSuccess();
        return;
      }

      final allPeriods = await _interactor.loadAllPeriods();
      final sortedAllPeriods = _interactor.sortPeriods(allPeriods);
      final ageDays = _interactor.ageInDays(child.birthDate);
      _selectedPeriod = _interactor.resolveCurrentPeriodByAge(
        periods: sortedAllPeriods,
        ageDays: ageDays,
      );
      _periods = _interactor.windowPeriods(
        periods: sortedAllPeriods,
        selected: _selectedPeriod,
        sideCount: 2,
      );

      if (_selectedPeriod != null) {
        final selectedPeriod = _selectedPeriod!;
        final guideFuture = _interactor.loadPeriodDetail(
          child: child,
          period: selectedPeriod,
        );
        final recommendedFuture = _interactor.loadRecommendedArticles(
          child: child,
          period: selectedPeriod,
        );
        _guide = await guideFuture;
        _recommendedArticles = await recommendedFuture;
      } else {
        _guide = await _interactor.loadCurrentProgress(child: child);
        _selectedPeriod = _interactor.periodFromGuide(_guide!);
        if (_selectedPeriod != null) {
          final selectedPeriod = _selectedPeriod!;
          _periods = _interactor.windowPeriods(
            periods: _interactor.sortPeriods([...sortedAllPeriods, selectedPeriod]),
            selected: _selectedPeriod,
            sideCount: 2,
          );
          _recommendedArticles = await _interactor.loadRecommendedArticles(
            child: child,
            period: selectedPeriod,
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
    final previousRecommendedArticles = _recommendedArticles;
    _selectedPeriod = period;
    _isDetailLoading = true;
    notifyListeners();

    try {
      final guideFuture = _interactor.loadPeriodDetail(
        child: child,
        period: period,
      );
      final recommendedFuture = _interactor.loadRecommendedArticles(
        child: child,
        period: period,
      );
      _guide = await guideFuture;
      _recommendedArticles = await recommendedFuture;
    } catch (error) {
      _guide = previousGuide;
      _recommendedArticles = previousRecommendedArticles;
      _actionErrorMessage = _errorText(error);
    } finally {
      _isDetailLoading = false;
      notifyListeners();
    }
  }

  String _errorText(Object error) {
    if (error is ApiException) return error.message;
    return error.toString();
  }
}
