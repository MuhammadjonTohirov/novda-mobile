part of '../home_screen.dart';

class _RemindersList extends StatelessWidget {
  const _RemindersList({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final reminders = viewModel.recentReminders.take(2).toList();

    if (reminders.isEmpty) {
      final colors = context.appColors;

      return Text(
        context.l10n.homeNoReminders,
        style: AppTypography.bodyMRegular.copyWith(color: colors.textSecondary),
        textAlign: TextAlign.center,
      ).container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 22),
        decoration: BoxDecoration(
          color: colors.bgSecondary,
          borderRadius: BorderRadius.circular(18),
        ),
      );
    }

    return Column(
      children: reminders
          .map(
            (reminder) => _ReminderTile(
              reminder: reminder,
              isUpdating: viewModel.isUpdatingReminder(reminder.id),
              onCheckTap: () => viewModel.completeReminder(reminder.id),
            ).paddingOnly(bottom: 12),
          )
          .toList(),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({
    required this.reminder,
    required this.isUpdating,
    required this.onCheckTap,
  });

  final Reminder reminder;
  final bool isUpdating;
  final VoidCallback onCheckTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final isCompleted = reminder.status == ReminderStatus.completed;

    return AnimatedOpacity(
      opacity: isCompleted ? 0.62 : 1,
      duration: const Duration(milliseconds: 200),
      child:
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: isCompleted || isUpdating ? null : onCheckTap,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? colors.accent.withValues(alpha: 0.24)
                        : Colors.transparent,
                    border: Border.all(
                      color: isCompleted ? colors.accent : colors.textSecondary,
                      width: 2,
                    ),
                  ),
                  child: isUpdating
                      ? const CircularProgressIndicator(
                          strokeWidth: 2,
                        ).paddingAll(7)
                      : isCompleted
                      ? Icon(Icons.check, size: 18, color: colors.accent)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.note?.trim().isNotEmpty == true
                        ? reminder.note!.trim()
                        : l10n.homeReminderTitle(
                            reminder.activityTypeDetail.title,
                          ),
                    style: AppTypography.headingL.copyWith(
                      color: colors.textPrimary,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${_formatReminderDateTime(context, reminder.dueAt)} • ${reminder.activityTypeDetail.title}',
                    style: AppTypography.bodyLRegular.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ).expanded(),
            ],
          ).container(
            decoration: BoxDecoration(
              color: colors.bgSecondary,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: colors.border),
            ),
            padding: const EdgeInsets.all(14),
          ),
    );
  }

  String _formatReminderDateTime(BuildContext context, DateTime dateTime) {
    final local = dateTime.toLocal();
    final now = DateTime.now();

    if (_isSameDate(local, now)) {
      return '${context.l10n.today}, ${DateFormat('HH:mm').format(local)}';
    }

    final tomorrow = now.add(const Duration(days: 1));
    if (_isSameDate(local, tomorrow)) {
      return '${context.l10n.homeTomorrow}, ${DateFormat('HH:mm').format(local)}';
    }

    return DateFormat('MMM d, HH:mm').format(local);
  }

  bool _isSameDate(DateTime lhs, DateTime rhs) {
    return lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day;
  }
}

class _AddReminderButton extends StatelessWidget {
  const _AddReminderButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, size: 22, color: colors.accent),
          const SizedBox(width: 8),
          Text(
            context.l10n.homeAddReminder,
            style: AppTypography.headingS.copyWith(color: colors.accent),
          ),
        ],
      ).paddingSymmetric(vertical: 8),
    );
  }
}
