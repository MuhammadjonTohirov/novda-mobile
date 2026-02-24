import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/extensions/extensions.dart';

const _iconKid = 'assets/images/others/icon_kid.png';
const _iconThumbsUp = 'assets/images/others/icon_thumbs-up.png';
const _iconThumbsDown = 'assets/images/others/icon_thumbs-down.png';
const _iconNotification = 'assets/images/others/iocon_notification_large.png';

extension AddActivityScreenUiCommonExtensions on BuildContext {
  String addActivityQualityLabel(Quality quality) {
    return switch (quality) {
      Quality.good => l10n.addActivityQualityGood,
      Quality.normal => l10n.addActivityQualityNormal,
      Quality.bad => l10n.addActivityQualityBad,
    };
  }

  String addActivityReminderFallbackTitle(String activityTitle) {
    return l10n.homeReminderTitle(activityTitle);
  }

  String addActivitySelectedCountLabel(int count) {
    return l10n.addActivitySelectedCount(count);
  }

  String addActivityConditionsCountLabel(int count) {
    return l10n.addActivityConditionsCount(count);
  }

  Widget addActivityQualityFieldIcon() =>
      addActivityAssetIcon(_iconKid, size: 28);

  Widget addActivityReminderFieldIcon() =>
      addActivityAssetIcon(_iconNotification, size: 28);

  Widget addActivityQualityBadIcon() =>
      addActivityAssetIcon(_iconThumbsDown, size: 24);

  Widget addActivityQualityNormalIcon() =>
      addActivityAssetIcon(_iconThumbsUp, size: 24);

  Widget addActivityQualityGoodIcon() =>
      addActivityAssetIcon(_iconKid, size: 24);

  Widget addActivityAssetIcon(String assetPath, {double size = 24}) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }

  String addActivityDateTimeLabel(DateTime dateTime) {
    return DateFormat('MMM d, HH:mm').format(dateTime.toLocal());
  }
}
