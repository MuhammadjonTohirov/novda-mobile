import 'package:flutter/material.dart';
import 'package:novda_sdk/novda_sdk.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/ui.dart';
import 'extensions/add_action_sheet_content_ui_list_extensions.dart';
import 'extensions/add_activity_screen_ui_extensions.dart';
import 'view_model/add_reminder_view_model.dart';

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({
    super.key,
    this.initialActivityType,
    this.initialDueAt,
  });

  final ActivityType? initialActivityType;
  final DateTime? initialDueAt;

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddReminderViewModel>(
      create: (_) => AddReminderViewModel(
        initialActivityType: widget.initialActivityType,
        initialDueAt: widget.initialDueAt,
      )..load(),
      child: Consumer<AddReminderViewModel>(
        builder: (context, viewModel, _) {
          context.showDeferredSnackIfNeeded(viewModel.consumeActionError());

          if (viewModel.isLoading && !viewModel.isReady) {
            return Scaffold(
              backgroundColor: context.appColors.bgPrimary,
              appBar: _appBar(context),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          if (viewModel.hasError && !viewModel.hasActivityTypes) {
            return Scaffold(
              backgroundColor: context.appColors.bgPrimary,
              appBar: _appBar(context),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    viewModel.errorMessage ?? context.l10n.homeFailedLoad,
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMRegular.copyWith(
                      color: context.appColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppTextButton(
                    text: context.l10n.homeRetry,
                    onPressed: viewModel.load,
                  ),
                ],
              ).paddingAll(16).center(),
            );
          }

          return Scaffold(
            backgroundColor: context.appColors.bgPrimary,
            appBar: _appBar(context),
            body: Column(
              children: [
                _content(context, viewModel).expanded(),
                _submitButton(context, viewModel),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    final colors = context.appColors;

    return AppBar(
      backgroundColor: colors.bgPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: colors.textPrimary),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _content(BuildContext context, AddReminderViewModel viewModel) {
    final colors = context.appColors;
    final l10n = context.l10n;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      children: [
        Text(
          l10n.addReminderTitle,
          style: AppTypography.headingL.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: 20),
        if (!viewModel.hasChild)
          Text(
            l10n.addReminderNoChildSelected,
            style: AppTypography.bodyMRegular.copyWith(color: colors.error),
          ).paddingOnly(bottom: 14),

        context.addActivityDateField(
          label: l10n.addReminderDateTime,
          value: viewModel.dueAt,
          onTap: () => _pickDueAt(context, viewModel),
        ),
        const SizedBox(height: 12),

        context.addActivitySelectField(
          label: l10n.addReminderFor,
          value: viewModel.selectedActivityType?.title,
          onTap: () => _openTypeSheet(context, viewModel),
        ),
        const SizedBox(height: 12),
        if (!viewModel.hasActivityTypes)
          Text(
            l10n.homeNoActivityTypes,
            style: AppTypography.bodyMRegular.copyWith(
              color: colors.textSecondary,
            ),
          ).paddingOnly(bottom: 12),

        context.addActivityCommentsField(
          label: l10n.addReminderComments,
          initialValue: viewModel.comments,
          onChanged: viewModel.setComments,
        ),
      ],
    );
  }

  Widget _submitButton(BuildContext context, AddReminderViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: AppButton(
        text: context.l10n.addReminderSubmit,
        isEnabled: viewModel.canSubmit,
        isLoading: viewModel.isSubmitting,
        onPressed: () => _submit(context, viewModel),
      ),
    ).safeArea(top: false);
  }

  Future<void> _pickDueAt(
    BuildContext context,
    AddReminderViewModel viewModel,
  ) async {
    final selected = await AppDateTimePicker.show(
      context: context,
      initialDateTime: viewModel.dueAt ?? DateTime.now(),
      cancelText: context.l10n.settingsCancel,
      confirmText: context.l10n.continueButton,
      safeAreaTop: true,
      safeAreaBottom: false,
    );

    if (selected == null) return;
    viewModel.setDueAt(selected);
  }

  Future<void> _openTypeSheet(
    BuildContext context,
    AddReminderViewModel viewModel,
  ) async {
    await AppBottomSheet.show<void>(
      context: context,
      showDragHandle: true,
      title: context.l10n.addReminderFor,
      child: AppBottomSheetContent(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          if (viewModel.activityTypes.isEmpty)
            Text(
              context.l10n.homeNoActivityTypes,
              style: AppTypography.bodyMRegular.copyWith(
                color: context.appColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ).paddingOnly(top: 12, bottom: 8)
          else
            ...viewModel.activityTypes.map(
              (type) => context.addActionActivityTypeListItem(
                type: type,
                isSelected: viewModel.selectedActivityTypeId == type.id,
                onTap: () {
                  viewModel.selectActivityType(type.id);
                  Navigator.of(context).pop();
                },
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _submit(
    BuildContext context,
    AddReminderViewModel viewModel,
  ) async {
    final success = await viewModel.submit();
    if (!context.mounted || !success) return;

    Navigator.of(context).pop(viewModel.createdReminder);
  }
}
