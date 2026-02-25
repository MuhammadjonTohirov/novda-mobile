import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../../core/base/base_view_model.dart';
import '../interactor/article_screen_interactor.dart';

class ArticleScreenViewModel extends BaseViewModel {
  ArticleScreenViewModel({
    required this.preview,
    ArticleScreenInteractor? interactor,
  }) : _interactor = interactor ?? ArticleScreenInteractor(),
       _isSaved = preview.isSaved,
       _viewCount = preview.viewCount;

  final ArticleListItem preview;
  final ArticleScreenInteractor _interactor;

  ArticleDetail? _detail;
  bool _isSaved;
  int _viewCount;
  bool _isBookmarkUpdating = false;
  String? _actionErrorMessage;

  bool get hasDetail => _detail != null;
  bool get isSaved => _isSaved;
  bool get isBookmarkUpdating => _isBookmarkUpdating;

  String get slug => preview.slug;
  String get title => _detail?.title ?? preview.title;
  String get heroImageUrl => _detail?.heroImageUrl ?? preview.heroImageUrl;
  int get readingTime => _detail?.readingTime ?? preview.readingTime;
  int get viewCount => _detail?.viewCount ?? _viewCount;
  String get bodyHtml => _detail?.body ?? '';

  String? consumeActionError() {
    final message = _actionErrorMessage;
    _actionErrorMessage = null;
    return message;
  }

  Future<void> load() async {
    setLoading();

    try {
      final detail = await _interactor.loadArticle(slug);
      _detail = detail;
      _isSaved = detail.isSaved;
      _viewCount = detail.viewCount;
      setSuccess();
    } catch (error) {
      handleException(error);
    }
  }

  Future<void> toggleSaved() async {
    if (_isBookmarkUpdating) return;

    _isBookmarkUpdating = true;
    notifyListeners();

    try {
      if (_isSaved) {
        await _interactor.unsaveArticle(slug);
        _isSaved = false;
      } else {
        await _interactor.saveArticle(slug);
        _isSaved = true;
      }
    } catch (error) {
      _actionErrorMessage = _errorText(error);
    } finally {
      _isBookmarkUpdating = false;
      notifyListeners();
    }
  }

  String _errorText(Object error) {
    if (error is ApiException) return error.message;
    return error.toString();
  }
}
