import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novda/core/services/active_child_resolver.dart';
import 'package:novda/features/main_tab/tabs/progress/interactor/progress_tab_interactor.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../helpers/mock_use_cases.dart';

class MockActiveChildResolver extends Mock implements ActiveChildResolver {}

void main() {
  late MockActiveChildResolver mockActiveChildResolver;
  late MockProgressUseCase mockProgressUseCase;
  late MockArticlesV2UseCase mockArticlesV2UseCase;
  late ProgressTabInteractor interactor;

  const week11Period = ProgressPeriod(
    periodUnit: ProgressPeriodUnit.week,
    periodIndex: 11,
    weekNumber: 11,
  );

  final boyChild = ProgressTabChildContext(
    id: 5,
    name: 'Jasmin',
    ageDisplay: '3 months 2 weeks',
    birthDate: DateTime(2025, 12, 1),
    gender: Gender.boy,
  );

  final undisclosedChild = ProgressTabChildContext(
    id: 6,
    name: 'Alex',
    ageDisplay: '4 months',
    birthDate: DateTime(2025, 11, 1),
    gender: Gender.undisclosed,
  );

  final sharedExercises = [
    const ProgressContentItem(
      data: {'id': 101, 'title': 'Gentle touch time'},
      title: 'Gentle touch time',
      description: 'Hold your baby skin-to-skin for a few minutes.',
    ),
  ];
  final childSuggestions = [
    const ProgressContentItem(
      data: {'id': 7, 'title': 'Keep bedtime calm'},
      title: 'Keep bedtime calm',
      description: 'Use a slower, quieter routine before sleep.',
    ),
  ];

  final sharedGuide = ProgressGuide(
    periodUnit: ProgressPeriodUnit.week,
    periodIndex: 11,
    weekNumber: 11,
    stageType: 'normal',
    weekType: 'normal',
    headline: 'What happens in week 11?',
    moodExpression: 'I need calm and closeness.',
    summary: 'Your baby may be more alert this week.',
    crisisWarning: 'A leap can happen around this time.',
    crisisDescription: 'Sleep can get lighter for a short period.',
    exercises: sharedExercises,
    suggestions: const [],
    recommendations: const [],
  );

  final childSuggestionPayload = ProgressChildPeriodSuggestions(
    child: const ProgressSuggestionChild(
      id: 5,
      name: 'Jasmin',
      gender: Gender.boy,
      ageDisplay: '3 months 2 weeks',
    ),
    guide: ProgressGuide(
      periodUnit: ProgressPeriodUnit.week,
      periodIndex: 11,
      weekNumber: 11,
      stageType: 'normal',
      weekType: 'normal',
      exercises: const [],
      suggestions: const [],
      recommendations: const [],
    ),
    suggestions: childSuggestions,
  );

  setUp(() {
    mockActiveChildResolver = MockActiveChildResolver();
    mockProgressUseCase = MockProgressUseCase();
    mockArticlesV2UseCase = MockArticlesV2UseCase();

    interactor = ProgressTabInteractor(
      activeChildResolver: mockActiveChildResolver,
      progressUseCase: mockProgressUseCase,
      articlesV2UseCase: mockArticlesV2UseCase,
    );
  });

  group('loadPeriodDetail', () {
    test(
      'uses both v2 endpoints and merges shared content with child suggestions',
      () async {
        when(
          () => mockProgressUseCase.getSharedPeriodContent(
            periodUnit: ProgressPeriodUnit.week,
            periodIndex: 11,
            gender: ProgressGenderFilter.boy,
          ),
        ).thenAnswer(
          (_) async => ProgressSharedPeriodContent(
            guide: sharedGuide,
            exercises: sharedExercises,
          ),
        );
        when(
          () => mockProgressUseCase.getChildPeriodSuggestions(
            childId: 5,
            periodUnit: ProgressPeriodUnit.week,
            periodIndex: 11,
          ),
        ).thenAnswer((_) async => childSuggestionPayload);

        final result = await interactor.loadPeriodDetail(
          child: boyChild,
          period: week11Period,
        );

        expect(result.periodUnit, ProgressPeriodUnit.week);
        expect(result.periodIndex, 11);
        expect(result.summary, sharedGuide.summary);
        expect(result.exercises, sharedExercises);
        expect(result.suggestions, childSuggestions);
        expect(result.recommendations, isEmpty);

        verifyInOrder([
          () => mockProgressUseCase.getSharedPeriodContent(
            periodUnit: ProgressPeriodUnit.week,
            periodIndex: 11,
            gender: ProgressGenderFilter.boy,
          ),
          () => mockProgressUseCase.getChildPeriodSuggestions(
            childId: 5,
            periodUnit: ProgressPeriodUnit.week,
            periodIndex: 11,
          ),
        ]);
      },
    );

    test(
      'maps undisclosed child gender to all filter for shared v2 content',
      () async {
        when(
          () => mockProgressUseCase.getSharedPeriodContent(
            periodUnit: ProgressPeriodUnit.week,
            periodIndex: 11,
            gender: ProgressGenderFilter.all,
          ),
        ).thenAnswer(
          (_) async => ProgressSharedPeriodContent(
            guide: sharedGuide,
            exercises: sharedExercises,
          ),
        );
        when(
          () => mockProgressUseCase.getChildPeriodSuggestions(
            childId: 6,
            periodUnit: ProgressPeriodUnit.week,
            periodIndex: 11,
          ),
        ).thenAnswer((_) async => childSuggestionPayload);

        await interactor.loadPeriodDetail(
          child: undisclosedChild,
          period: week11Period,
        );

        verify(
          () => mockProgressUseCase.getSharedPeriodContent(
            periodUnit: ProgressPeriodUnit.week,
            periodIndex: 11,
            gender: ProgressGenderFilter.all,
          ),
        ).called(1);
      },
    );

    test('throws when child suggestions endpoint fails', () async {
      when(
        () => mockProgressUseCase.getSharedPeriodContent(
          periodUnit: ProgressPeriodUnit.week,
          periodIndex: 11,
          gender: ProgressGenderFilter.boy,
        ),
      ).thenAnswer(
        (_) async => ProgressSharedPeriodContent(
          guide: sharedGuide,
          exercises: sharedExercises,
        ),
      );
      when(
        () => mockProgressUseCase.getChildPeriodSuggestions(
          childId: 5,
          periodUnit: ProgressPeriodUnit.week,
          periodIndex: 11,
        ),
      ).thenThrow(
        const ServerException(message: 'AI generation failed', statusCode: 502),
      );

      expect(
        () =>
            interactor.loadPeriodDetail(child: boyChild, period: week11Period),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('loadRecommendedArticles', () {
    test(
      'delegates to ArticlesV2UseCase and maps items to progress recommendations',
      () async {
        const article = ArticleListItem(
          slug: 'sleep-routine',
          title: 'Keep bedtime predictable',
          excerpt: 'A steady bedtime routine can improve sleep quality.',
          readingTime: 5,
          heroImageUrl: 'https://cdn.example.com/image.png',
          topics: [],
          viewCount: 10,
          isSaved: false,
        );

        when(
          () => mockArticlesV2UseCase.getRecommendedArticles(
            childId: 5,
            progressIndex: 11,
            progressType: 'week',
          ),
        ).thenAnswer((_) async => const [article]);

        final result = await interactor.loadRecommendedArticles(
          child: boyChild,
          period: week11Period,
        );

        expect(result, hasLength(1));
        expect(result.first.title, 'Keep bedtime predictable');
        expect(result.first.data['slug'], 'sleep-routine');

        verify(
          () => mockArticlesV2UseCase.getRecommendedArticles(
            childId: 5,
            progressIndex: 11,
            progressType: 'week',
          ),
        ).called(1);
      },
    );
  });
}
