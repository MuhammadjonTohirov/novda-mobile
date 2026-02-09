// create a custom checkbox widget that can be used across the app
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Custom checkbox widget with label
///

class AppCheckbox extends StatelessWidget {
  const AppCheckbox({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return InkWell(
      onTap: () => onChanged(!value),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: value ? Colors.black12 : Colors.transparent,
          border: Border.all(color: value ? Colors.transparent : Colors.black12, width: value ? 0 : 1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: value
            ? Icon(Icons.check, size: 16, color: colors.textPrimary)
            : null,
      ),
    );
  }
}
