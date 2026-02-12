import 'package:novda_sdk/novda_sdk.dart';

import '../models/theme_variant.dart';

/// Resolves app [ThemeVariant] values from backend theme preferences.
final class ThemePreferenceResolver {
  const ThemePreferenceResolver._();

  /// Resolve theme from user preference and active child gender.
  static ThemeVariant resolve({
    required ThemePreference preference,
    Gender? activeChildGender,
  }) {
    return switch (preference) {
      ThemePreference.warm => ThemeVariant.warmOrange,
      ThemePreference.calm => ThemeVariant.softBlue,
      ThemePreference.auto => fromGender(activeChildGender),
    };
  }

  /// Map gender to theme: boy -> calm, girl/unknown -> warm.
  static ThemeVariant fromGender(Gender? gender) {
    return gender == Gender.boy
        ? ThemeVariant.softBlue
        : ThemeVariant.warmOrange;
  }

  static ChildListItem? activeChild(
    List<ChildListItem> children, {
    int? activeChildId,
  }) {
    if (children.isEmpty) return null;
    if (activeChildId == null) return children.first;

    for (final child in children) {
      if (child.id == activeChildId) return child;
    }
    return children.first;
  }
}
