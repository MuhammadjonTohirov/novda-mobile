import 'package:flutter/material.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/theme/app_theme.dart';

/// Shared linear progress bar used across auth flow screens.
class AuthStepProgressBar extends StatelessWidget {
  const AuthStepProgressBar({
    super.key,
    required this.step,
    this.total = 7,
  });

  /// Current step (1-based).
  final int step;

  /// Total number of steps.
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return LinearProgressIndicator(
      value: step / total,
      backgroundColor: colors.bgSecondary,
      valueColor: AlwaysStoppedAnimation<Color>(colors.bgBarOnProgress),
      borderRadius: BorderRadius.circular(2),
    ).container(
      height: 4,
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
