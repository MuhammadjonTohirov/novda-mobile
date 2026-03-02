import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../../core/extensions/extensions.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/ui/ui.dart';
import '../view_model/reminders_view_model.dart';

const _iconReminder = 'assets/images/others/icon_list_reminder.png';

extension RemindersScreenUiListExtensions on BuildContext {
  Widget remindersListCard({
    required RemindersViewModel viewModel,
    required ValueChanged<int> onReminderCheckTap,
    required VoidCallback onAddReminderTap,
  }) {
    final colors = appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              l10n.homeReminders,
              style: AppTypography.headingS.copyWith(color: colors.textPrimary),
            ).expanded(),
            Text(
              l10n.remindersCount(viewModel.selectedDayReminders.length),
              style: AppTypography.bodyLRegular.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (viewModel.isRefreshingDayReminders)
          const CircularProgressIndicator().center().paddingOnly(
            top: 8,
            bottom: 8,
          )
        else if (!viewModel.hasReminders)
          _remindersEmptyState(onAddReminderTap)
        else
          Column(
            children: [
              ...viewModel.selectedDayReminders.map(
                (reminder) => _reminderListItem(
                  reminder: reminder,
                  onCheckTap: () => onReminderCheckTap(reminder.id),
                ).paddingOnly(bottom: 10),
              ),
              const SizedBox(height: 4),
              remindersAddButton(onTap: onAddReminderTap),
            ],
          ),
      ],
    ).container(
      decoration: BoxDecoration(
        color: colors.bgPrimary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
    );
  }

  Widget remindersAddButton({required VoidCallback onTap}) {
    final colors = appColors;

    return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 24, color: colors.accent),
            const SizedBox(width: 8),
            Text(
              l10n.homeAddReminder,
              style: AppTypography.headingXS.copyWith(color: colors.accent),
            ),
          ],
        )
        .paddingSymmetric(vertical: 8)
        .inkWell(onTap: onTap, borderRadius: BorderRadius.circular(12));
  }

  Widget _remindersEmptyState(VoidCallback onAddReminderTap) {
    final colors = appColors;

    return Column(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(colors.accent, BlendMode.srcIn),
          child: Image.asset(
            _iconReminder,
            width: 24,
            height: 24,
            fit: BoxFit.contain,
          ).center(),
        ).container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: colors.bgSecondary,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.remindersNoRemindersTitle,
          style: AppTypography.headingS.copyWith(color: colors.textPrimary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          l10n.remindersNoRemindersSubtitle,
          style: AppTypography.bodyLRegular.copyWith(
            color: colors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        remindersAddButton(onTap: onAddReminderTap),
      ],
    );
  }

  Widget _reminderListItem({
    required Reminder reminder,
    required VoidCallback onCheckTap,
  }) {
    final isCompleted = reminder.status == ReminderStatus.completed;

    return ReminderCard(
      title: reminder.note?.trim().isNotEmpty == true
          ? reminder.note!.trim()
          : l10n.homeReminderTitle(reminder.activityTypeDetail.title),
      dateTime: remindersDateLabel(reminder.dueAt),
      category: reminder.activityTypeDetail.title,
      isCompleted: isCompleted,
      showBackground: false,
      onCheckTap: isCompleted ? null : onCheckTap,
    ).container(
      decoration: BoxDecoration(
        color: appColors.bgSecondary,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  String remindersDateLabel(DateTime dateTime) {
    final local = dateTime.toLocal();

    if (local.isToday) {
      return '${l10n.today}, ${DateFormat('HH:mm').format(local)}';
    }

    if (local.isTomorrow) {
      return '${l10n.homeTomorrow}, ${DateFormat('HH:mm').format(local)}';
    }

    return DateFormat('MMM d, HH:mm').format(local);
  }
}
