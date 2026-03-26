import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../helpers/mock_use_cases.dart';
import '../../helpers/test_fixtures.dart';

void main() {
  group('Cached child selection', () {
    late MockUserUseCase mockUserUseCase;
    late MockChildrenUseCase mockChildrenUseCase;
    late CachedUserUseCase cachedUserUseCase;
    late CachedChildrenUseCase cachedChildrenUseCase;

    setUp(() {
      mockUserUseCase = MockUserUseCase();
      mockChildrenUseCase = MockChildrenUseCase();
      cachedUserUseCase = CachedUserUseCase(mockUserUseCase);
      cachedChildrenUseCase = CachedChildrenUseCase(
        mockChildrenUseCase,
        onInvalidateRelatedCaches: cachedUserUseCase.invalidateProfileCache,
      );
    });

    test(
      'invalidates cached profile after selecting a different child',
      () async {
        when(
          () => mockUserUseCase.getProfile(),
        ).thenAnswer((_) async => testUser);

        final initialProfile = await cachedUserUseCase.getProfile();
        expect(initialProfile.lastActiveChild, 10);

        when(
          () => mockChildrenUseCase.selectChild(11),
        ).thenAnswer((_) async {});
        when(() => mockUserUseCase.getProfile()).thenAnswer(
          (_) async => User(
            id: testUser.id,
            phone: testUser.phone,
            name: testUser.name,
            preferredLocale: testUser.preferredLocale,
            themePreference: testUser.themePreference,
            notificationsEnabled: testUser.notificationsEnabled,
            lastActiveChild: 11,
          ),
        );

        await cachedChildrenUseCase.selectChild(11);
        final refreshedProfile = await cachedUserUseCase.getProfile();

        expect(refreshedProfile.lastActiveChild, 11);
        verify(() => mockChildrenUseCase.selectChild(11)).called(1);
        verify(() => mockUserUseCase.getProfile()).called(2);
      },
    );
  });
}
