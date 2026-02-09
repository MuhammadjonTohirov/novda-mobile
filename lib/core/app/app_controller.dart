import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../ui/language_selector_button.dart';

/// App controller that provides theme and locale management
class AppController extends InheritedWidget {
  const AppController({
    super.key,
    required this.themeVariant,
    required this.locale,
    required this.setThemeVariant,
    required this.setLocale,
    required super.child,
  });

  final ThemeVariant themeVariant;
  final Locale locale;
  final ValueChanged<ThemeVariant> setThemeVariant;
  final ValueChanged<Locale> setLocale;

  static AppController of(BuildContext context) {
    final controller = context.dependOnInheritedWidgetOfExactType<AppController>();
    assert(controller != null, 'No AppController found in context');
    return controller!;
  }

  static AppController? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppController>();
  }

  void setLanguage(AppLanguage language) {
    setLocale(Locale(language.code));
  }

  AppLanguage get currentLanguage {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == locale.languageCode,
      orElse: () => AppLanguage.english,
    );
  }

  @override
  bool updateShouldNotify(AppController oldWidget) {
    return themeVariant != oldWidget.themeVariant || locale != oldWidget.locale;
  }
}

/// Extension on BuildContext for easy access to AppController
extension AppControllerExtension on BuildContext {
  AppController get appController => AppController.of(this);
}
