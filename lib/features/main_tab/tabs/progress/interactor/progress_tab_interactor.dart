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

  ProgressPeriod? resolveCurrentPeriodByAge({
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

  ProgressPeriod? periodFromGuide(ProgressGuide guide) {
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

  bool isSamePeriod(ProgressPeriod left, ProgressPeriod right) {
    return left.periodUnit == right.periodUnit &&
        left.periodIndex == right.periodIndex;
  }

  List<ProgressPeriod> sortPeriods(List<ProgressPeriod> periods) {
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

  List<ProgressPeriod> windowPeriods({
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
      return isSamePeriod(period, selected);
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
