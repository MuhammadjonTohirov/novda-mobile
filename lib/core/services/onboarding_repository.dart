import 'package:shared_preferences/shared_preferences.dart';

abstract interface class OnboardingRepository {
  bool get hasCompletedOnboarding;
  Future<void> completeOnboarding();
}

class SharedPrefsOnboardingRepository implements OnboardingRepository {
  SharedPrefsOnboardingRepository({required SharedPreferences prefs})
    : _prefs = prefs;

  final SharedPreferences _prefs;

  static const _key = 'onboarding_completed';

  @override
  bool get hasCompletedOnboarding => _prefs.getBool(_key) ?? false;

  @override
  Future<void> completeOnboarding() => _prefs.setBool(_key, true);
}
