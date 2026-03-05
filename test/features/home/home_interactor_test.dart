import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novda/features/main_tab/tabs/home/interactors/home_interactor.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../helpers/mock_use_cases.dart';
import '../../helpers/test_fixtures.dart';

void main() {
  late MockUserUseCase mockUserUseCase;
  late MockChildrenUseCase mockChildrenUseCase;
  late MockActivitiesUseCase mockActivitiesUseCase;
  late MockRemindersUseCase mockRemindersUseCase;
  late HomeInteractor interactor;

  setUp(() {
    mockUserUseCase = MockUserUseCase();
    mockChildrenUseCase = MockChildrenUseCase();
    mockActivitiesUseCase = MockActivitiesUseCase();
    mockRemindersUseCase = MockRemindersUseCase();

    interactor = HomeInteractor(
      userUseCase: mockUserUseCase,
      childrenUseCase: mockChildrenUseCase,
      activitiesUseCase: mockActivitiesUseCase,
      remindersUseCase: mockRemindersUseCase,
    );
  });

  group('loadDashboard', () {
    test('returns empty dashboard when no children exist', () async {
      when(() => mockUserUseCase.getProfile()).thenAnswer(
        (_) async => testUser,
      );
      when(() => mockChildrenUseCase.getChildren()).thenAnswer(
        (_) async => const [],
      );
      when(() => mockActivitiesUseCase.getActivityTypes()).thenAnswer(
        (_) async => [testActivityType],
      );

      final result = await interactor.loadDashboard();

      expect(result.children, isEmpty);
      expect(result.activeChild, isNull);
      expect(result.activityTypes, hasLength(1));
    });

    test('loads dashboard with active child', () async {
      when(() => mockUserUseCase.getProfile()).thenAnswer(
        (_) async => testUser,
      );
      when(() => mockChildrenUseCase.getChildren()).thenAnswer(
        (_) async => [testChildListItem],
      );
      when(() => mockActivitiesUseCase.getActivityTypes()).thenAnswer(
        (_) async => [testActivityType],
      );
      when(() => mockChildrenUseCase.getChild(any())).thenAnswer(
        (_) async => testChild,
      );
      when(() => mockActivitiesUseCase.getActivitySummary(any())).thenAnswer(
        (_) async => const ActivitySummary(
          lastActivities: [],
          dailyCounts: {},
          totalToday: 0,
        ),
      );
      when(
        () => mockActivitiesUseCase.getActivities(
          any(),
          from: any(named: 'from'),
          to: any(named: 'to'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => const []);
      when(
        () => mockRemindersUseCase.getReminders(
          any(),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => const []);

      final result = await interactor.loadDashboard();

      expect(result.children, hasLength(1));
      expect(result.activeChild?.id, 10);
      expect(result.activeChildDetails, isNotNull);
    });
  });

  group('completeReminder', () {
    test('delegates to reminders use case', () async {
      final completedReminder = Reminder(
        id: 100,
        child: 10,
        childName: 'Test Child',
        activityType: 1,
        activityTypeDetail: testActivityType,
        dueAt: DateTime.now(),
        status: ReminderStatus.completed,
        statusDisplay: 'Completed',
        completedAt: DateTime.now(),
        createdBy: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      when(() => mockRemindersUseCase.completeReminder(100)).thenAnswer(
        (_) async => completedReminder,
      );

      final result = await interactor.completeReminder(100);

      expect(result.status, ReminderStatus.completed);
      verify(() => mockRemindersUseCase.completeReminder(100)).called(1);
    });
  });

  group('sortReminders', () {
    test('sorts completed reminders after pending ones', () {
      final pending = Reminder(
        id: 1,
        child: 10,
        childName: 'C',
        activityType: 1,
        activityTypeDetail: testActivityType,
        dueAt: DateTime(2026, 3, 6, 14),
        status: ReminderStatus.pending,
        statusDisplay: 'Pending',
        createdBy: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final completed = Reminder(
        id: 2,
        child: 10,
        childName: 'C',
        activityType: 1,
        activityTypeDetail: testActivityType,
        dueAt: DateTime(2026, 3, 6, 12),
        status: ReminderStatus.completed,
        statusDisplay: 'Completed',
        createdBy: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final list = [completed, pending]..sort(interactor.sortReminders);

      expect(list.first.status, ReminderStatus.pending);
      expect(list.last.status, ReminderStatus.completed);
    });
  });
}
