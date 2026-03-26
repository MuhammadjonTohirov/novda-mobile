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
    ActiveChildResolver? activeChildResolver,
    UserUseCase? userUseCase,
  }) : _activeChildResolver = activeChildResolver ?? ActiveChildResolver(),
       _userUseCase = userUseCase ?? services.sdk.user;

  final ActiveChildResolver _activeChildResolver;
  final UserUseCase _userUseCase;

  Future<ProfileTabData> loadProfileData() async {
    final results = await Future.wait([
      _userUseCase.getProfile(),
      _activeChildResolver.resolveActiveChild(),
    ]);

    final user = results[0] as User;
    final activeChild = results[1] as ChildListItem?;

    final childrenFuture = services.sdk.children.getChildren();
    final savedCountFuture = _loadSavedArticlesCount();

    final children = await childrenFuture;
    final savedArticlesCount = await savedCountFuture;

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
}
