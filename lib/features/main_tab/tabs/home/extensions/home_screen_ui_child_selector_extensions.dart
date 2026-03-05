import 'package:flutter/material.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/ui/ui.dart';

extension HomeScreenUiChildSelectorExtensions on BuildContext {
  Future<int?> showHomeChildSelectorSheet({
    required List<ChildListItem> children,
    required int? selectedChildId,
  }) {
    if (children.isEmpty) {
      return Future.value(null);
    }

    var draftSelectedId = selectedChildId ?? children.first.id;

    return AppBottomSheet.show<int>(
      context: this,
      showDragHandle: true,
      child: StatefulBuilder(
        builder: (sheetContext, setState) {
          return AppBottomSheetContent(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            children: [
              Text(
                sheetContext.l10n.yourChildren,
                style: AppTypography.headingL.copyWith(
                  color: sheetContext.appColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              6.h,
              Text(
                sheetContext.l10n.whichChildToSelect,
                style: AppTypography.bodyLRegular.copyWith(
                  color: sheetContext.appColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              16.h,
              for (var i = 0; i < children.length; i++) ...[
                _homeChildSelectionTile(
                  child: children[i],
                  isSelected: draftSelectedId == children[i].id,
                  onTap: () => setState(() => draftSelectedId = children[i].id),
                ),
                if (i != children.length - 1) 10.h,
              ],
              16.h,
              AppButton(
                text: sheetContext.l10n.continueButton,
                onPressed: () =>
                    Navigator.of(sheetContext).pop(draftSelectedId),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _homeChildSelectionTile({
    required ChildListItem child,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colors = appColors;

    return Row(
          children: [
            Image.asset(
              child.gender.avatarAssetByAgeInWeeks(child.ageInWeeks),
              width: 44,
              height: 44,
            ),
            12.w,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  child.name,
                  style: AppTypography.bodyLMedium.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                2.h,
                Text(
                  child.ageDisplay,
                  style: AppTypography.bodyLRegular.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ).expanded(),
            Icon(
              isSelected ? Icons.check : Icons.circle_outlined,
              color: isSelected ? colors.accent : colors.textSecondary,
              size: 24,
            ),
          ],
        )
        .container(
          decoration: BoxDecoration(
            color: isSelected
                ? colors.bgSoft.withValues(alpha: 0.45)
                : colors.bgSecondary,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected ? colors.accent : Colors.transparent,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        )
        .inkWell(onTap: onTap, borderRadius: BorderRadius.circular(18));
  }
}
