import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/base/base_view_model.dart';
import '../interactor/progress_tab_interactor.dart';

class ProgressTabViewModel extends BaseViewModel with ActionErrorMixin {
  ProgressTabViewModel({ProgressTabInteractor? interactor})
    : _interactor = interactor ?? ProgressTabInteractor();

  final ProgressTabInteractor _interactor;

  ProgressTabChildContext? _activeChild;
  List<ProgressPeriod> _periods = const [];
  ProgressPeriod? _actualPeriod;
  ProgressPeriod? _selectedPeriod;
  ProgressGuide? _guide;
  List<ProgressContentItem> _suggestions = const [];
  List<ProgressContentItem> _recommendedArticles = const [];
  bool _isInitialLoading = false;
  bool _needsScrollToSelected = false;
  bool _isDetailLoading = false;
  bool _isSharedContentLoading = false;
  bool _isSuggestionsLoading = false;
  bool _isRecommendationsLoading = false;

  ProgressTabChildContext? get activeChild => _activeChild;
  DateTime? get childBirthDate => _activeChild?.birthDate;
  List<ProgressPeriod> get periods => _periods;
  ProgressPeriod? get selectedPeriod => _selectedPeriod;
  ProgressGuide? get guide => _guide;
  List<ProgressContentItem> get suggestions => _suggestions;
  List<ProgressContentItem> get recommendedArticles => _recommendedArticles;
  bool get isInitialLoading => _isInitialLoading;

  /// Returns `true` once after the selected period changes and the UI
  /// should scroll to it. Calling this consumes the flag.
  bool consumeScrollToSelected() {
    if (!_needsScrollToSelected) return false;
    _needsScrollToSelected = false;
    return true;
  }

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
    _isInitialLoading = true;
    notifyListeners();

    try {
      _activeChild = await _interactor.resolveActiveChild();
      _resetContent();

      final child = _activeChild;
      if (child == null) {
        _isInitialLoading = false;
        setSuccess();
        return;
      }

      final allPeriods = await _interactor.loadAllPeriods();
      final sortedAllPeriods = _interactor.sortPeriods(allPeriods);
      final ageDays = _interactor.ageInDays(child.birthDate);
      _actualPeriod = _interactor.resolveCurrentPeriodByAge(
        periods: sortedAllPeriods,
        ageDays: ageDays,
      );
      _selectedPeriod = _actualPeriod;
      _periods = sortedAllPeriods;
      _needsScrollToSelected = _selectedPeriod != null;
      _isInitialLoading = false;
      setSuccess();

      if (_selectedPeriod != null) {
        try {
          await _loadPeriodSections(
            child: child,
            period: _selectedPeriod!,
            loadSupplementaryContent: true,
          );
        } catch (error) {
          setActionError(error);
        }
      }
    } catch (error) {
      _isInitialLoading = false;
      handleException(error);
    }
  }

  Future<void> selectPeriod(ProgressPeriod period) async {
    final child = _activeChild;
    if (child == null || _isDetailLoading) return;

    if (isSelectedPeriod(period) && _guide != null) return;

    final previousSelectedPeriod = _selectedPeriod;
    final previousGuide = _guide;
    final previousSuggestions = _suggestions;
    final previousRecommendedArticles = _recommendedArticles;
    _selectedPeriod = period;

    try {
      await _loadPeriodSections(
        child: child,
        period: period,
        loadSupplementaryContent: false,
        previousSelectedPeriod: previousSelectedPeriod,
        previousGuide: previousGuide,
        previousSuggestions: previousSuggestions,
        previousRecommendedArticles: previousRecommendedArticles,
      );
    } catch (error) {
      _selectedPeriod = previousSelectedPeriod;
      _guide = previousGuide;
      _suggestions = previousSuggestions;
      _recommendedArticles = previousRecommendedArticles;
      setActionError(error);
    }
  }

  Future<void> _loadPeriodSections({
    required ProgressTabChildContext child,
    required ProgressPeriod period,
    required bool loadSupplementaryContent,
    ProgressPeriod? previousSelectedPeriod,
    ProgressGuide? previousGuide,
    List<ProgressContentItem>? previousSuggestions,
    List<ProgressContentItem>? previousRecommendedArticles,
  }) async {
    _isDetailLoading = true;
    _isSharedContentLoading = true;
    _isSuggestionsLoading = false;
    _isRecommendationsLoading = false;
    _guide = null;
    if (previousSuggestions == null) {
      _suggestions = const [];
    }
    if (previousRecommendedArticles == null) {
      _recommendedArticles = const [];
    }
    notifyListeners();

    try {
      final sharedContent = await _interactor.loadSharedPeriodContent(
        child: child,
        period: period,
      );
      _guide = _interactor.buildGuideFromSharedContent(sharedContent);
      _isSharedContentLoading = false;
      notifyListeners();

      if (loadSupplementaryContent) {
        final supplementaryPeriod = _actualPeriod ?? period;

        _isSuggestionsLoading = true;
        notifyListeners();

        _suggestions = await _interactor.loadPeriodSuggestions(
          child: child,
          period: supplementaryPeriod,
        );
        _isSuggestionsLoading = false;
        _isRecommendationsLoading = true;
        notifyListeners();

        _recommendedArticles = await _interactor.loadRecommendedArticles(
          child: child,
          period: supplementaryPeriod,
        );
        _isRecommendationsLoading = false;
      }
    } catch (error) {
      _selectedPeriod = previousSelectedPeriod ?? _selectedPeriod;
      _guide = previousGuide;
      _suggestions = previousSuggestions ?? const [];
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
    _actualPeriod = null;
    _selectedPeriod = null;
    _guide = null;
    _suggestions = const [];
    _recommendedArticles = const [];
    _isDetailLoading = false;
    _isSharedContentLoading = false;
    _isSuggestionsLoading = false;
    _isRecommendationsLoading = false;
  }
}
