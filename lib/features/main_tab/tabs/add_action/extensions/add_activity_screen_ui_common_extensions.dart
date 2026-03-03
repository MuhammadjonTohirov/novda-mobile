import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';

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

  Widget addActivityQualityFieldIcon(Quality? quality) {
    return switch (quality) {
      Quality.bad => addActivityAssetIcon(
        _iconThumbsDown,
        size: 24,
        color: appColors.error,
      ),
      Quality.normal => addActivityAssetIcon(
        _iconThumbsUp,
        size: 24,
        color: appColors.accent.withValues(alpha: 0.75),
      ),
      Quality.good => addActivityAssetIcon(
        _iconKid,
        size: 24,
        color: appColors.accent,
      ),
      null => addActivityAssetIcon(_iconKid, size: 24, color: appColors.accent),
    };
  }

  Widget addActivityReminderFieldIcon() => addActivityAssetIcon(
    _iconNotification,
    size: 24,
    color: appColors.accent,
  );

  Widget addActivityQualityBadIcon() =>
      addActivityAssetIcon(_iconThumbsDown, size: 24, color: appColors.error);

  Widget addActivityQualityNormalIcon() => addActivityAssetIcon(
    _iconThumbsUp,
    size: 24,
    color: appColors.accent.withValues(alpha: 0.75),
  );

  Widget addActivityQualityGoodIcon() =>
      addActivityAssetIcon(_iconKid, size: 24, color: appColors.accent);

  Widget addActivityAssetIcon(
    String assetPath, {
    double size = 24,
    Color? color,
  }) {
    final icon = Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );

    if (color == null) return icon;

    return ColorFiltered(
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      child: icon,
    );
  }

  String addActivityDateTimeLabel(DateTime dateTime) {
    return DateFormat('MMM d, HH:mm').format(dateTime.toLocal());
  }
}
