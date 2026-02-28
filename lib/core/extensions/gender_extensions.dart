import 'package:novda_sdk/novda_sdk.dart';

/// Asset paths mapped to [Gender].
extension GenderAssetExtension on Gender {
  /// Avatar image asset path used on cards / headers.
  String get avatarAsset => switch (this) {
        Gender.boy => 'assets/images/img_boy_avatar.png',
        Gender.girl => 'assets/images/img_girl_avatar.png',
        _ => 'assets/images/icon_baby.png',
      };

  /// Smaller icon asset used in selection screens.
  String get iconAsset => switch (this) {
        Gender.boy => 'assets/images/icon_baby_boy.png',
        Gender.girl => 'assets/images/icon_baby_girl.png',
        _ => 'assets/images/icon_baby.png',
      };
}
