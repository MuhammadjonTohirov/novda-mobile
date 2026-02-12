/// Supported app languages.
enum AppLanguage {
  english('en', 'EN', 'English', 'logo_united_kingdom.png'),
  uzbek('uz', 'UZ', "O'zbek tili", 'logo_uzbekistan.png'),
  russian('ru', 'RU', 'Русский язык', 'logo_russia.png');

  const AppLanguage(this.code, this.shortCode, this.name, this.flagAsset);

  final String code;
  final String shortCode;
  final String name;
  final String flagAsset;

  String get flagPath => 'assets/images/$flagAsset';
}
