import 'package:novda_sdk/novda_sdk.dart';

import '../../l10n/app_localizations.dart';

/// Localized label for [Gender].
extension GenderLabelExtension on Gender {
  String localizedLabel(AppLocalizations l10n) => switch (this) {
        Gender.boy => l10n.boy,
        Gender.girl => l10n.girl,
        _ => l10n.homeUndisclosed,
      };
}

/// Asset paths mapped to [Gender].
extension GenderAssetExtension on Gender {
  /// Avatar image asset path used on cards / headers.
  String get avatarAsset => avatarAssetByAgeInWeeks(0);

  /// Age-aware avatar image asset path used on cards / headers.
  ///
  /// Ranges:
  /// 0-2y -> img_1, 2-3y -> img_2, 3-4y -> img_3, 4y+ -> img_4.
  String avatarAssetByAgeInWeeks(int ageInWeeks) {
    final normalizedWeeks = ageInWeeks < 0 ? 0 : ageInWeeks;
    final ageYears = normalizedWeeks / 52.0;
    final suffix = ageYears < 2
        ? 1
        : ageYears < 3
            ? 2
            : ageYears < 4
                ? 3
                : 4;

    return switch (this) {
      Gender.boy => 'assets/images/kid/boy_img_$suffix.png',
      Gender.girl => 'assets/images/kid/girl_img_$suffix.png',
      _ => 'assets/images/icon_baby.png',
    };
  }

  /// Smaller icon asset used in selection screens.
  String get iconAsset => switch (this) {
        Gender.boy => 'assets/images/icon_baby_boy.png',
        Gender.girl => 'assets/images/icon_baby_girl.png',
        _ => 'assets/images/icon_baby.png',
      };
}
