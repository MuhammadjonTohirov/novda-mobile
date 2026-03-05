import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../core/extensions/extensions.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/ui/ui.dart';
import '../models/body_measurement_entry.dart';

enum BodyMeasurementItemAction { edit, delete }

class BodyMeasurementEditDraft {
  const BodyMeasurementEditDraft({
    required this.weightInput,
    required this.heightInput,
  });

  final String weightInput;
  final String heightInput;
}

extension BodyMeasurementsScreenUiSheetsExtensions on BuildContext {
  Future<BodyMeasurementItemAction?> showBodyMeasurementItemActionsSheet() {
    final colors = appColors;

    return AppBottomSheet.show<BodyMeasurementItemAction>(
      context: this,
      title: l10n.bodyMeasurementsActions,
      showDragHandle: true,
      child: AppBottomSheetContent(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
        children: [
          AppListTile(
            title: l10n.bodyMeasurementsEdit,
            leading: Image.asset(
              'assets/images/icon_edit.png',
              color: colors.textSecondary,
            ).center().sized(width: 24, height: 24),

            onTap: () => Navigator.of(this).pop(BodyMeasurementItemAction.edit),
          ),
          AppListTile(
            title: l10n.bodyMeasurementsDeleteEntry,
            leading: Image.asset(
              'assets/images/icon_trash.png',
              color: colors.error,
            ).center().sized(width: 24, height: 24),
            onTap: () =>
                Navigator.of(this).pop(BodyMeasurementItemAction.delete),
          ),
        ],
      ),
    );
  }

  Future<BodyMeasurementEditDraft?> showBodyMeasurementEditSheet({
    required BodyMeasurementEntry entry,
  }) {
    final weightController = TextEditingController(
      text: _formatMeasurementValue(entry.weight?.value),
    );
    final heightController = TextEditingController(
      text: _formatMeasurementValue(entry.height?.value),
    );
    final formatter = FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'));

    return AppBottomSheet.show<BodyMeasurementEditDraft>(
      context: this,
      title: l10n.bodyMeasurementsEditTitle,
      showDragHandle: true,
      child: Builder(
        builder: (sheetContext) {
          return AppBottomSheetContent(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            children: [
              TextField(
                controller: weightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [formatter],
                style: AppTypography.bodyLRegular.copyWith(
                  color: sheetContext.appColors.textPrimary,
                ),
                decoration: InputDecoration(
                  labelText: sheetContext.l10n.weightInKg,
                ),
              ),
              12.h,
              TextField(
                controller: heightController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [formatter],
                style: AppTypography.bodyLRegular.copyWith(
                  color: sheetContext.appColors.textPrimary,
                ),
                decoration: InputDecoration(
                  labelText: sheetContext.l10n.heightInCm,
                ),
              ),
              16.h,
              AppButton(
                text: sheetContext.l10n.addActivitySave,
                onPressed: () {
                  Navigator.of(sheetContext).pop(
                    BodyMeasurementEditDraft(
                      weightInput: weightController.text.trim(),
                      heightInput: heightController.text.trim(),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Future<bool> showBodyMeasurementDeleteSheet() async {
    final result = await AppBottomSheet.show<bool>(
      context: this,
      showDragHandle: true,
      child: Builder(
        builder: (sheetContext) {
          final colors = sheetContext.appColors;

          return AppBottomSheetContent(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                sheetContext.l10n.bodyMeasurementsDeleteTitle,
                style: AppTypography.headingM.copyWith(
                  color: colors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              8.h,
              Text(
                sheetContext.l10n.bodyMeasurementsDeleteDescription,
                style: AppTypography.bodyMRegular.copyWith(
                  color: colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              18.h,
              Row(
                children: [
                  AppButton(
                    text: sheetContext.l10n.settingsCancel,
                    variant: AppButtonVariant.cancel,
                    onPressed: () => Navigator.of(sheetContext).pop(false),
                  ).expanded(),
                  12.w,
                  AppButton(
                    text: sheetContext.l10n.settingsDelete,
                    variant: AppButtonVariant.delete,
                    onPressed: () => Navigator.of(sheetContext).pop(true),
                  ).expanded(),
                ],
              ),
            ],
          );
        },
      ),
    );

    return result == true;
  }

  String _formatMeasurementValue(double? value) {
    if (value == null) return '';
    final fixed = value.toStringAsFixed(2);
    return fixed.replaceFirst(RegExp(r'\.?0+$'), '');
  }
}
