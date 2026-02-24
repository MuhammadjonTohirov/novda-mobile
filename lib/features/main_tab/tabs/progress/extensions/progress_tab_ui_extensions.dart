import 'package:flutter/material.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/ui/ui.dart';
import '../view_model/progress_tab_view_model.dart';
import 'progress_tab_detail_ui_extensions.dart';

extension ProgressTabUiExtensions on BuildContext {
  Widget progressLoadErrorView({
    required String message,
    required VoidCallback onRetry,
  }) {
    final colors = appColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message,
          style: AppTypography.bodyMRegular.copyWith(
            color: colors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        AppTextButton(text: l10n.homeRetry, onPressed: onRetry),
      ],
    ).paddingAll(24).center();
  }

  Widget progressNoChildView() {
    return Text(
      l10n.progressNoChildSelected,
      style: AppTypography.bodyMRegular.copyWith(
        color: appColors.textSecondary,
      ),
      textAlign: TextAlign.center,
    ).paddingAll(24).center().safeArea();
  }

  Widget progressTabBody({
    required ProgressTabViewModel viewModel,
    required Future<void> Function() onRefresh,
    required ValueChanged<ProgressPeriod> onPeriodTap,
    required VoidCallback onCalendarTap,
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
        children: [
          progressHeaderSection(
            viewModel: viewModel,
            onCalendarTap: onCalendarTap,
          ),
          const SizedBox(height: 12),
          if (viewModel.periods.isNotEmpty)
            progressPeriodSelector(
              viewModel: viewModel,
              onPeriodTap: onPeriodTap,
            ).paddingOnly(left: 16, right: 16),
          if (viewModel.isDetailLoading) ...[
            const SizedBox(height: 12),
            LinearProgressIndicator(
              minHeight: 3,
              backgroundColor: colors.bgSoft,
              valueColor: AlwaysStoppedAnimation<Color>(colors.accent),
            ),
          ],
          const SizedBox(height: 12),
          if (guide == null)
            Text(
              l10n.progressNoDetails,
              style: AppTypography.bodyMRegular.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ).paddingAll(16).center()
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                progressSummaryCard(viewModel: viewModel, guide: guide),
                const SizedBox(height: 12),
                progressExercisesCard(guide: guide),
                const SizedBox(height: 12),
                progressSuggestionsSection(
                  name: child.name,
                  suggestions: guide.suggestions,
                ),
                const SizedBox(height: 12),
                progressRecommendationsSection(
                  name: child.name,
                  recommendations: guide.recommendations,
                ),
              ],
            ).paddingOnly(left: 16, right: 16),
          const SizedBox(height: 20),
        ],
      ),
    ).container(color: colors.bgSecondary);
  }

  Widget progressHeaderSection({
    required ProgressTabViewModel viewModel,
    required VoidCallback onCalendarTap,
  }) {
    final colors = appColors;
    final child = viewModel.activeChild!;
    final guide = viewModel.guide;
    final callout =
        guide?.crisisWarning ??
        guide?.headline ??
        guide?.summary ??
        l10n.progressDefaultCallout;

    return Column(
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
                          size: 18,
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
                    .paddingSymmetric(horizontal: 10, vertical: 8)
                    .inkWell(
                      onTap: onCalendarTap,
                      borderRadius: BorderRadius.circular(10),
                    ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _progressAvatarPlaceholder(child.gender),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          child.name,
                          style: AppTypography.headingS.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                        Text(
                          child.ageDisplay,
                          style: AppTypography.bodyMRegular.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ).expanded(),
                const SizedBox(width: 10),
                Text(
                  callout,
                  style: AppTypography.bodyMRegular.copyWith(
                    color: colors.textPrimary,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ).container(
                  constraints: const BoxConstraints(
                    minHeight: 44,
                    maxWidth: 200,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.bgPrimary,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: colors.border),
                  ),
                ),
              ],
            ),
          ],
        )
        .paddingOnly(left: 16, right: 16, top: 14, bottom: 14)
        .safeArea(bottom: false)
        .container(color: colors.bgSoft);
  }

  Widget progressPeriodSelector({
    required ProgressTabViewModel viewModel,
    required ValueChanged<ProgressPeriod> onPeriodTap,
  }) {
    final childBirthDate = viewModel.childBirthDate;
    if (childBirthDate == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 96,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
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

    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              progressPeriodTitle(period),
              style: AppTypography.bodyLMedium.copyWith(
                color: isSelected ? colors.accent : colors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              progressPeriodDateLabel(period: period, birthDate: birthDate),
              style: AppTypography.bodySRegular.copyWith(
                color: isSelected ? colors.accent : colors.textSecondary,
              ),
            ),
          ],
        )
        .container(
          width: 136,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: colors.bgPrimary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? colors.accent : colors.border,
              width: isSelected ? 1.5 : 1,
            ),
          ),
        )
        .inkWell(onTap: onTap, borderRadius: BorderRadius.circular(16));
  }

  Widget _progressAvatarPlaceholder(Gender gender) {
    final colors = appColors;

    final backgroundColor = switch (gender) {
      Gender.boy => colors.iconBoy.withValues(alpha: 0.16),
      Gender.girl => colors.iconGirl.withValues(alpha: 0.16),
      _ => colors.bgSecondary,
    };

    final iconColor = switch (gender) {
      Gender.boy => colors.iconBoy,
      Gender.girl => colors.iconGirl,
      _ => colors.textSecondary,
    };

    return Icon(
      Icons.child_care,
      color: iconColor,
      size: 24,
    ).center().container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
    );
  }
}
