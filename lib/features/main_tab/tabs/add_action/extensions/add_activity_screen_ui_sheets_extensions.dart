import 'package:flutter/material.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/ui/ui.dart';
import 'add_activity_screen_ui_common_extensions.dart';

extension AddActivityScreenUiSheetsExtensions on BuildContext {
  Widget addActivityQualitySheet({
    required Quality? selected,
    required ValueChanged<Quality> onSelect,
  }) {
    return AppBottomSheetContent(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      children: [
        _addActivityOptionTile(
          title: addActivityQualityLabel(Quality.bad),
          icon: addActivityQualityBadIcon(),
          selected: selected == Quality.bad,
          onTap: () => onSelect(Quality.bad),
        ),
        _addActivityOptionTile(
          title: addActivityQualityLabel(Quality.normal),
          icon: addActivityQualityNormalIcon(),
          selected: selected == Quality.normal,
          onTap: () => onSelect(Quality.normal),
        ),
        _addActivityOptionTile(
          title: addActivityQualityLabel(Quality.good),
          icon: addActivityQualityGoodIcon(),
          selected: selected == Quality.good,
          onTap: () => onSelect(Quality.good),
        ),
      ],
    );
  }

  Widget addActivityReminderSheet({
    required List<Reminder> reminders,
    required Set<int> selectedReminderIds,
    required ValueChanged<int> onToggle,
    required VoidCallback onDone,
  }) {
    if (reminders.isEmpty) {
      return AppBottomSheetContent(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Text(
            l10n.addActivityNoReminders,
            style: AppTypography.bodyMRegular.copyWith(
              color: appColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ).paddingOnly(top: 12, bottom: 8),
        ],
      );
    }

    return AppBottomSheetContent(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      children: [
        ...reminders.map(
          (reminder) => _addActivityOptionTile(
            title: reminder.note?.trim().isNotEmpty == true
                ? reminder.note!.trim()
                : addActivityReminderFallbackTitle(
                    reminder.activityTypeDetail.title,
                  ),
            subtitle:
                '${addActivityDateTimeLabel(reminder.dueAt)} • ${reminder.activityTypeDetail.title}',
            icon: Icon(
              selectedReminderIds.contains(reminder.id)
                  ? Icons.check_circle
                  : Icons.circle_outlined,
              color: appColors.accent,
              size: 22,
            ),
            selected: selectedReminderIds.contains(reminder.id),
            onTap: () => onToggle(reminder.id),
          ),
        ),
        const SizedBox(height: 10),
        AppButton(text: l10n.addActivitySelectReminders, onPressed: onDone),
      ],
    );
  }

  Widget addActivityConditionsSheet({
    required List<ConditionType> conditions,
    required Set<String> selectedConditionSlugs,
    required ValueChanged<String> onToggle,
    required VoidCallback onDone,
  }) {
    if (conditions.isEmpty) {
      return AppBottomSheetContent(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Text(
            l10n.addActivityNoConditions,
            style: AppTypography.bodyMRegular.copyWith(
              color: appColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ).paddingOnly(top: 12, bottom: 8),
        ],
      );
    }

    return AppBottomSheetContent(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      children: [
        ...conditions.map(
          (condition) => _addActivityOptionTile(
            title: condition.name,
            icon: Icon(
              selectedConditionSlugs.contains(condition.slug)
                  ? Icons.check_circle
                  : Icons.circle_outlined,
              color: appColors.accent,
              size: 22,
            ),
            selected: selectedConditionSlugs.contains(condition.slug),
            onTap: () => onToggle(condition.slug),
          ),
        ),
        const SizedBox(height: 10),
        AppButton(text: l10n.continueButton, onPressed: onDone),
      ],
    );
  }

  Widget _addActivityOptionTile({
    required String title,
    Widget? icon,
    String? subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final colors = appColors;

    return Row(
          children: [
            if (icon != null) ...[icon, const SizedBox(width: 12)],
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyLMedium.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.bodyMRegular.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ],
            ).expanded(),
            if (selected)
              Icon(Icons.check_rounded, color: colors.accent, size: 24),
          ],
        )
        .container(
          decoration: BoxDecoration(
            color: selected ? colors.bgSecondary : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        )
        .inkWell(onTap: onTap, borderRadius: BorderRadius.circular(14));
  }
}
