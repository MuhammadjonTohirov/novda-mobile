import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../core/extensions/extensions.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/ui/ui.dart';

extension ChildDetailsScreenUiSheetsExtensions on BuildContext {
  Future<String?> showChildDetailsMetricEditorSheet({
    required String title,
    required String initialValue,
  }) {
    final controller = TextEditingController(text: initialValue);
    final formatter = FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'));

    return AppBottomSheet.show<String>(
      context: this,
      showDragHandle: true,
      title: title,
      child: Builder(
        builder: (sheetContext) {
          return AppBottomSheetContent(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [formatter],
                style: AppTypography.bodyLRegular.copyWith(
                  color: sheetContext.appColors.textPrimary,
                ),
                decoration: InputDecoration(
                  labelText: title,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
              ),
              16.h,
              AppButton(
                text: sheetContext.l10n.addActivitySave,
                onPressed: () =>
                    Navigator.of(sheetContext).pop(controller.text.trim()),
              ),
            ],
          );
        },
      ),
    );
  }
}
