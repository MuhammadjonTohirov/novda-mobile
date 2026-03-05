import 'package:mocktail/mocktail.dart';
import 'package:novda_sdk/novda_sdk.dart';

class MockUserUseCase extends Mock implements UserUseCase {}

class MockChildrenUseCase extends Mock implements ChildrenUseCase {}

class MockActivitiesUseCase extends Mock implements ActivitiesUseCase {}

class MockMeasurementsUseCase extends Mock implements MeasurementsUseCase {}

class MockRemindersUseCase extends Mock implements RemindersUseCase {}

class MockProgressUseCase extends Mock implements ProgressUseCase {}

class MockArticlesUseCase extends Mock implements ArticlesUseCase {}

class MockArticlesV2UseCase extends Mock implements ArticlesV2UseCase {}
