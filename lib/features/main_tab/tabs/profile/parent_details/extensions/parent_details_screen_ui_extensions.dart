import 'package:flutter/material.dart';

import '../../../../../../core/extensions/extensions.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../core/ui/ui.dart';
import '../view_model/parent_details_view_model.dart';

extension ParentDetailsScreenUiExtensions on BuildContext {
  Widget parentDetailsBody({required ParentDetailsViewModel viewModel}) {
    final colors = appColors;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      children: [
        Text(
          l10n.parentDetailsTitle,
          style: AppTypography.headingL.copyWith(color: colors.textPrimary),
        ),
        20.h,
        _parentDetailsValueCard(
          label: l10n.parentDetailsPhone,
          value: viewModel.phone,
        ),
        10.h,
        _parentDetailsInputCard(
          label: l10n.parentDetailsFullName,
          controller: viewModel.nameController,
        ),
      ],
    ).safeArea(top: false, bottom: false);
  }

  Widget parentDetailsBottomSave({
    required ParentDetailsViewModel viewModel,
    required VoidCallback onSave,
  }) {
    return AppButton(
      text: l10n.parentDetailsSaveChanges,
      onPressed: onSave,
      isEnabled: viewModel.canSubmit,
      isLoading: viewModel.isSaving,
    ).paddingOnly(left: 16, right: 16, top: 8, bottom: 12).safeArea(top: false);
  }

  Widget _parentDetailsValueCard({
    required String label,
    required String value,
  }) {
    final colors = appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodyMMedium.copyWith(
            color: colors.textSecondary,
          ),
        ),
        4.h,
        Text(
          value.isEmpty ? '-' : value,
          style: AppTypography.headingS.copyWith(color: colors.textPrimary),
        ),
      ],
    ).container(
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _parentDetailsInputCard({
    required String label,
    required TextEditingController controller,
  }) {
    final colors = appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodyMMedium.copyWith(
            color: colors.textSecondary,
          ),
        ),
        2.h,
        TextField(
          controller: controller,
          style: AppTypography.headingS.copyWith(color: colors.textPrimary),
          decoration: const InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
        ),
      ],
    ).container(
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
