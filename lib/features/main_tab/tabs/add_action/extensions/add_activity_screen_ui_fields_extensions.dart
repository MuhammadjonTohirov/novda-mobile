import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/ui/ui.dart';
import '../view_model/add_activity_view_model.dart';
import 'add_activity_screen_ui_common_extensions.dart';

const _iconCalendar = 'assets/images/others/icon_calendar.png';

extension AddActivityScreenUiFieldsExtensions on BuildContext {
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
      trailing: addActivityAssetIcon(_iconCalendar, size: 28),
      child: _addActivityFieldText(
        label: label,
        value: value == null ? null : addActivityDateTimeLabel(value),
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
}
