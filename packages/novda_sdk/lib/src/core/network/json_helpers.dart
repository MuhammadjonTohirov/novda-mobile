// Shared helpers for extracting typed values from raw JSON.
// Used by gateway implementations to avoid duplicating parsing logic.

/// Extracts a [List] from an ambiguous JSON shape.
///
/// Tries [candidateKeys] in order on a Map, then falls back to the first
/// list-typed value found among all entries.
List<dynamic> extractList(
  Object? json, {
  required List<String> candidateKeys,
}) {
  if (json is List<dynamic>) return json;

  if (json is Map<String, dynamic>) {
    for (final key in candidateKeys) {
      final value = json[key];
      if (value is List<dynamic>) return value;
    }

    for (final value in json.values) {
      if (value is List<dynamic>) return value;
    }
  }

  throw const FormatException('Expected a list response');
}

/// Extracts a [Map] from an ambiguous JSON shape.
///
/// Tries [candidateKeys] in order, then returns the map itself.
Map<String, dynamic> extractMap(
  Object? json, {
  List<String> candidateKeys = const [],
}) {
  if (json is Map<String, dynamic>) {
    for (final key in candidateKeys) {
      final value = json[key];
      if (value is Map<String, dynamic>) return value;
    }
    return json;
  }

  throw const FormatException('Expected a map response');
}

/// Safe cast helpers for JSON values.
int? asInt(Object? value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}

String? asString(Object? value) => value?.toString();

bool asBool(Object? value, {bool defaultValue = false}) {
  if (value is bool) return value;
  if (value is int) return value != 0;
  if (value is String) return value.toLowerCase() == 'true';
  return defaultValue;
}

DateTime? asDateTime(Object? value) {
  if (value is String) return DateTime.tryParse(value);
  return null;
}
