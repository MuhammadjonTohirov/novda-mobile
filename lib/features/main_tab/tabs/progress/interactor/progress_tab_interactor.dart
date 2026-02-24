import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/services/services.dart';

class ProgressTabChildContext {
  const ProgressTabChildContext({
    required this.id,
    required this.name,
    required this.ageDisplay,
    required this.birthDate,
    required this.gender,
  });

  final int id;
  final String name;
  final String ageDisplay;
  final DateTime birthDate;
  final Gender gender;
}

class ProgressTabInteractor {
  ProgressTabInteractor({
    UserUseCase? userUseCase,
    ChildrenUseCase? childrenUseCase,
    ProgressUseCase? progressUseCase,
  }) : _userUseCase = userUseCase ?? services.sdk.user,
       _childrenUseCase = childrenUseCase ?? services.sdk.children,
       _progressUseCase = progressUseCase ?? services.sdk.progress;

  final UserUseCase _userUseCase;
  final ChildrenUseCase _childrenUseCase;
  final ProgressUseCase _progressUseCase;

  Future<ProgressTabChildContext?> resolveActiveChild() async {
    final results = await Future.wait([
      _userUseCase.getProfile(),
      _childrenUseCase.getChildren(),
    ]);

    final user = results[0] as User;
    final children = results[1] as List<ChildListItem>;
    if (children.isEmpty) return null;

    final activeChild = _resolveActiveChild(
      children: children,
      activeChildId: user.lastActiveChild,
    );

    return ProgressTabChildContext(
      id: activeChild.id,
      name: activeChild.name,
      ageDisplay: activeChild.ageDisplay,
      birthDate: activeChild.birthDate,
      gender: activeChild.gender,
    );
  }

  Future<List<ProgressPeriod>> loadAllPeriods() async {
    final result = await _progressUseCase.getAllPeriods();
    return result.periods;
  }

  Future<ProgressGuide> loadPeriodDetail({
    required ProgressTabChildContext child,
    required ProgressPeriod period,
  }) {
    if (period.periodUnit == ProgressPeriodUnit.unknown) {
      return loadCurrentProgress(child: child);
    }

    return _progressUseCase.getPeriodDetail(
      periodUnit: period.periodUnit,
      periodIndex: period.periodIndex,
    );
  }

  Future<ProgressGuide> loadCurrentProgress({
    required ProgressTabChildContext child,
  }) {
    return _progressUseCase.getCurrentProgress(
      ageDays: ageInDays(child.birthDate),
    );
  }

  ChildListItem _resolveActiveChild({
    required List<ChildListItem> children,
    required int? activeChildId,
  }) {
    if (activeChildId == null) return children.first;

    for (final child in children) {
      if (child.id == activeChildId) return child;
    }

    return children.first;
  }

  int ageInDays(DateTime birthDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final birth = DateTime(birthDate.year, birthDate.month, birthDate.day);
    final days = today.difference(birth).inDays;
    return days < 0 ? 0 : days;
  }
}
