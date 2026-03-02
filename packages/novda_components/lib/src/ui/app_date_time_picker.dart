import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../extensions/widget_extensions.dart';
import '../theme/app_theme.dart';

/// Cupertino-style date-time picker helper with Novda styling.
class AppDateTimePicker {
  AppDateTimePicker._();

  static const double _defaultHeight = 320;

  static Future<DateTime?> show({
    required BuildContext context,
    required DateTime initialDateTime,
    required String cancelText,
    required String confirmText,
    CupertinoDatePickerMode mode = CupertinoDatePickerMode.dateAndTime,
    bool use24hFormat = true,
    DateTime? minimumDate,
    DateTime? maximumDate,
    int minuteInterval = 1,
    double height = _defaultHeight,
    bool safeAreaTop = false,
    bool safeAreaBottom = true,
  }) {
    DateTime selected = initialDateTime;

    return showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (sheetContext) {
        final colors = sheetContext.appColors;

        return Container(
          height: height,
          decoration: BoxDecoration(
            color: colors.bgPrimary,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CupertinoButton(
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    child: Text(cancelText),
                  ),
                  const Spacer(),
                  CupertinoButton(
                    onPressed: () => Navigator.of(sheetContext).pop(selected),
                    child: Text(confirmText),
                  ),
                ],
              ).paddingSymmetric(horizontal: 8),
              const Divider(height: 1),
              Expanded(
                child: CupertinoDatePicker(
                  mode: mode,
                  use24hFormat: use24hFormat,
                  initialDateTime: initialDateTime,
                  minimumDate: minimumDate,
                  maximumDate: maximumDate,
                  minuteInterval: minuteInterval,
                  onDateTimeChanged: (value) {
                    selected = value;
                  },
                ),
              ),
            ],
          ),
        ).safeArea(top: safeAreaTop, bottom: safeAreaBottom);
      },
    );
  }
}
