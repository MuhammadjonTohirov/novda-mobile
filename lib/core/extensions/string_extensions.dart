/// Common helpers on [String].
extension StringExtensions on String {
  /// `true` when the string contains at least one non-whitespace character.
  bool get isNotBlank => trim().isNotEmpty;
}

/// Common helpers on [String?].
extension NullableStringExtensions on String? {
  /// `true` when non-null and not blank.
  bool get hasContent => this != null && this!.trim().isNotEmpty;

  /// Returns the string if it [hasContent], otherwise [fallback].
  String orElse(String fallback) => hasContent ? this! : fallback;
}
