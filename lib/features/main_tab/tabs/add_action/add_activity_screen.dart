import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:novda_sdk/novda_sdk.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/ui/ui.dart';
import 'extensions/add_activity_screen_ui_extensions.dart';
import 'view_model/add_activity_view_model.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({
    super.key,
    required this.activityType,
    this.initialActivity,
  });

  final ActivityType activityType;
  final ActivityItem? initialActivity;

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddActivityViewModel>(
      create: (_) => AddActivityViewModel(
        activityType: widget.activityType,
        initialActivity: widget.initialActivity,
      )..load(),
      child: Consumer<AddActivityViewModel>(
        builder: (context, viewModel, _) {
          _showActionErrorIfAny(context, viewModel);

          if (viewModel.isLoading && viewModel.startDate == null) {
            return Scaffold(
              backgroundColor: context.appColors.bgPrimary,
              appBar: _appBar(context),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          if (viewModel.hasError && viewModel.startDate == null) {
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

  Widget _content(BuildContext context, AddActivityViewModel viewModel) {
    final l10n = context.l10n;
    final colors = context.appColors;

    final title = l10n.addActivityTitle(viewModel.activityType.title);
    final selectedReminderCount = viewModel.selectedReminderIds.length;
    final selectedConditionsCount = viewModel.selectedConditionSlugs.length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      children: [
        Text(
          title,
          style: AppTypography.headingL.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: 20),
        if (!viewModel.hasChild)
          Text(
            l10n.addActivityNoChildSelected,
            style: AppTypography.bodyMRegular.copyWith(color: colors.error),
          ).paddingOnly(bottom: 14),

        if (viewModel.isFeedingActivity) ...[
          context.addActivitySegmentedFeedingType(viewModel),
          const SizedBox(height: 12),
        ],

        context.addActivityDateField(
          label: l10n.addActivityStartTime,
          value: viewModel.startDate,
          onTap: () => _pickStartDate(context, viewModel),
        ),
        const SizedBox(height: 12),

        if (viewModel.hasDuration) ...[
          context.addActivityDateField(
            label: l10n.addActivityEndTime,
            value: viewModel.endDate,
            onTap: () => _pickEndDate(context, viewModel),
            hasError:
                viewModel.endDate != null &&
                viewModel.startDate != null &&
                !viewModel.endDate!.isAfter(viewModel.startDate!),
          ),
          const SizedBox(height: 12),
        ],

        if (viewModel.needsBottleAmount) ...[
          context.addActivityAmountField(
            label: l10n.addActivityAmountMl,
            initialValue: viewModel.bottleAmountInput,
            onChanged: viewModel.setBottleAmountInput,
            hasError:
                viewModel.bottleAmountInput.isNotEmpty &&
                (viewModel.bottleAmountMl == null ||
                    viewModel.bottleAmountMl! <= 0),
          ),
          const SizedBox(height: 12),
        ],

        if (viewModel.hasQuality) ...[
          context.addActivitySelectField(
            label: l10n.addActivityQuality,
            value: viewModel.quality == null
                ? null
                : context.addActivityQualityLabel(viewModel.quality!),
            trailing: context.addActivityQualityFieldIcon(),
            onTap: () => _openQualityPicker(context, viewModel),
          ),
          const SizedBox(height: 12),
        ],

        if (viewModel.isIllnessActivity) ...[
          context.addActivitySelectField(
            label: l10n.addActivityConditions,
            value: selectedConditionsCount == 0
                ? null
                : context.addActivityConditionsCountLabel(
                    selectedConditionsCount,
                  ),
            onTap: () => _openConditionsSheet(context, viewModel),
          ),
          const SizedBox(height: 12),
        ],

        context.addActivitySelectField(
          label: l10n.addActivityReminders,
          value: selectedReminderCount == 0
              ? null
              : context.addActivitySelectedCountLabel(selectedReminderCount),
          trailing: context.addActivityReminderFieldIcon(),
          onTap: () => _openRemindersSheet(context, viewModel),
        ),
        const SizedBox(height: 12),

        context.addActivityCommentsField(
          label: l10n.addActivityComments,
          initialValue: viewModel.comments,
          onChanged: viewModel.setComments,
        ),
      ],
    );
  }

  Widget _submitButton(BuildContext context, AddActivityViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: AppButton(
        text: viewModel.isEditMode
            ? context.l10n.addActivitySave
            : context.l10n.addActivitySubmit,
        isEnabled: viewModel.canSubmit,
        isLoading: viewModel.isSubmitting,
        onPressed: () => _submit(context, viewModel),
      ),
    ).safeArea(top: false);
  }

  Future<void> _pickStartDate(
    BuildContext context,
    AddActivityViewModel viewModel,
  ) async {
    final selected = await _showDateTimePicker(
      context,
      initialDate: viewModel.startDate ?? DateTime.now(),
    );

    if (selected == null) return;
    viewModel.setStartDate(selected);
  }

  Future<void> _pickEndDate(
    BuildContext context,
    AddActivityViewModel viewModel,
  ) async {
    final initial =
        viewModel.endDate ??
        (viewModel.startDate ?? DateTime.now()).add(
          const Duration(minutes: 30),
        );

    final selected = await _showDateTimePicker(context, initialDate: initial);
    if (selected == null) return;

    viewModel.setEndDate(selected);
  }

  Future<void> _openQualityPicker(
    BuildContext context,
    AddActivityViewModel viewModel,
  ) async {
    final selected = await AppBottomSheet.show<Quality>(
      context: context,
      showDragHandle: true,
      title: context.l10n.addActivityQuality,
      child: context.addActivityQualitySheet(
        selected: viewModel.quality,
        onSelect: (value) => Navigator.of(context).pop(value),
      ),
    );

    if (selected == null) return;
    viewModel.setQuality(selected);
  }

  Future<void> _openRemindersSheet(
    BuildContext context,
    AddActivityViewModel viewModel,
  ) async {
    await AppBottomSheet.show<void>(
      context: context,
      showDragHandle: true,
      title: context.l10n.addActivityReminders,
      child: AnimatedBuilder(
        animation: viewModel,
        builder: (sheetContext, _) {
          return sheetContext.addActivityReminderSheet(
            reminders: viewModel.pendingReminders,
            selectedReminderIds: viewModel.selectedReminderIds,
            onToggle: viewModel.toggleReminderSelection,
            onDone: () => Navigator.of(sheetContext).pop(),
          );
        },
      ),
    );
  }

  Future<void> _openConditionsSheet(
    BuildContext context,
    AddActivityViewModel viewModel,
  ) async {
    await AppBottomSheet.show<void>(
      context: context,
      showDragHandle: true,
      title: context.l10n.addActivityConditions,
      child: AnimatedBuilder(
        animation: viewModel,
        builder: (sheetContext, _) {
          return sheetContext.addActivityConditionsSheet(
            conditions: viewModel.conditionTypes,
            selectedConditionSlugs: viewModel.selectedConditionSlugs,
            onToggle: viewModel.toggleConditionSelection,
            onDone: () => Navigator.of(sheetContext).pop(),
          );
        },
      ),
    );
  }

  Future<DateTime?> _showDateTimePicker(
    BuildContext context, {
    required DateTime initialDate,
  }) async {
    DateTime selected = initialDate;

    return showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (sheetContext) {
        final colors = sheetContext.appColors;

        return Container(
          height: 320,
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
                    child: Text(sheetContext.l10n.settingsCancel),
                  ),
                  const Spacer(),
                  CupertinoButton(
                    onPressed: () => Navigator.of(sheetContext).pop(selected),
                    child: Text(sheetContext.l10n.continueButton),
                  ),
                ],
              ).paddingSymmetric(horizontal: 8),
              const Divider(height: 1),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  use24hFormat: true,
                  initialDateTime: initialDate,
                  onDateTimeChanged: (value) {
                    selected = value;
                  },
                ),
              ),
            ],
          ),
        ).safeArea(top: false);
      },
    );
  }

  Future<void> _submit(
    BuildContext context,
    AddActivityViewModel viewModel,
  ) async {
    final success = await viewModel.submit();
    if (!context.mounted || !success) return;

    Navigator.of(context).pop(viewModel.createdActivity);
  }

  void _showActionErrorIfAny(
    BuildContext context,
    AddActivityViewModel viewModel,
  ) {
    final message = viewModel.consumeActionError();
    if (message == null || message.isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    });
  }
}
