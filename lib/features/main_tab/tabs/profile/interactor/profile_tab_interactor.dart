import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/services/services.dart';

class ProfileTabData {
  const ProfileTabData({
    required this.user,
    required this.children,
    required this.activeChild,
    required this.savedArticlesCount,
  });

  factory ProfileTabData.empty() {
    return const ProfileTabData(
      user: null,
      children: [],
      activeChild: null,
      savedArticlesCount: 0,
    );
  }

  final User? user;
  final List<ChildListItem> children;
  final ChildListItem? activeChild;
  final int savedArticlesCount;

  bool get hasContent => user != null || children.isNotEmpty;
}

class ProfileTabInteractor {
  ProfileTabInteractor({
    UserUseCase? userUseCase,
    ChildrenUseCase? childrenUseCase,
  }) : _userUseCase = userUseCase ?? services.sdk.user,
       _childrenUseCase = childrenUseCase ?? services.sdk.children;

  final UserUseCase _userUseCase;
  final ChildrenUseCase _childrenUseCase;

  Future<ProfileTabData> loadProfileData() async {
    final results = await Future.wait([
      _userUseCase.getProfile(),
      _childrenUseCase.getChildren(),
    ]);

    final user = results[0] as User;
    final children = results[1] as List<ChildListItem>;
    final activeChild = _resolveActiveChild(
      children: children,
      activeChildId: user.lastActiveChild,
    );

    final savedArticlesCount = await _loadSavedArticlesCount();

    return ProfileTabData(
      user: user,
      children: children,
      activeChild: activeChild,
      savedArticlesCount: savedArticlesCount,
    );
  }

  Future<int> _loadSavedArticlesCount() async {
    try {
      final saved = await _userUseCase.getSavedArticles();
      return saved.length;
    } catch (_) {
      return 0;
    }
  }

  ChildListItem? _resolveActiveChild({
    required List<ChildListItem> children,
    required int? activeChildId,
  }) {
    if (children.isEmpty) return null;
    if (activeChildId == null) return children.first;

    for (final child in children) {
      if (child.id == activeChildId) return child;
    }

    return children.first;
  }
}
