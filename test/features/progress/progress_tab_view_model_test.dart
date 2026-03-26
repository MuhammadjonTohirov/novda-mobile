import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novda/features/main_tab/tabs/progress/interactor/progress_tab_interactor.dart';
import 'package:novda/features/main_tab/tabs/progress/view_model/progress_tab_view_model.dart';
import 'package:novda_core/novda_core.dart';
import 'package:novda_sdk/novda_sdk.dart';

class MockProgressTabInteractor extends Mock implements ProgressTabInteractor {}

void main() {
  late MockProgressTabInteractor mockInteractor;
  late ProgressTabViewModel viewModel;

  final child = ProgressTabChildContext(
    id: 5,
    name: 'Jasmin',
    ageDisplay: '3 months 2 weeks',
    birthDate: DateTime(2025, 12, 1),
    gender: Gender.girl,
  );

  const period10 = ProgressPeriod(
    periodUnit: ProgressPeriodUnit.week,
    periodIndex: 10,
    weekNumber: 10,
  );
  const period11 = ProgressPeriod(
    periodUnit: ProgressPeriodUnit.week,
    periodIndex: 11,
    weekNumber: 11,
  );

  final sharedContent10 = ProgressSharedPeriodContent(
    guide: ProgressGuide(
      periodUnit: ProgressPeriodUnit.week,
      periodIndex: 10,
      weekNumber: 10,
      stageType: 'normal',
      weekType: 'normal',
      headline: 'Week 10',
      summary: 'Shared summary',
      exercises: const [
        ProgressContentItem(
          data: {'id': 11, 'title': 'Exercise 10'},
          title: 'Exercise 10',
        ),
      ],
      suggestions: const [],
      recommendations: const [],
    ),
    exercises: const [
      ProgressContentItem(
        data: {'id': 11, 'title': 'Exercise 10'},
        title: 'Exercise 10',
      ),
    ],
  );
  final guideWithoutSuggestions10 = ProgressGuide(
    periodUnit: ProgressPeriodUnit.week,
    periodIndex: 10,
    weekNumber: 10,
    stageType: 'normal',
    weekType: 'normal',
    headline: 'Week 10',
    summary: 'Shared summary',
    exercises: const [
      ProgressContentItem(
        data: {'id': 11, 'title': 'Exercise 10'},
        title: 'Exercise 10',
      ),
    ],
    suggestions: const [],
    recommendations: const [],
  );
  const suggestions10 = [
    ProgressContentItem(
      data: {'id': 12, 'title': 'Suggestion 10'},
      title: 'Suggestion 10',
    ),
  ];

  final initialGuide = ProgressGuide(
    periodUnit: ProgressPeriodUnit.week,
    periodIndex: 10,
    weekNumber: 10,
    stageType: 'normal',
    weekType: 'normal',
    headline: 'Week 10',
    summary: 'Initial summary',
    exercises: const [
      ProgressContentItem(
        data: {'id': 1, 'title': 'Exercise 1'},
        title: 'Exercise 1',
      ),
    ],
    suggestions: const [
      ProgressContentItem(
        data: {'id': 2, 'title': 'Suggestion 1'},
        title: 'Suggestion 1',
      ),
    ],
    recommendations: const [],
  );

  final initialRecommendations = [
    const ProgressContentItem(
      data: {'slug': 'article-1', 'title': 'Article 1'},
      title: 'Article 1',
    ),
  ];
  final sharedContent11 = ProgressSharedPeriodContent(
    guide: ProgressGuide(
      periodUnit: ProgressPeriodUnit.week,
      periodIndex: 11,
      weekNumber: 11,
      stageType: 'normal',
      weekType: 'normal',
      headline: 'Week 11',
      summary: 'Week 11 shared summary',
      exercises: const [
        ProgressContentItem(
          data: {'id': 21, 'title': 'Exercise 11'},
          title: 'Exercise 11',
        ),
      ],
      suggestions: const [],
      recommendations: const [],
    ),
    exercises: const [
      ProgressContentItem(
        data: {'id': 21, 'title': 'Exercise 11'},
        title: 'Exercise 11',
      ),
    ],
  );
  final guideWithoutSuggestions11 = ProgressGuide(
    periodUnit: ProgressPeriodUnit.week,
    periodIndex: 11,
    weekNumber: 11,
    stageType: 'normal',
    weekType: 'normal',
    headline: 'Week 11',
    summary: 'Week 11 shared summary',
    exercises: const [
      ProgressContentItem(
        data: {'id': 21, 'title': 'Exercise 11'},
        title: 'Exercise 11',
      ),
    ],
    suggestions: const [],
    recommendations: const [],
  );

  setUpAll(() {
    registerFallbackValue(
      const ProgressPeriod(periodUnit: ProgressPeriodUnit.week, periodIndex: 1),
    );
  });

  setUp(() {
    mockInteractor = MockProgressTabInteractor();
    viewModel = ProgressTabViewModel(interactor: mockInteractor);
  });

  tearDown(() => viewModel.dispose());

  group('load', () {
    test(
      'shows periods first and then loads each section progressively',
      () async {
        final allPeriods = <ProgressPeriod>[period10, period11];
        final sharedContentCompleter = Completer<ProgressSharedPeriodContent>();
        final suggestionsCompleter = Completer<List<ProgressContentItem>>();
        final recommendationsCompleter = Completer<List<ProgressContentItem>>();

        when(
          () => mockInteractor.resolveActiveChild(),
        ).thenAnswer((_) async => child);
        when(
          () => mockInteractor.loadAllPeriods(),
        ).thenAnswer((_) async => allPeriods);
        when(
          () => mockInteractor.sortPeriods(allPeriods),
        ).thenReturn(allPeriods);
        when(() => mockInteractor.ageInDays(child.birthDate)).thenReturn(70);
        when(
          () => mockInteractor.resolveCurrentPeriodByAge(
            periods: allPeriods,
            ageDays: 70,
          ),
        ).thenReturn(period10);
        when(
          () => mockInteractor.loadSharedPeriodContent(
            child: child,
            period: period10,
          ),
        ).thenAnswer((_) => sharedContentCompleter.future);
        when(
          () => mockInteractor.buildGuideFromSharedContent(sharedContent10),
        ).thenReturn(guideWithoutSuggestions10);
        when(
          () => mockInteractor.loadPeriodSuggestions(
            child: child,
            period: period10,
          ),
        ).thenAnswer((_) => suggestionsCompleter.future);
        when(
          () => mockInteractor.applySuggestionsToGuide(
            guide: guideWithoutSuggestions10,
            suggestions: suggestions10,
          ),
        ).thenReturn(initialGuide);
        when(
          () => mockInteractor.loadRecommendedArticles(
            child: child,
            period: period10,
          ),
        ).thenAnswer((_) => recommendationsCompleter.future);

        final loadFuture = viewModel.load();

        await untilCalled(
          () => mockInteractor.loadSharedPeriodContent(
            child: child,
            period: period10,
          ),
        );

        expect(viewModel.state, ViewState.success);
        expect(viewModel.periods, equals(allPeriods));
        expect(viewModel.selectedPeriod, equals(period10));
        expect(viewModel.guide, isNull);
        expect(viewModel.isSharedContentLoading, isTrue);
        expect(viewModel.isSuggestionsLoading, isFalse);
        expect(viewModel.isRecommendationsLoading, isFalse);

        sharedContentCompleter.complete(sharedContent10);
        await untilCalled(
          () => mockInteractor.loadPeriodSuggestions(
            child: child,
            period: period10,
          ),
        );

        expect(viewModel.guide, equals(guideWithoutSuggestions10));
        expect(viewModel.isSharedContentLoading, isFalse);
        expect(viewModel.isSuggestionsLoading, isTrue);
        expect(viewModel.isRecommendationsLoading, isFalse);

        suggestionsCompleter.complete(suggestions10);
        await untilCalled(
          () => mockInteractor.loadRecommendedArticles(
            child: child,
            period: period10,
          ),
        );

        expect(viewModel.guide, equals(initialGuide));
        expect(viewModel.isSuggestionsLoading, isFalse);
        expect(viewModel.isRecommendationsLoading, isTrue);

        recommendationsCompleter.complete(initialRecommendations);
        await loadFuture;

        expect(viewModel.recommendedArticles, equals(initialRecommendations));
        expect(viewModel.isRecommendationsLoading, isFalse);
      },
    );

    test(
      'sets success with null guide when no selected period can be resolved',
      () async {
        final emptyPeriods = <ProgressPeriod>[];

        when(
          () => mockInteractor.resolveActiveChild(),
        ).thenAnswer((_) async => child);
        when(
          () => mockInteractor.loadAllPeriods(),
        ).thenAnswer((_) async => emptyPeriods);
        when(
          () => mockInteractor.sortPeriods(emptyPeriods),
        ).thenReturn(emptyPeriods);
        when(() => mockInteractor.ageInDays(child.birthDate)).thenReturn(100);
        when(
          () => mockInteractor.resolveCurrentPeriodByAge(
            periods: emptyPeriods,
            ageDays: 100,
          ),
        ).thenReturn(null);

        await viewModel.load();

        expect(viewModel.state, ViewState.success);
        expect(viewModel.guide, isNull);
        expect(viewModel.selectedPeriod, isNull);
        expect(viewModel.periods, isEmpty);
        expect(viewModel.recommendedArticles, isEmpty);
        expect(viewModel.isSharedContentLoading, isFalse);
        expect(viewModel.isSuggestionsLoading, isFalse);
        expect(viewModel.isRecommendationsLoading, isFalse);
      },
    );
  });

  group('selectPeriod', () {
    test(
      'restores previous guide and recommendations when detail loading fails',
      () async {
        final allPeriods = <ProgressPeriod>[period10, period11];

        when(
          () => mockInteractor.resolveActiveChild(),
        ).thenAnswer((_) async => child);
        when(
          () => mockInteractor.loadAllPeriods(),
        ).thenAnswer((_) async => allPeriods);
        when(
          () => mockInteractor.sortPeriods(allPeriods),
        ).thenReturn(allPeriods);
        when(() => mockInteractor.ageInDays(child.birthDate)).thenReturn(70);
        when(
          () => mockInteractor.resolveCurrentPeriodByAge(
            periods: allPeriods,
            ageDays: 70,
          ),
        ).thenReturn(period10);
        when(
          () => mockInteractor.loadSharedPeriodContent(
            child: child,
            period: period10,
          ),
        ).thenAnswer((_) async => sharedContent10);
        when(
          () => mockInteractor.buildGuideFromSharedContent(sharedContent10),
        ).thenReturn(guideWithoutSuggestions10);
        when(
          () => mockInteractor.loadPeriodSuggestions(
            child: child,
            period: period10,
          ),
        ).thenAnswer((_) async => suggestions10);
        when(
          () => mockInteractor.applySuggestionsToGuide(
            guide: guideWithoutSuggestions10,
            suggestions: suggestions10,
          ),
        ).thenReturn(initialGuide);
        when(
          () => mockInteractor.loadRecommendedArticles(
            child: child,
            period: period10,
          ),
        ).thenAnswer((_) async => initialRecommendations);
        when(
          () => mockInteractor.isSamePeriod(period10, period11),
        ).thenReturn(false);
        when(
          () => mockInteractor.loadSharedPeriodContent(
            child: child,
            period: period11,
          ),
        ).thenAnswer((_) async => sharedContent11);
        when(
          () => mockInteractor.buildGuideFromSharedContent(sharedContent11),
        ).thenReturn(guideWithoutSuggestions11);
        when(
          () => mockInteractor.loadPeriodSuggestions(
            child: child,
            period: period11,
          ),
        ).thenThrow(
          const ServerException(message: 'Period load failed', statusCode: 502),
        );

        await viewModel.load();
        await viewModel.selectPeriod(period11);

        expect(viewModel.periods, equals(allPeriods));
        expect(viewModel.selectedPeriod, equals(period10));
        expect(viewModel.guide, equals(initialGuide));
        expect(viewModel.recommendedArticles, equals(initialRecommendations));
        expect(viewModel.consumeActionError(), 'Period load failed');
        expect(viewModel.state, ViewState.success);
      },
    );
  });
}
