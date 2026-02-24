import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/ui/ui.dart';
import '../view_model/add_activity_view_model.dart';

const _iconCalendar = 'assets/images/others/icon_calendar.png';
const _iconKid = 'assets/images/others/icon_kid.png';
const _iconThumbsUp = 'assets/images/others/icon_thumbs-up.png';
const _iconThumbsDown = 'assets/images/others/icon_thumbs-down.png';
const _iconNotification = 'assets/images/others/iocon_notification_large.png';

extension AddActivityScreenUiExtensions on BuildContext {
  Widget addActivitySegmentedFeedingType(AddActivityViewModel viewModel) {
    final colors = appColors;

    return CupertinoSlidingSegmentedControl<FeedingType>(
      groupValue: viewModel.feedingType,
      backgroundColor: colors.bgSecondary,
      thumbColor: colors.bgPrimary,
      children: {
        FeedingType.breast: Text(
          l10n.addActivityFeedingBreast,
          style: AppTypography.bodyMMedium.copyWith(color: colors.textPrimary),
          textAlign: TextAlign.center,
        ).paddingSymmetric(vertical: 6, horizontal: 8),
        FeedingType.bottle: Text(
          l10n.addActivityFeedingBottle,
          style: AppTypography.bodyMMedium.copyWith(color: colors.textPrimary),
          textAlign: TextAlign.center,
        ).paddingSymmetric(vertical: 6, horizontal: 8),
      },
      onValueChanged: (value) {
        if (value == null) return;
        viewModel.setFeedingType(value);
      },
    );
  }

  Widget addActivityDateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
    bool hasError = false,
  }) {
    return _addActivityFieldShell(
      hasError: hasError,
      onTap: onTap,
      trailing: _addActivityAssetIcon(_iconCalendar, size: 28),
      child: _addActivityFieldText(
        label: label,
        value: value == null ? null : _addActivityDateTimeLabel(value),
      ),
    );
  }

  Widget addActivitySelectField({
    required String label,
    String? value,
    required VoidCallback onTap,
    Widget? trailing,
    bool hasError = false,
  }) {
    final colors = appColors;

    return _addActivityFieldShell(
      hasError: hasError,
      onTap: onTap,
      trailing:
          trailing ??
          Icon(Icons.keyboard_arrow_down_rounded, color: colors.accent),
      child: _addActivityFieldText(label: label, value: value),
    );
  }

  Widget addActivityCommentsField({
    required String label,
    required String initialValue,
    required ValueChanged<String> onChanged,
  }) {
    final colors = appColors;

    return AppTextField(
      label: label,
      onChanged: onChanged,
      initialValue: initialValue,
      hint: label,
      maxLines: 6,
      showFocusBorder: false,
      showClearButton: false,
    ).container(
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Widget addActivityAmountField({
    required String label,
    required String initialValue,
    required ValueChanged<String> onChanged,
    bool hasError = false,
  }) {
    final colors = appColors;

    return AppTextField(
      label: label,
      initialValue: initialValue,
      hint: label,
      keyboardType: TextInputType.number,
      errorText: hasError ? l10n.addActivityValidationAmount : null,
      onChanged: onChanged,
      showFocusBorder: false,
      showClearButton: false,
    ).container(
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Widget addActivityQualitySheet({
    required Quality? selected,
    required ValueChanged<Quality> onSelect,
  }) {
    return AppBottomSheetContent(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      children: [
        _addActivityOptionTile(
          title: addActivityQualityLabel(Quality.bad),
          icon: _addActivityAssetIcon(_iconThumbsDown, size: 24),
          selected: selected == Quality.bad,
          onTap: () => onSelect(Quality.bad),
        ),
        _addActivityOptionTile(
          title: addActivityQualityLabel(Quality.normal),
          icon: _addActivityAssetIcon(_iconThumbsUp, size: 24),
          selected: selected == Quality.normal,
          onTap: () => onSelect(Quality.normal),
        ),
        _addActivityOptionTile(
          title: addActivityQualityLabel(Quality.good),
          icon: _addActivityAssetIcon(_iconKid, size: 24),
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
                '${_addActivityDateTimeLabel(reminder.dueAt)} • ${reminder.activityTypeDetail.title}',
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

  String addActivityQualityLabel(Quality quality) {
    return switch (quality) {
      Quality.good => l10n.addActivityQualityGood,
      Quality.normal => l10n.addActivityQualityNormal,
      Quality.bad => l10n.addActivityQualityBad,
    };
  }

  String addActivityReminderFallbackTitle(String activityTitle) {
    return l10n.homeReminderTitle(activityTitle);
  }

  String addActivitySelectedCountLabel(int count) {
    return l10n.addActivitySelectedCount(count);
  }

  String addActivityConditionsCountLabel(int count) {
    return l10n.addActivityConditionsCount(count);
  }

  Widget _addActivityFieldShell({
    required Widget child,
    required Widget trailing,
    required VoidCallback onTap,
    bool hasError = false,
  }) {
    final colors = appColors;

    return Row(
          children: [child.expanded(), const SizedBox(width: 12), trailing],
        )
        .container(
          decoration: BoxDecoration(
            color: colors.bgSecondary,
            borderRadius: BorderRadius.circular(12),
            border: hasError ? Border.all(color: colors.error) : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        )
        .inkWell(onTap: onTap, borderRadius: BorderRadius.circular(12));
  }

  Widget _addActivityFieldText({required String label, String? value}) {
    final colors = appColors;
    final hasValue = value?.trim().isNotEmpty == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodyMRegular.copyWith(
            color: colors.textSecondary,
          ),
        ),
        if (hasValue) ...[
          const SizedBox(height: 4),
          Text(
            value!,
            style: AppTypography.bodyLMedium.copyWith(
              color: colors.textPrimary,
            ),
          ),
        ],
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

  Widget addActivityQualityFieldIcon() =>
      _addActivityAssetIcon(_iconKid, size: 28);

  Widget addActivityReminderFieldIcon() =>
      _addActivityAssetIcon(_iconNotification, size: 28);

  Widget _addActivityAssetIcon(String assetPath, {double size = 24}) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }

  String _addActivityDateTimeLabel(DateTime dateTime) {
    return DateFormat('MMM d, HH:mm').format(dateTime.toLocal());
  }
}
