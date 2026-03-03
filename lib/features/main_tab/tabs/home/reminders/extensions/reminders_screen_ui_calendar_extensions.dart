import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../../core/extensions/extensions.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../view_model/reminders_view_model.dart';

extension RemindersScreenUiCalendarExtensions on BuildContext {
  Widget remindersCalendarCard({
    required RemindersViewModel viewModel,
    required VoidCallback onPreviousMonthTap,
    required VoidCallback onNextMonthTap,
    required ValueChanged<DateTime> onDateTap,
    required VoidCallback onExpandCollapseTap,
    required VoidCallback onTodayTap,
  }) {
    final colors = appColors;
    final isToday = viewModel.isSelectedDate(DateTime.now());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: onPreviousMonthTap,
              icon: Icon(
                Icons.chevron_left_rounded,
                color: colors.accent,
                size: 26,
              ),
              visualDensity: VisualDensity.compact,
            ),
            Text(
              DateFormat('MMM d, yyyy').format(viewModel.selectedDate),
              style: AppTypography.headingS.copyWith(color: colors.textPrimary),
              textAlign: TextAlign.center,
            ).expanded(),
            IconButton(
              onPressed: onNextMonthTap,
              icon: Icon(
                Icons.chevron_right_rounded,
                color: colors.accent,
                size: 26,
              ),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
        const SizedBox(height: 4),
        TableCalendar<void>(
          firstDay: DateTime(2000, 1, 1),
          lastDay: DateTime(2100, 12, 31),
          focusedDay: viewModel.selectedDate,
          locale: Localizations.localeOf(this).toLanguageTag(),
          calendarFormat: viewModel.isCalendarExpanded
              ? CalendarFormat.month
              : CalendarFormat.week,
          selectedDayPredicate: viewModel.isSelectedDate,
          onDaySelected: (selectedDay, focusedDay) {
            onDateTap(selectedDay);
          },
          headerVisible: false,
          startingDayOfWeek: StartingDayOfWeek.monday,
          availableGestures: AvailableGestures.none,
          daysOfWeekStyle: DaysOfWeekStyle(
            decoration: const BoxDecoration(),
            weekdayStyle: AppTypography.bodyMMedium.copyWith(
              color: colors.textSecondary,
            ),
            weekendStyle: AppTypography.bodyMMedium.copyWith(
              color: colors.textSecondary,
            ),
          ),
          calendarStyle: CalendarStyle(
            outsideDaysVisible: true,
            weekendTextStyle: AppTypography.bodyLMedium.copyWith(
              color: colors.textPrimary,
            ),
            defaultTextStyle: AppTypography.bodyLMedium.copyWith(
              color: colors.textPrimary,
            ),
            selectedTextStyle: AppTypography.bodyLMedium.copyWith(
              color: colors.textPrimary,
            ),
            selectedDecoration: BoxDecoration(
              color: colors.accent.withValues(alpha: 0.26),
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: colors.accent.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            todayTextStyle: AppTypography.bodyLMedium.copyWith(
              color: colors.accent,
            ),
            outsideTextStyle: AppTypography.bodyLMedium.copyWith(
              color: colors.textSecondary.withValues(alpha: 0.55),
            ),
            cellMargin: const EdgeInsets.all(2),
          ),
          calendarBuilders: CalendarBuilders<void>(
            markerBuilder: (_, day, __) {
              if (!viewModel.hasMarker(day)) return const SizedBox.shrink();

              return Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color: colors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            TextButton.icon(
              onPressed: onExpandCollapseTap,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              iconAlignment: IconAlignment.end,
              label: Text(
                viewModel.isCalendarExpanded
                    ? l10n.remindersCollapseCalendar
                    : l10n.remindersExpandCalendar,
                style: AppTypography.bodyLMedium.copyWith(color: colors.accent),
              ),
              icon: Icon(
                viewModel.isCalendarExpanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                color: colors.accent,
                size: 22,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: onTodayTap,
              style: TextButton.styleFrom(
                backgroundColor: colors.bgSecondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: Text(
                l10n.today,
                style: AppTypography.bodyLMedium.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ).visible(!isToday),
          ],
        ),
      ],
    ).container(
      decoration: BoxDecoration(
        color: colors.bgPrimary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
    );
  }
}
