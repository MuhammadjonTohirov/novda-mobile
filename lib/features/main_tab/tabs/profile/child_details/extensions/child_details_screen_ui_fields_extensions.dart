import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../../core/extensions/extensions.dart';
import '../../../../../../core/theme/app_theme.dart';

extension ChildDetailsScreenUiFieldsExtensions on BuildContext {
  Widget childDetailsInputCard({
    required String label,
    required TextEditingController controller,
    ValueChanged<String>? onChanged,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
    bool readOnly = false,
    bool hasError = false,
  }) {
    final colors = appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodyLMedium.copyWith(
            color: colors.textSecondary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        2.h,
        TextField(
          controller: controller,
          onChanged: onChanged,
          readOnly: readOnly,
          showCursor: !readOnly,
          enableInteractiveSelection: !readOnly,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLength: maxLength,
          style: AppTypography.headingM.copyWith(color: colors.textPrimary),
          decoration: const InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            counterText: '',
            isDense: true,
          ),
        ),
      ],
    ).container(
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: hasError ? colors.error : Colors.transparent),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget childDetailsValueCard({
    required String label,
    required String value,
    Widget? trailing,
    bool hasError = false,
  }) {
    final colors = appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodyLMedium.copyWith(
            color: colors.textSecondary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        8.h,
        Row(
          children: [
            Text(
              value.isEmpty ? '-' : value,
              style: AppTypography.headingM.copyWith(color: colors.textPrimary),
              overflow: TextOverflow.ellipsis,
            ).expanded(),
            if (trailing != null) trailing,
          ],
        ),
      ],
    ).container(
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: hasError ? colors.error : Colors.transparent),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget childDetailsParameterCard({
    required String label,
    required String value,
    required VoidCallback onEditTap,
    bool hasError = false,
  }) {
    final colors = appColors;

    return childDetailsValueCard(
      label: label,
      value: value,
      hasError: hasError,
      trailing: IconButton(
        onPressed: onEditTap,
        icon: Icon(Icons.edit_outlined, color: colors.textSecondary),
        splashRadius: 22,
      ),
    );
  }

  Widget childDetailsGenderCard({
    required Gender gender,
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    final colors = appColors;
    final iconColor = switch (gender) {
      Gender.boy => colors.iconBoy,
      Gender.girl => colors.iconGirl,
      _ => colors.textSecondary,
    };

    final title = switch (gender) {
      Gender.boy => l10n.boy,
      Gender.girl => l10n.girl,
      _ => l10n.homeUndisclosed,
    };

    final card =
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              child: Image.asset(gender.iconAsset, width: 28, height: 28),
            ),
            12.h,
            Text(
              title,
              style: AppTypography.bodyMSemiBold.copyWith(color: colors.textPrimary),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ).container(
          height: 100,
          decoration: BoxDecoration(
            color: isSelected
                ? colors.bgSoft.withValues(alpha: 0.45)
                : colors.bgPrimary,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: colors.border),
          ),
        );
    if (onTap == null) return card;

    return card.inkWell(onTap: onTap, borderRadius: BorderRadius.circular(28));
  }
}
