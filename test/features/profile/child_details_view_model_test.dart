import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novda/features/main_tab/tabs/profile/child_details/interactor/child_details_interactor.dart';
import 'package:novda/features/main_tab/tabs/profile/child_details/view_model/child_details_view_model.dart';
import 'package:novda_core/novda_core.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../helpers/test_fixtures.dart';

class MockChildDetailsInteractor extends Mock
    implements ChildDetailsInteractor {}

void main() {
  late MockChildDetailsInteractor mockInteractor;

  setUp(() {
    mockInteractor = MockChildDetailsInteractor();
    registerFallbackValue(Gender.boy);
    registerFallbackValue(DateTime.now());
  });

  group('create mode', () {
    late ChildDetailsViewModel viewModel;

    setUp(() {
      viewModel = ChildDetailsViewModel(interactor: mockInteractor);
    });

    tearDown(() => viewModel.dispose());

    test('load sets defaults and transitions to success', () async {
      await viewModel.load();

      expect(viewModel.state, ViewState.success);
      expect(viewModel.hasLoadedForm, isTrue);
      expect(viewModel.isEditMode, isFalse);
      expect(viewModel.dayController.text, DateTime.now().day.toString());
    });

    test('canSubmit returns false when form is incomplete', () async {
      await viewModel.load();

      expect(viewModel.canSubmit, isFalse);
    });

    test('canSubmit returns true when form is complete', () async {
      await viewModel.load();

      viewModel.nameController.text = 'Baby';
      viewModel.setGender(Gender.girl);
      viewModel.dayController.text = '15';
      viewModel.monthController.text = '1';
      viewModel.yearController.text = '2024';
      viewModel.weightController.text = '3.5';
      viewModel.heightController.text = '50';

      expect(viewModel.canSubmit, isTrue);
    });

    test('birthDate parsing works correctly', () async {
      await viewModel.load();

      viewModel.dayController.text = '15';
      viewModel.monthController.text = '1';
      viewModel.yearController.text = '2024';

      expect(viewModel.birthDate, DateTime(2024, 1, 15));
    });

    test('birthDate returns null for invalid date', () async {
      await viewModel.load();

      viewModel.dayController.text = '31';
      viewModel.monthController.text = '2';
      viewModel.yearController.text = '2024';

      expect(viewModel.birthDate, isNull);
      expect(viewModel.hasBirthDateError, isTrue);
    });

    test('metric parsing works', () async {
      await viewModel.load();

      viewModel.weightController.text = '3,5';
      expect(viewModel.weightValue, 3.5);

      viewModel.heightController.text = '250.5';
      expect(viewModel.heightValue, isNull);
      expect(viewModel.hasHeightError, isTrue);
    });
  });

  group('edit mode', () {
    late ChildDetailsViewModel viewModel;

    setUp(() {
      viewModel = ChildDetailsViewModel(
        childId: 10,
        interactor: mockInteractor,
      );
    });

    tearDown(() => viewModel.dispose());

    test('load fetches existing child and populates form', () async {
      when(() => mockInteractor.loadChild(10)).thenAnswer(
        (_) async => testChild,
      );

      await viewModel.load();

      expect(viewModel.state, ViewState.success);
      expect(viewModel.isEditMode, isTrue);
      expect(viewModel.nameController.text, 'Test Child');
      expect(viewModel.selectedGender, Gender.boy);
    });

    test('load sets error on failure', () async {
      when(() => mockInteractor.loadChild(10)).thenThrow(
        const NotFoundException(message: 'Not found'),
      );

      await viewModel.load();

      expect(viewModel.state, ViewState.error);
      expect(viewModel.errorMessage, 'Not found');
    });
  });
}
