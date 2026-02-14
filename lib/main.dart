import 'package:flutter/material.dart';

import 'core/app/app.dart';
import 'core/services/services.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await services.init();
  runApp(const NovdaApp());
}

class NovdaApp extends StatefulWidget {
  const NovdaApp({super.key});

  @override
  State<NovdaApp> createState() => _NovdaAppState();
}

class _NovdaAppState extends State<NovdaApp> {
  ThemeVariant _themeVariant = ThemeVariant.warmOrange;
  Locale _locale = const Locale('en');

  void _setThemeVariant(ThemeVariant variant) {
    setState(() {
      _themeVariant = variant;
    });
  }

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppController(
      themeVariant: _themeVariant,
      locale: _locale,
      setThemeVariant: _setThemeVariant,
      setLocale: _setLocale,
      child: AppThemeProvider(
        colorScheme: _themeVariant.colorScheme,
        child: MaterialApp(
          title: 'Novda',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.create(_themeVariant),
          locale: _locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
