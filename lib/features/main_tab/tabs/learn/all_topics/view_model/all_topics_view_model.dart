import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../../core/base/base_view_model.dart';
import '../interactor/all_topics_interactor.dart';

class AllTopicsViewModel extends BaseViewModel {
  AllTopicsViewModel({AllTopicsInteractor? interactor})
    : _interactor = interactor ?? AllTopicsInteractor();

  final AllTopicsInteractor _interactor;

  List<Topic> _topics = const [];
  List<ArticleListItem> _articles = const [];

  List<Topic> get topics => _topics;
  bool get hasTopics => _topics.isNotEmpty;

  Future<void> load() async {
    setLoading();

    try {
      final data = await _interactor.loadContent();
      _topics = _sortedTopics(data.topics);
      _articles = data.articles;
      setSuccess();
    } catch (error) {
      handleException(error);
    }
  }

  int topicArticleCount(String topicSlug) {
    var count = 0;

    for (final article in _articles) {
      if (article.topics.any((topic) => topic.slug == topicSlug)) {
        count += 1;
      }
    }

    return count;
  }

  List<Topic> _sortedTopics(List<Topic> source) {
    final sorted = [...source];
    sorted.sort((left, right) {
      final positionDiff = left.position.compareTo(right.position);
      if (positionDiff != 0) return positionDiff;

      return left.title.toLowerCase().compareTo(right.title.toLowerCase());
    });

    return sorted;
  }
}
