import 'package:novda_sdk/novda_sdk.dart';

import 'services.dart';

class ActiveChildResolver {
  ActiveChildResolver({
    UserUseCase? userUseCase,
    ChildrenUseCase? childrenUseCase,
  }) : _userUseCase = userUseCase ?? services.sdk.user,
       _childrenUseCase = childrenUseCase ?? services.sdk.children;

  final UserUseCase _userUseCase;
  final ChildrenUseCase _childrenUseCase;

  Future<({User user, List<ChildListItem> children})> _fetchUserAndChildren() async {
    final results = await Future.wait([
      _userUseCase.getProfile(),
      _childrenUseCase.getChildren(),
    ]);

    return (
      user: results[0] as User,
      children: results[1] as List<ChildListItem>,
    );
  }

  Future<int?> resolveActiveChildId() async {
    final (:user, :children) = await _fetchUserAndChildren();
    if (children.isEmpty) return null;
    return _findActiveChild(children, user.lastActiveChild)?.id ?? children.first.id;
  }

  Future<ChildListItem?> resolveActiveChild() async {
    final (:user, :children) = await _fetchUserAndChildren();
    if (children.isEmpty) return null;
    return _findActiveChild(children, user.lastActiveChild) ?? children.first;
  }

  static ChildListItem? _findActiveChild(
    List<ChildListItem> children,
    int? activeChildId,
  ) {
    if (activeChildId == null) return null;
    for (final child in children) {
      if (child.id == activeChildId) return child;
    }
    return null;
  }
}
