import 'package:flutter/material.dart';

/// Helpers for deriving [Color] values from backend hex strings.
extension ColorParsingExtension on Color {
  /// Parse [rawHex] into [Color].
  ///
  /// Returns current color when input is empty/invalid.
  Color parseHexOrSelf(String rawHex) {
    var value = rawHex.trim();
    if (value.isEmpty) return this;

    if (value.startsWith('#')) {
      value = value.substring(1);
    }

    if (value.length == 6) {
      value = 'FF$value';
    }

    final intValue = int.tryParse(value, radix: 16);
    if (intValue == null) return this;

    return Color(intValue);
  }
}
