import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/ui.dart';
import 'extensions/add_action_sheet_content_ui_extensions.dart';
import 'view_model/add_action_sheet_view_model.dart';

class AddActionSheetContent extends StatelessWidget {
  const AddActionSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddActionSheetViewModel>(
      create: (_) => AddActionSheetViewModel()..load(),
      child: Consumer<AddActionSheetViewModel>(
        builder: (context, viewModel, _) {
          final colors = context.appColors;

          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.82,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.l10n.addActionSheetTitle,
                  style: AppTypography.headingM.copyWith(
                    color: colors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.addActionSheetDescription,
                  style: AppTypography.bodyMRegular.copyWith(
                    color: colors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                CupertinoSlidingSegmentedControl(
                  children: {
                    AddActionType.activity: Text(
                      context.l10n.addActionTypeActivity,
                      style: AppTypography.bodyMRegular.copyWith(
                        color: colors.textPrimary,
                      ),
                    ).paddingAll(10),
                    AddActionType.reminder: Text(
                      context.l10n.addActionTypeReminder,
                      style: AppTypography.bodyMRegular.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  },
                  groupValue: viewModel.actionType,
                  onValueChanged: (AddActionType? value) {
                    if (value == null) return;
                    viewModel.selectActionType(value);
                  },
                ),
                const SizedBox(height: 16),
                context.addActionActivityTypesList(viewModel).expanded(),
                const SizedBox(height: 12),
                AppButton(
                  text: context.l10n.continueButton,
                  isEnabled: viewModel.selectedActivityType != null,
                  onPressed: () {
                    final selection = viewModel.currentSelection();
                    if (selection == null) return;
                    Navigator.of(context).pop(selection);
                  },
                ),
              ],
            ).paddingSymmetric(horizontal: 16),
          );
        },
      ),
    );
  }
}
