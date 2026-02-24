import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import '../view_model/progress_tab_view_model.dart';

extension ProgressTabDetailUiExtensions on BuildContext {
  Widget progressSummaryCard({
    required ProgressTabViewModel viewModel,
    required ProgressGuide guide,
  }) {
    final colors = appColors;
    final selectedPeriod = viewModel.selectedPeriod;
    final periodLabel = selectedPeriod != null
        ? progressPeriodTitle(selectedPeriod)
        : progressPeriodTitle(
            ProgressPeriod(
              periodUnit: guide.periodUnit,
              periodIndex: guide.periodIndex,
              weekNumber: guide.weekNumber,
            ),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.progressWhatHappensIn(periodLabel),
          style: AppTypography.headingS.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: 10),
        Text(
          guide.summary ?? guide.crisisDescription ?? l10n.progressNoDetails,
          style: AppTypography.bodyMRegular.copyWith(
            color: colors.textSecondary,
          ),
        ),
      ],
    ).container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.bgPrimary,
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }

  Widget progressExercisesCard({required ProgressGuide guide}) {
    final colors = appColors;
    final items = guide.exercises;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.progressExercisesTitle,
          style: AppTypography.headingS.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: 12),
        if (items.isEmpty)
          Text(
            l10n.progressNoExercises,
            style: AppTypography.bodyMRegular.copyWith(
              color: colors.textSecondary,
            ),
          )
        else
          Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${i + 1}',
                      style: AppTypography.bodyMMedium.copyWith(
                        color: colors.accent,
                      ),
                    ).center().container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: colors.bgSoft,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _contentTitle(items[i], i),
                          style: AppTypography.bodyLMedium.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _contentDescription(items[i]),
                          style: AppTypography.bodyMRegular.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ).expanded(),
                  ],
                ),
                if (i != items.length - 1) const SizedBox(height: 12),
              ],
            ],
          ),
      ],
    ).container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.bgPrimary,
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }

  Widget progressSuggestionsSection({
    required String name,
    required List<ProgressContentItem> suggestions,
  }) {
    final colors = appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.progressSuggestionsTitle(name),
          style: AppTypography.headingS.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: 10),
        if (suggestions.isEmpty)
          Text(
            l10n.progressNoSuggestions,
            style: AppTypography.bodyMRegular.copyWith(
              color: colors.textSecondary,
            ),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < suggestions.length; i++)
                  _progressHorizontalInfoCard(
                    item: suggestions[i],
                    index: i,
                  ).paddingOnly(right: i == suggestions.length - 1 ? 0 : 10),
              ],
            ),
          ),
      ],
    );
  }

  Widget progressRecommendationsSection({
    required String name,
    required List<ProgressContentItem> recommendations,
  }) {
    final colors = appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.progressRecommendationsTitle(name),
          style: AppTypography.headingS.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: 10),
        if (recommendations.isEmpty)
          Text(
            l10n.progressNoRecommendations,
            style: AppTypography.bodyMRegular.copyWith(
              color: colors.textSecondary,
            ),
          )
        else
          Column(
            children: [
              for (var i = 0; i < recommendations.length; i++) ...[
                _progressRecommendationTile(item: recommendations[i], index: i),
                if (i != recommendations.length - 1) const SizedBox(height: 10),
              ],
            ],
          ),
      ],
    );
  }

  String progressPeriodTitle(ProgressPeriod period) {
    final number = period.weekNumber ?? period.periodIndex;

    return switch (period.periodUnit) {
      ProgressPeriodUnit.week => l10n.progressWeekNumber(number),
      ProgressPeriodUnit.month => l10n.progressMonthNumber(number),
      ProgressPeriodUnit.year => l10n.progressYearNumber(number),
      _ => l10n.progressPeriodNumber(number),
    };
  }

  String progressPeriodDateLabel({
    required ProgressPeriod period,
    required DateTime birthDate,
  }) {
    final locale = Localizations.localeOf(this).toLanguageTag();
    final birth = DateTime(birthDate.year, birthDate.month, birthDate.day);
    final periodOffset = (period.periodIndex - 1).clamp(0, 10000);

    switch (period.periodUnit) {
      case ProgressPeriodUnit.week:
        final start = birth.add(Duration(days: periodOffset * 7));
        final end = start.add(const Duration(days: 6));
        final startText = DateFormat('d MMM', locale).format(start);
        final endPattern = start.year == end.year ? 'd MMM' : 'd MMM yyyy';
        final endText = DateFormat(endPattern, locale).format(end);
        return '$startText - $endText';

      case ProgressPeriodUnit.month:
        final monthDate = DateTime(birth.year, birth.month + periodOffset);
        return DateFormat('MMMM, yyyy', locale).format(monthDate);

      case ProgressPeriodUnit.year:
        final yearDate = DateTime(birth.year + periodOffset);
        return DateFormat('yyyy', locale).format(yearDate);

      case ProgressPeriodUnit.custom:
      case ProgressPeriodUnit.unknown:
        if (period.ageStartDays != null && period.ageEndDays != null) {
          return l10n.progressDayRange(
            period.ageStartDays!,
            period.ageEndDays!,
          );
        }
        return period.dateRange ?? '';
    }
  }

  Widget _progressHorizontalInfoCard({
    required ProgressContentItem item,
    required int index,
  }) {
    final colors = appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.auto_awesome, size: 18, color: colors.accent),
        const SizedBox(height: 8),
        Text(
          _contentTitle(item, index),
          style: AppTypography.bodyLMedium.copyWith(color: colors.textPrimary),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Text(
          _contentDescription(item),
          style: AppTypography.bodyMRegular.copyWith(
            color: colors.textSecondary,
          ),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ).container(
      width: 160,
      padding: const EdgeInsets.all(12.5),
      decoration: BoxDecoration(
        color: colors.bgPrimary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border.withValues(alpha: 0.6)),
      ),
    );
  }

  Widget _progressRecommendationTile({
    required ProgressContentItem item,
    required int index,
  }) {
    final colors = appColors;
    final coverImage = _contentImage(item);
    final metaText = _contentMeta(item);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _contentTitle(item, index),
                  style: AppTypography.bodyLMedium.copyWith(
                    color: colors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _contentDescription(item),
                  style: AppTypography.bodyMRegular.copyWith(
                    color: colors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ).expanded(),
            if (coverImage != null) ...[
              const SizedBox(width: 10),
              Image.network(
                coverImage,
                width: 82,
                height: 54,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Icon(
                    Icons.image_outlined,
                    color: colors.textSecondary,
                    size: 18,
                  ).center().container(
                    width: 82,
                    height: 54,
                    decoration: BoxDecoration(
                      color: colors.bgSecondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (metaText.isNotEmpty)
              Text(
                metaText,
                style: AppTypography.bodySRegular.copyWith(
                  color: colors.textSecondary,
                ),
              ).expanded()
            else
              const SizedBox().expanded(),
            Icon(
              Icons.bookmark_border_rounded,
              color: colors.tabDisabled,
              size: 18,
            ),
          ],
        ),
      ],
    ).container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.bgPrimary,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border.withValues(alpha: 0.6)),
      ),
    );
  }

  String _contentTitle(ProgressContentItem item, int index) {
    final title = item.title?.trim();
    if (title != null && title.isNotEmpty) return title;
    return l10n.progressItemFallback(index + 1);
  }

  String _contentDescription(ProgressContentItem item) {
    final description = item.description?.trim();
    if (description != null && description.isNotEmpty) return description;
    return '';
  }

  String _contentMeta(ProgressContentItem item) {
    final subtitle = _dataString(
      item,
      keys: const ['subtitle', 'meta', 'stats', 'caption'],
    );
    if (subtitle != null) return subtitle;

    final duration = _dataString(
      item,
      keys: const ['duration', 'read_time', 'reading_time'],
    );
    final views = _dataString(item, keys: const ['views', 'view_count']);

    if (duration != null && views != null) return '$duration · $views';
    return duration ?? views ?? '';
  }

  String? _contentImage(ProgressContentItem item) {
    return _dataString(
      item,
      keys: const [
        'image',
        'image_url',
        'thumbnail',
        'thumbnail_url',
        'cover',
        'cover_url',
      ],
    );
  }

  String? _dataString(ProgressContentItem item, {required List<String> keys}) {
    for (final key in keys) {
      final raw = item.data[key];
      final value = raw?.toString().trim();
      if (value != null && value.isNotEmpty) return value;
    }
    return null;
  }
}
