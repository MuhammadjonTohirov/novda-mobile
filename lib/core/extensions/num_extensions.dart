import 'package:flutter/material.dart';

/// Spacing shortcuts via [SizedBox].
extension NumSpacingExtension on num {
  /// Vertical gap: `12.h` → `SizedBox(height: 12)`.
  SizedBox get h => SizedBox(height: toDouble());

  /// Horizontal gap: `12.w` → `SizedBox(width: 12)`.
  SizedBox get w => SizedBox(width: toDouble());
}

/// Quick [BorderRadius.circular] shorthand.
extension NumBorderRadiusExtension on num {
  /// `16.rounded` → `BorderRadius.circular(16)`.
  BorderRadius get rounded => BorderRadius.circular(toDouble());
}

/// Removes trailing `.0` from doubles.
extension DoubleDisplayExtension on double {
  /// `3.0` → `"3"`, `3.5` → `"3.5"`.
  String toCompactString() {
    return this == roundToDouble()
        ? toStringAsFixed(0)
        : toStringAsFixed(1);
  }
}

/// Compact label for large integers (e.g. follower counts).
extension IntCompactExtension on int {
  /// `1200` → `"1.2K"`, `999` → `"999"`.
  String toCompactLabel() {
    if (this >= 1000000) {
      return '${(this / 1000000).toCompactString()}M';
    }
    if (this >= 1000) {
      return '${(this / 1000).toCompactString()}K';
    }
    return toString();
  }
}
