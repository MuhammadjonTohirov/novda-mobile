import 'package:flutter/material.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';

extension ProgressTabUiNoChildExtensions on BuildContext {
  Widget progressNoChildView() {
    return Text(
      l10n.progressNoChildSelected,
      style: AppTypography.bodyMRegular.copyWith(
        color: appColors.textSecondary,
      ),
      textAlign: TextAlign.center,
    ).paddingAll(24).center().safeArea();
  }
}
