import 'package:novda_sdk/novda_sdk.dart';

import '../models/theme_variant.dart';
import '../theme/theme_preference_resolver.dart';

/// Encapsulates theme resolution logic.
class ThemeResolutionService {
  ThemeResolutionService({
    required UserUseCase userUseCase,
    required ChildrenUseCase childrenUseCase,
  })  : _userUseCase = userUseCase,
       _childrenUseCase = childrenUseCase;

  final UserUseCase _userUseCase;
  final ChildrenUseCase _childrenUseCase;

  /// Resolves the effective theme variant based on user preferences and
  /// active child gender.
  Future<ThemeVariant> resolveThemeVariant({int? selectedChildId}) async {
    try {
      final user = await _userUseCase.getProfile();
      if (user.themePreference != ThemePreference.auto) {
        return ThemePreferenceResolver.resolve(
          preference: user.themePreference,
        );
      }

      final children = await _childrenUseCase.getChildren();
      final activeChild = ThemePreferenceResolver.activeChild(
        children,
        activeChildId: selectedChildId ?? user.lastActiveChild,
      );

      return ThemePreferenceResolver.resolve(
        preference: user.themePreference,
        activeChildGender: activeChild?.gender,
      );
    } catch (_) {
      return ThemeVariant.warmOrange;
    }
  }
}
