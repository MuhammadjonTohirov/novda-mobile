import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/base/base_view_model.dart';
import '../interactor/progress_tab_interactor.dart';

class ProgressTabViewModel extends BaseViewModel with ActionErrorMixin {
  ProgressTabViewModel({ProgressTabInteractor? interactor})
    : _interactor = interactor ?? ProgressTabInteractor();

  final ProgressTabInteractor _interactor;

  ProgressTabChildContext? _activeChild;
  List<ProgressPeriod> _periods = const [];
  ProgressPeriod? _selectedPeriod;
  ProgressGuide? _guide;
  List<ProgressContentItem> _recommendedArticles = const [];
  bool _isDetailLoading = false;
  bool _isSharedContentLoading = false;
  bool _isSuggestionsLoading = false;
  bool _isRecommendationsLoading = false;

  ProgressTabChildContext? get activeChild => _activeChild;
  DateTime? get childBirthDate => _activeChild?.birthDate;
  List<ProgressPeriod> get periods => _periods;
  ProgressPeriod? get selectedPeriod => _selectedPeriod;
  ProgressGuide? get guide => _guide;
  List<ProgressContentItem> get recommendedArticles => _recommendedArticles;
  bool get isDetailLoading => _isDetailLoading;
  bool get isSharedContentLoading => _isSharedContentLoading;
  bool get isSuggestionsLoading => _isSuggestionsLoading;
  bool get isRecommendationsLoading => _isRecommendationsLoading;

  bool get hasChild => _activeChild != null;
  bool get hasContent => hasChild && (_periods.isNotEmpty || _guide != null);

  bool isSelectedPeriod(ProgressPeriod period) {
    final selected = _selectedPeriod;
    if (selected == null) return false;
    return _interactor.isSamePeriod(selected, period);
  }

  Future<void> load() async {
    setLoading();

    try {
      _activeChild = await _interactor.resolveActiveChild();
      _resetContent();

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
      _periods = sortedAllPeriods;
      setSuccess();

      if (_selectedPeriod != null) {
        try {
          await _loadPeriodSections(child: child, period: _selectedPeriod!);
        } catch (error) {
          setActionError(error);
        }
      }
    } catch (error) {
      handleException(error);
    }
  }

  Future<void> selectPeriod(ProgressPeriod period) async {
    final child = _activeChild;
    if (child == null || _isDetailLoading) return;

    if (isSelectedPeriod(period) && _guide != null) return;

    final previousSelectedPeriod = _selectedPeriod;
    final previousGuide = _guide;
    final previousRecommendedArticles = _recommendedArticles;
    _selectedPeriod = period;

    try {
      await _loadPeriodSections(
        child: child,
        period: period,
        previousSelectedPeriod: previousSelectedPeriod,
        previousGuide: previousGuide,
        previousRecommendedArticles: previousRecommendedArticles,
      );
    } catch (error) {
      _selectedPeriod = previousSelectedPeriod;
      _guide = previousGuide;
      _recommendedArticles = previousRecommendedArticles;
      setActionError(error);
    }
  }

  Future<void> _loadPeriodSections({
    required ProgressTabChildContext child,
    required ProgressPeriod period,
    ProgressPeriod? previousSelectedPeriod,
    ProgressGuide? previousGuide,
    List<ProgressContentItem>? previousRecommendedArticles,
  }) async {
    _isDetailLoading = true;
    _isSharedContentLoading = true;
    _isSuggestionsLoading = false;
    _isRecommendationsLoading = false;
    _guide = null;
    _recommendedArticles = const [];
    notifyListeners();

    try {
      final sharedContent = await _interactor.loadSharedPeriodContent(
        child: child,
        period: period,
      );
      _guide = _interactor.buildGuideFromSharedContent(sharedContent);
      _isSharedContentLoading = false;
      _isSuggestionsLoading = true;
      notifyListeners();

      final suggestions = await _interactor.loadPeriodSuggestions(
        child: child,
        period: period,
      );
      _guide = _interactor.applySuggestionsToGuide(
        guide: _guide!,
        suggestions: suggestions,
      );
      _isSuggestionsLoading = false;
      _isRecommendationsLoading = true;
      notifyListeners();

      _recommendedArticles = await _interactor.loadRecommendedArticles(
        child: child,
        period: period,
      );
      _isRecommendationsLoading = false;
    } catch (error) {
      _selectedPeriod = previousSelectedPeriod ?? _selectedPeriod;
      _guide = previousGuide;
      _recommendedArticles = previousRecommendedArticles ?? const [];
      _isSharedContentLoading = false;
      _isSuggestionsLoading = false;
      _isRecommendationsLoading = false;
      rethrow;
    } finally {
      _isDetailLoading = false;
      notifyListeners();
    }
  }

  void _resetContent() {
    _periods = const [];
    _selectedPeriod = null;
    _guide = null;
    _recommendedArticles = const [];
    _isDetailLoading = false;
    _isSharedContentLoading = false;
    _isSuggestionsLoading = false;
    _isRecommendationsLoading = false;
  }
}
