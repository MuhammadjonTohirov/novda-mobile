import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/services/services.dart';

class ProgressTabChildContext {
  const ProgressTabChildContext({
    required this.id,
    required this.name,
    required this.ageDisplay,
    required this.birthDate,
    required this.gender,
  });

  final int id;
  final String name;
  final String ageDisplay;
  final DateTime birthDate;
  final Gender gender;
}

class ProgressTabInteractor {
  ProgressTabInteractor({
    UserUseCase? userUseCase,
    ChildrenUseCase? childrenUseCase,
    ProgressUseCase? progressUseCase,
    ArticlesV2UseCase? articlesV2UseCase,
  }) : _userUseCase = userUseCase ?? services.sdk.user,
       _childrenUseCase = childrenUseCase ?? services.sdk.children,
       _progressUseCase = progressUseCase ?? services.sdk.progress,
       _articlesV2UseCase = articlesV2UseCase ?? services.sdk.articlesV2;

  final UserUseCase _userUseCase;
  final ChildrenUseCase _childrenUseCase;
  final ProgressUseCase _progressUseCase;
  final ArticlesV2UseCase _articlesV2UseCase;

  Future<ProgressTabChildContext?> resolveActiveChild() async {
    final results = await Future.wait([
      _userUseCase.getProfile(),
      _childrenUseCase.getChildren(),
    ]);

    final user = results[0] as User;
    final children = results[1] as List<ChildListItem>;
    if (children.isEmpty) return null;

    final activeChild = _resolveActiveChild(
      children: children,
      activeChildId: user.lastActiveChild,
    );

    return ProgressTabChildContext(
      id: activeChild.id,
      name: activeChild.name,
      ageDisplay: activeChild.ageDisplay,
      birthDate: activeChild.birthDate,
      gender: activeChild.gender,
    );
  }

  Future<List<ProgressPeriod>> loadAllPeriods() async {
    final result = await _progressUseCase.getAllPeriods();
    return result.periods;
  }

  Future<ProgressGuide> loadPeriodDetail({
    required ProgressTabChildContext child,
    required ProgressPeriod period,
  }) {
    if (period.periodUnit == ProgressPeriodUnit.unknown) {
      return loadCurrentProgress(child: child);
    }

    return _progressUseCase.getPeriodDetail(
      periodUnit: period.periodUnit,
      periodIndex: period.periodIndex,
    );
  }

  Future<ProgressGuide> loadCurrentProgress({
    required ProgressTabChildContext child,
  }) {
    return _progressUseCase.getCurrentProgress(
      ageDays: ageInDays(child.birthDate),
    );
  }

  Future<List<ProgressContentItem>> loadRecommendedArticles({
    required ProgressTabChildContext child,
    required ProgressPeriod period,
  }) async {
    if (period.periodIndex <= 0) return const [];

    final progressType = _resolveProgressType(period.periodUnit);
    if (progressType == null) return const [];

    try {
      final articles = await _articlesV2UseCase.getRecommendedArticles(
        childId: child.id,
        progressIndex: period.periodIndex,
        progressType: progressType,
      );

      return articles
          .map(_toProgressRecommendationItem)
          .toList(growable: false);
    } on ApiException {
      return const [];
    } on FormatException {
      return const [];
    }
  }

  ChildListItem _resolveActiveChild({
    required List<ChildListItem> children,
    required int? activeChildId,
  }) {
    if (activeChildId == null) return children.first;

    for (final child in children) {
      if (child.id == activeChildId) return child;
    }

    return children.first;
  }

  int ageInDays(DateTime birthDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final birth = DateTime(birthDate.year, birthDate.month, birthDate.day);
    final days = today.difference(birth).inDays;
    return days < 0 ? 0 : days;
  }

  String? _resolveProgressType(ProgressPeriodUnit unit) {
    return switch (unit) {
      ProgressPeriodUnit.week => 'week',
      ProgressPeriodUnit.month => 'month',
      ProgressPeriodUnit.custom => 'custom',
      ProgressPeriodUnit.year => null,
      ProgressPeriodUnit.unknown => null,
    };
  }

  ProgressContentItem _toProgressRecommendationItem(ArticleListItem article) {
    final data = <String, dynamic>{
      'slug': article.slug,
      'title': article.title,
      'description': article.excerpt,
      if (article.heroImageUrl.isNotEmpty) 'image_url': article.heroImageUrl,
      if (article.heroImageUrl.isNotEmpty)
        'thumbnail_url': article.heroImageUrl,
      if (article.readingTime > 0) 'reading_time': article.readingTime,
      if (article.viewCount > 0) 'view_count': article.viewCount,
      if (article.publishAt != null)
        'publish_at': article.publishAt!.toIso8601String(),
    };

    return ProgressContentItem(
      data: data,
      title: article.title,
      description: article.excerpt,
    );
  }
}
