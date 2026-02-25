import 'package:flutter/material.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import '../view_model/progress_tab_view_model.dart';
import 'progress_tab_detail_ui_extensions.dart';
import 'progress_tab_ui_no_child_extensions.dart';

extension ProgressTabUiBodyExtensions on BuildContext {
  static const double _heroBackgroundHeight = 400;
  static const double _heroWithPeriodsHeight = 350;
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
    final hasPeriods = viewModel.periods.isNotEmpty;
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
          ).container(height: _heroWithPeriodsHeight, clipBehavior: Clip.none),

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
                Column(
                  children: [
                    const SizedBox(height: 10),

                    if (hasPeriods)
                      progressPeriodSelector(
                        viewModel: viewModel,
                        onPeriodTap: onPeriodTap,
                        controller: periodScrollController,
                      ),

                    const SizedBox(height: 12),
                  ],
                ).container(
                  decoration: BoxDecoration(
                    color: appColors.bgSoft,
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),

                Stack(
                  children: [
                    Container(
                      height: 24,
                      decoration: BoxDecoration(
                        color: appColors.bgSoft,
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    Column(
                      children: [
                        progressSummaryCard(
                          viewModel: viewModel,
                          guide: guide,
                        ).paddingOnly(left: 16, right: 16),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ],
                ),

                progressExercisesCard(
                  guide: guide,
                ).paddingOnly(left: 16, right: 16),
                const SizedBox(height: 12),
                progressSuggestionsSection(
                  name: child.name,
                  suggestions: guide.suggestions,
                ).paddingOnly(left: 16, right: 16),
                const SizedBox(height: 12),
                progressRecommendationsSection(
                  name: child.name,
                  recommendations: viewModel.recommendedArticles,
                ).paddingOnly(left: 16, right: 16),
              ],
            ),
          const SizedBox(height: 20),
        ],
      ), //.paddingOnly(top: 20),
    ).container(color: colors.bgSecondary);
  }

  Widget progressHeroSection({
    required ProgressTabViewModel viewModel,
    required VoidCallback onCalendarTap,
  }) {
    final child = viewModel.activeChild!;
    final guide = viewModel.guide;
    final callout = _progressCallout(guide);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        _progressTopBackground(calloutText: callout, gender: child.gender),
        _progressHeroForeground(
          childName: child.name,
          childAge: child.ageDisplay,
          onCalendarTap: onCalendarTap,
        ),
      ],
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

    return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              progressPeriodTitle(period),
              style: AppTypography.bodyMMedium.copyWith(
                color: isSelected ? colors.accent : colors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              progressPeriodDateLabel(period: period, birthDate: birthDate),
              style: AppTypography.bodySRegular.copyWith(
                color: isSelected ? colors.accent : colors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        )
        .container(
          width: 110,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.bgPrimary.withAlpha(230)
                : colors.bgPrimary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? colors.accent.withValues(alpha: 0.6)
                  : colors.border,
            ),
            boxShadow: [
              BoxShadow(
                color: colors.textPrimary.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        )
        .inkWell(onTap: onTap, borderRadius: BorderRadius.circular(16));
  }

  String _progressCallout(ProgressGuide? guide) {
    return guide?.crisisWarning ??
        guide?.headline ??
        guide?.summary ??
        l10n.progressDefaultCallout;
  }

  Widget _progressHeroForeground({
    required String childName,
    required String childAge,
    required VoidCallback onCalendarTap,
  }) {
    final colors = appColors;

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
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                childName,
                style: AppTypography.bodyLMedium.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              Text(
                childAge,
                style: AppTypography.bodyMRegular.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ).paddingOnly(left: 16, right: 16, top: 10),
    );
  }

  Widget _progressTopBackground({
    required String calloutText,
    required Gender gender,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _progressKidWithToysBackground(gender: gender),
        _progressQuoteBubble(
          text: calloutText,
          isBoy: gender != Gender.girl,
        ).positioned(right: 16, top: 128),
      ],
    );
  }

  Widget _progressKidWithToysBackground({required Gender gender}) {
    final babyAsset = switch (gender) {
      Gender.girl => 'assets/images/image_girl_with_toys.png',
      _ => 'assets/images/image_kid_with_toys.png',
    };

    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/image_dots.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(color: appColors.bgSoft),
            height: 100,
          ).paddingOnly(top: _heroBackgroundHeight - 105),
          Image.asset(babyAsset, fit: BoxFit.contain).paddingOnly(top: 210),
        ],
      ),
    );
  }

  Widget _progressQuoteBubble({required String text, required bool isBoy}) {
    final quoteAsset = isBoy
        ? 'assets/images/img_quote_baby_boy.png'
        : 'assets/images/img_quote_baby_girl.png';

    return Stack(
      children: [
        Image.asset(quoteAsset, fit: BoxFit.cover),
        Text(
          text,
          style: AppTypography.bodySRegular,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
        ).paddingOnly(left: 12, right: 8, top: 8, bottom: 10),
      ],
    ).sized(width: 180, height: 100);
  }
}
