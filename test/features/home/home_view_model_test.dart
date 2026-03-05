import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novda/features/main_tab/tabs/home/interactors/home_interactor.dart';
import 'package:novda/features/main_tab/tabs/home/view_models/home_view_model.dart';
import 'package:novda_core/novda_core.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../helpers/test_fixtures.dart';

class MockHomeInteractor extends Mock implements HomeInteractor {}

class _FakeReminder extends Fake implements Reminder {}

void main() {
  setUpAll(() {
    registerFallbackValue(_FakeReminder());
  });

  late MockHomeInteractor mockInteractor;
  late HomeViewModel viewModel;

  setUp(() {
    mockInteractor = MockHomeInteractor();
    viewModel = HomeViewModel(interactor: mockInteractor);
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('load', () {
    test('sets loading then success on successful load', () async {
      final dashboard = HomeDashboardData(
        children: [testChildListItem],
        activeChild: testChildListItem,
        activeChildDetails: testChild,
        activityTypes: [testActivityType],
        latestActivitiesByType: const {},
        todayCountByType: const {},
        recentReminders: const [],
      );

      when(() => mockInteractor.loadDashboard()).thenAnswer(
        (_) async => dashboard,
      );

      final states = <ViewState>[];
      viewModel.addListener(() => states.add(viewModel.state));

      await viewModel.load();

      expect(states, contains(ViewState.loading));
      expect(viewModel.state, ViewState.success);
      expect(viewModel.activeChild?.id, 10);
      expect(viewModel.activityTypes, hasLength(1));
    });

    test('sets error state on failure', () async {
      when(() => mockInteractor.loadDashboard()).thenThrow(
        const ServerException(message: 'Network error', statusCode: 500),
      );

      await viewModel.load();

      expect(viewModel.state, ViewState.error);
      expect(viewModel.errorMessage, 'Network error');
    });
  });

  group('completeReminder', () {
    test('updates reminder in list on success', () async {
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

      final dashboard = HomeDashboardData(
        children: [testChildListItem],
        activeChild: testChildListItem,
        activeChildDetails: testChild,
        activityTypes: [testActivityType],
        latestActivitiesByType: const {},
        todayCountByType: const {},
        recentReminders: [testReminder],
      );

      when(() => mockInteractor.loadDashboard()).thenAnswer(
        (_) async => dashboard,
      );
      when(() => mockInteractor.completeReminder(100)).thenAnswer(
        (_) async => completedReminder,
      );
      when(() => mockInteractor.sortReminders(any(), any())).thenReturn(0);

      await viewModel.load();
      await viewModel.completeReminder(100);

      expect(viewModel.recentReminders.first.status, ReminderStatus.completed);
    });

    test('sets action error on failure', () async {
      final dashboard = HomeDashboardData(
        children: [testChildListItem],
        activeChild: testChildListItem,
        activeChildDetails: testChild,
        activityTypes: [testActivityType],
        latestActivitiesByType: const {},
        todayCountByType: const {},
        recentReminders: [testReminder],
      );

      when(() => mockInteractor.loadDashboard()).thenAnswer(
        (_) async => dashboard,
      );
      when(() => mockInteractor.completeReminder(100)).thenThrow(
        const ServerException(message: 'Server error', statusCode: 500),
      );

      await viewModel.load();
      await viewModel.completeReminder(100);

      expect(viewModel.consumeActionError(), 'Server error');
      expect(viewModel.consumeActionError(), isNull);
    });
  });

  group('consumeActionError', () {
    test('returns null when no error', () {
      expect(viewModel.consumeActionError(), isNull);
    });
  });
}
