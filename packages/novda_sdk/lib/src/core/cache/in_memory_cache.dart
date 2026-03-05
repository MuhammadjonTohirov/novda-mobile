/// A generic TTL-based in-memory cache that stores a single value.
///
/// The cached value expires automatically after the configured [ttl] duration.
class InMemoryCache<T> {
  InMemoryCache({required this.ttl});

  /// Time-to-live for cached values.
  final Duration ttl;

  T? _value;
  DateTime? _cachedAt;

  /// Returns the cached value if it exists and has not expired, otherwise `null`.
  T? get value {
    if (_value == null || _cachedAt == null) return null;
    if (DateTime.now().difference(_cachedAt!) > ttl) {
      invalidate();
      return null;
    }
    return _value;
  }

  /// Stores [value] and resets the expiration timer.
  void set(T value) {
    _value = value;
    _cachedAt = DateTime.now();
  }

  /// Clears the cached value and expiration timestamp.
  void invalidate() {
    _value = null;
    _cachedAt = null;
  }

  /// Whether a non-expired value is present.
  bool get hasValue => value != null;
}
