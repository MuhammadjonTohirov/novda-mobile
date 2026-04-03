import 'package:flutter/material.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import '../view_model/progress_tab_view_model.dart';
import 'progress_tab_detail_ui_extensions.dart';
import 'progress_tab_ui_no_child_extensions.dart';

extension ProgressTabUiBodyExtensions on BuildContext {
  static const double _periodSelectorHeight = 64;

  Widget progressTabBody({
    required ProgressTabViewModel viewModel,
    required Future<void> Function() onRefresh,
    required ValueChanged<ProgressPeriod> onPeriodTap,
    required VoidCallback onCalendarTap,
    required ScrollController periodScrollController,
  }) {
    final colors = appColors;
    final guide = viewModel.guide;
    final child = viewModel.activeChild;

    if (child == null) {
      return progressNoChildView();
    }
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        clipBehavior: Clip.none,
        children: [
          progressHeroSection(
            viewModel: viewModel,
            onCalendarTap: onCalendarTap,
            onPeriodTap: onPeriodTap,
            periodScrollController: periodScrollController,
          ),

          const SizedBox(height: 12),
          progressSummaryCard(
            viewModel: viewModel,
            guide: guide,
            isLoading: viewModel.isSharedContentLoading,
          ).paddingOnly(left: 16, right: 16),
          const SizedBox(height: 12),

          progressExercisesCard(
            guide: guide,
            isLoading: viewModel.isSharedContentLoading,
          ).paddingOnly(left: 16, right: 16),
          const SizedBox(height: 12),
          progressSuggestionsSection(
            name: child.name,
            suggestions: viewModel.suggestions,
            isLoading: viewModel.isSuggestionsLoading,
          ).paddingOnly(left: 16, right: 16),
          const SizedBox(height: 12),
          progressRecommendationsSection(
            name: child.name,
            recommendations: viewModel.recommendedArticles,
            isLoading: viewModel.isRecommendationsLoading,
          ).paddingOnly(left: 16, right: 16),
        ],
      ), //.paddingOnly(top: 20),
    ).container(color: colors.bgSecondary);
  }

  Widget progressHeroSection({
    required ProgressTabViewModel viewModel,
    required VoidCallback onCalendarTap,
    required ValueChanged<ProgressPeriod> onPeriodTap,
    required ScrollController periodScrollController,
  }) {
    final child = viewModel.activeChild!;
    final colors = appColors;
    final guide = viewModel.guide;
    final callout = _progressCallout(guide);
    final ageInWeeks = DateTime.now().difference(child.birthDate).inDays ~/ 7;

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                l10n.progressTab,
                style: AppTypography.headingL.copyWith(
                  color: colors.textPrimary,
                ),
              ).expanded(),
              Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: colors.accent,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.progressCalendar,
                        style: AppTypography.bodyMMedium.copyWith(
                          color: colors.accent,
                        ),
                      ),
                    ],
                  )
                  .paddingSymmetric(horizontal: 8, vertical: 8)
                  .inkWell(
                    onTap: onCalendarTap,
                    borderRadius: BorderRadius.circular(10),
                  ),
            ],
          ).paddingOnly(left: 16, right: 16),

          const SizedBox(height: 10),
          Row(
            children: [
              Image.asset(
                child.gender.avatarAssetByAgeInWeeks(ageInWeeks),
                width: 44,
                height: 44,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    child.name,
                    style: AppTypography.bodyLMedium.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    child.ageDisplay,
                    style: AppTypography.bodyMRegular.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ).expanded(),
            ],
          ).paddingOnly(left: 16, right: 16),
          const SizedBox(height: 14),
          if (viewModel.periods.isNotEmpty)
            progressPeriodSelector(
              viewModel: viewModel,
              onPeriodTap: onPeriodTap,
              controller: periodScrollController,
            ),
          if (viewModel.periods.isNotEmpty) const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.bgPrimary,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: colors.border),
            ),
            child: Text(
              callout,
              style: AppTypography.bodyMRegular.copyWith(
                color: colors.textPrimary,
                height: 1.35,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ).paddingOnly(left: 16, right: 16),
        ],
      ).paddingOnly(top: 10),
    );
  }

  Widget progressPeriodSelector({
    required ProgressTabViewModel viewModel,
    required ValueChanged<ProgressPeriod> onPeriodTap,
    required ScrollController controller,
  }) {
    final childBirthDate = viewModel.childBirthDate;
    if (childBirthDate == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: _periodSelectorHeight,
      child: ListView.separated(
        controller: controller,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 16, right: 16),
        itemCount: viewModel.periods.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final period = viewModel.periods[index];
          final isSelected = viewModel.isSelectedPeriod(period);

          return progressPeriodChip(
            period: period,
            birthDate: childBirthDate,
            isSelected: isSelected,
            onTap: () => onPeriodTap(period),
          );
        },
      ),
    );
  }

  Widget progressPeriodChip({
    required ProgressPeriod period,
    required DateTime birthDate,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colors = appColors;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: 110,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? colors.bgPrimary.withAlpha(230) : colors.bgPrimary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? colors.accent.withValues(alpha: 0.6)
              : colors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.textPrimary.withValues(
              alpha: isSelected ? 0.08 : 0.04,
            ),
            blurRadius: isSelected ? 12 : 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: AppTypography.bodyMMedium.copyWith(
              color: isSelected ? colors.accent : colors.textPrimary,
            ),
            child: Text(
              progressPeriodTitle(period),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: AppTypography.bodySRegular.copyWith(
              color: isSelected ? colors.accent : colors.textSecondary,
            ),
            child: Text(
              progressPeriodDateLabel(period: period, birthDate: birthDate),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ).inkWell(onTap: onTap, borderRadius: BorderRadius.circular(16));
  }

  String _progressCallout(ProgressGuide? guide) {
    return guide?.crisisWarning ??
        guide?.headline ??
        guide?.summary ??
        l10n.progressDefaultCallout;
  }
}
