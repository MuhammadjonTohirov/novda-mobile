import '../gateways/progress_gateway.dart';
import '../models/progress.dart';

/// Use case interface for progress operations
abstract interface class ProgressUseCase {
  /// Child-specific progress calendar with stage markers
  Future<ProgressCrisisCalendar> getCrisisCalendar(int childId);

  /// Current shared progress guide by age and optional gender
  Future<ProgressGuide> getCurrentProgress({
    required int ageDays,
    ProgressGenderFilter? gender,
  });

  /// Shared period selector by age or explicit period
  Future<ProgressPeriodSelector> getPeriodSelector({
    int? ageDays,
    ProgressGenderFilter? gender,
    int? before,
    int? after,
    ProgressPeriodUnit? periodUnit,
    int? periodIndex,
  });

  /// Guide for a specific shared period
  Future<ProgressGuide> getPeriodDetail({
    required ProgressPeriodUnit periodUnit,
    required int periodIndex,
    ProgressGenderFilter? gender,
  });

  /// All shared configured progress periods
  Future<ProgressAllPeriods> getAllPeriods({ProgressGenderFilter? gender});
}

/// Implementation of ProgressUseCase
class ProgressUseCaseImpl implements ProgressUseCase {
  ProgressUseCaseImpl(this._gateway);

  final ProgressGateway _gateway;

  @override
  Future<ProgressCrisisCalendar> getCrisisCalendar(int childId) {
    return _gateway.getCrisisCalendar(childId);
  }

  @override
  Future<ProgressGuide> getCurrentProgress({
    required int ageDays,
    ProgressGenderFilter? gender,
  }) {
    return _gateway.getCurrentProgress(ageDays: ageDays, gender: gender);
  }

  @override
  Future<ProgressPeriodSelector> getPeriodSelector({
    int? ageDays,
    ProgressGenderFilter? gender,
    int? before,
    int? after,
    ProgressPeriodUnit? periodUnit,
    int? periodIndex,
  }) {
    return _gateway.getPeriodSelector(
      ProgressPeriodSelectorQuery(
        ageDays: ageDays,
        gender: gender,
        before: before,
        after: after,
        periodUnit: periodUnit,
        periodIndex: periodIndex,
      ),
    );
  }

  @override
  Future<ProgressGuide> getPeriodDetail({
    required ProgressPeriodUnit periodUnit,
    required int periodIndex,
    ProgressGenderFilter? gender,
  }) {
    return _gateway.getPeriodDetail(
      periodUnit: periodUnit,
      periodIndex: periodIndex,
      gender: gender,
    );
  }

  @override
  Future<ProgressAllPeriods> getAllPeriods({ProgressGenderFilter? gender}) {
    return _gateway.getAllPeriods(gender: gender);
  }
}
