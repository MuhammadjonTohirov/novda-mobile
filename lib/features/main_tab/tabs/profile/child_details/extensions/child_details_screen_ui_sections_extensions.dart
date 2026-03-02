import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novda/core/ui/ui.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../../core/extensions/extensions.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../view_model/child_details_view_model.dart';
import 'child_details_screen_ui_fields_extensions.dart';
import 'child_details_screen_ui_sheets_extensions.dart';

extension ChildDetailsScreenUiSectionsExtensions on BuildContext {
  Widget childDetailsBody({required ChildDetailsViewModel viewModel}) {
    final colors = appColors;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      children: [
        Text(
          viewModel.isEditMode
              ? l10n.childDetailsEditTitle
              : l10n.childDetailsAddTitle,
          style: AppTypography.headingL.copyWith(color: colors.textPrimary),
        ),
        20.h,
        childDetailsInputCard(
          label: l10n.babyNameHint,
          controller: viewModel.nameController,
        ),
        28.h,
        _childDetailsSectionTitle(l10n.childDetailsBirthDate),
        12.h,
        Row(
          children: [
            if (viewModel.isEditMode)
              childDetailsValueCard(
                label: l10n.day,
                value: viewModel.dayController.text,
              ).expanded()
            else
              childDetailsInputCard(
                label: l10n.day,
                controller: viewModel.dayController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 2,
                hasError: viewModel.hasBirthDateError,
              ).expanded(),
            10.w,
            if (viewModel.isEditMode)
              childDetailsValueCard(
                label: l10n.month,
                value: viewModel.monthController.text,
              ).expanded()
            else
              childDetailsInputCard(
                label: l10n.month,
                controller: viewModel.monthController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 2,
                hasError: viewModel.hasBirthDateError,
              ).expanded(),
            10.w,
            if (viewModel.isEditMode)
              childDetailsValueCard(
                label: l10n.year,
                value: viewModel.yearController.text,
              ).expanded()
            else
              childDetailsInputCard(
                label: l10n.year,
                controller: viewModel.yearController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 4,
                hasError: viewModel.hasBirthDateError,
              ).expanded(),
          ],
        ),
        if (!viewModel.isEditMode && viewModel.hasBirthDateError) ...[
          8.h,
          Text(
            l10n.errorWrongFormat,
            style: AppTypography.bodySRegular.copyWith(color: colors.error),
          ),
        ],
        28.h,
        _childDetailsSectionTitle(l10n.childDetailsParameters),
        12.h,
        Row(
          children: [
            childDetailsParameterCard(
              label: l10n.weightInKg,
              value: viewModel.weightController.text,
              onEditTap: () => _editMetric(
                viewModel: viewModel,
                title: l10n.weightInKg,
                initialValue: viewModel.weightController.text,
                onSave: viewModel.setWeightInput,
              ),
              hasError: viewModel.hasWeightError,
            ).expanded(),
            10.w,
            childDetailsParameterCard(
              label: l10n.heightInCm,
              value: viewModel.heightController.text,
              onEditTap: () => _editMetric(
                viewModel: viewModel,
                title: l10n.heightInCm,
                initialValue: viewModel.heightController.text,
                onSave: viewModel.setHeightInput,
              ),
              hasError: viewModel.hasHeightError,
            ).expanded(),
          ],
        ),
        if (viewModel.hasWeightError || viewModel.hasHeightError) ...[
          8.h,
          Text(
            l10n.errorWrongFormat,
            style: AppTypography.bodySRegular.copyWith(color: colors.error),
          ),
        ],
        28.h,
        _childDetailsSectionTitle(l10n.homeGender),
        12.h,
        Row(
          children: [
            childDetailsGenderCard(
              gender: Gender.boy,
              isSelected: viewModel.selectedGender == Gender.boy,
              onTap: viewModel.isEditMode
                  ? null
                  : () => viewModel.setGender(Gender.boy),
            ).expanded(),
            10.w,
            childDetailsGenderCard(
              gender: Gender.girl,
              isSelected: viewModel.selectedGender == Gender.girl,
              onTap: viewModel.isEditMode
                  ? null
                  : () => viewModel.setGender(Gender.girl),
            ).expanded(),
          ],
        ),
      ],
    ).safeArea(top: false, bottom: false);
  }

  Widget childDetailsBottomSave({
    required ChildDetailsViewModel viewModel,
    required VoidCallback onSave,
  }) {
    return AppButton(
      text: l10n.addActivitySave,
      onPressed: onSave,
      isEnabled: viewModel.canSubmit,
      isLoading: viewModel.isSaving,
    ).paddingOnly(left: 16, right: 16, top: 8, bottom: 12).safeArea(top: false);
  }

  Widget _childDetailsSectionTitle(String title) {
    final colors = appColors;

    return Text(
      title,
      style: AppTypography.headingM.copyWith(color: colors.textPrimary),
      overflow: TextOverflow.ellipsis,
    );
  }

  Future<void> _editMetric({
    required ChildDetailsViewModel viewModel,
    required String title,
    required String initialValue,
    required ValueChanged<String> onSave,
  }) async {
    final editedValue = await showChildDetailsMetricEditorSheet(
      title: title,
      initialValue: initialValue,
    );
    if (editedValue == null) return;
    onSave(editedValue);
  }
}
