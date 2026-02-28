import 'package:flutter/painting.dart';

/// Shorthand for coloring a [TextStyle].
extension TextStyleColorExtension on TextStyle {
  /// `AppTypography.headingL.colored(colors.textPrimary)`
  /// instead of `.copyWith(color: colors.textPrimary)`.
  TextStyle colored(Color color) => copyWith(color: color);
}
