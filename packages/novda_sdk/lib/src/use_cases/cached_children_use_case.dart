import '../core/cache/in_memory_cache.dart';
import '../models/child.dart';
import '../models/enums.dart';
import 'children_use_case.dart';

/// Caching decorator for [ChildrenUseCase].
///
/// Caches [getChildren] and [getChild] responses with a 2-minute TTL.
/// Mutation operations invalidate the cache automatically.
class CachedChildrenUseCase implements ChildrenUseCase {
  CachedChildrenUseCase(this._inner);

  final ChildrenUseCase _inner;
  final _childrenCache = InMemoryCache<List<ChildListItem>>(
    ttl: Duration(minutes: 2),
  );
  final _childCache = <int, InMemoryCache<Child>>{};

  @override
  Future<List<ChildListItem>> getChildren() async {
    final cached = _childrenCache.value;
    if (cached != null) return cached;
    final result = await _inner.getChildren();
    _childrenCache.set(result);
    return result;
  }

  @override
  Future<Child> getChild(int childId) async {
    final cache = _childCache.putIfAbsent(
      childId,
      () => InMemoryCache<Child>(ttl: Duration(minutes: 2)),
    );
    final cached = cache.value;
    if (cached != null) return cached;
    final result = await _inner.getChild(childId);
    cache.set(result);
    return result;
  }

  @override
  Future<Child> createChild({
    required String name,
    required Gender gender,
    required DateTime birthDate,
    ThemePreference? themeOverride,
  }) async {
    final result = await _inner.createChild(
      name: name,
      gender: gender,
      birthDate: birthDate,
      themeOverride: themeOverride,
    );
    _invalidateAll();
    return result;
  }

  @override
  Future<Child> updateChild(
    int childId, {
    String? name,
    Gender? gender,
    DateTime? birthDate,
    ThemePreference? themeOverride,
  }) async {
    final result = await _inner.updateChild(
      childId,
      name: name,
      gender: gender,
      birthDate: birthDate,
      themeOverride: themeOverride,
    );
    _invalidateAll();
    return result;
  }

  @override
  Future<void> deleteChild(int childId) async {
    await _inner.deleteChild(childId);
    _invalidateAll();
  }

  @override
  Future<void> selectChild(int childId) async {
    await _inner.selectChild(childId);
    _childrenCache.invalidate();
  }

  void _invalidateAll() {
    _childrenCache.invalidate();
    _childCache.clear();
  }
}
