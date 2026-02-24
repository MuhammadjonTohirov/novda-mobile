import 'package:flutter/material.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import '../view_model/add_action_sheet_view_model.dart';
import 'add_action_sheet_content_ui_state_extensions.dart';

extension AddActionSheetContentUiListExtensions on BuildContext {
  Widget addActionActivityTypesList(AddActionSheetViewModel viewModel) {
    if (viewModel.isLoading && !viewModel.hasTypes) {
      return addActionActivityTypesLoadingView();
    }

    if (viewModel.hasError && !viewModel.hasTypes) {
      final message = viewModel.errorMessage ?? l10n.homeFailedLoad;
      return addActionActivityTypesErrorView(
        message: message,
        onRetry: viewModel.load,
      );
    }

    if (!viewModel.hasTypes) {
      return addActionActivityTypesEmptyView();
    }

    return ListView(
      physics: const ClampingScrollPhysics(),
      primary: false,
      shrinkWrap: true,
      children: [
        for (final type in viewModel.activityTypes)
          addActionActivityTypeListItem(
            type: type,
            isSelected: viewModel.selectedActivityTypeId == type.id,
            onTap: () => viewModel.selectActivityType(type.id),
          ),
      ],
    );
  }

  Widget addActionActivityTypeListItem({
    required ActivityType type,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colors = appColors;
    final baseColor = colors.accent.parseHexOrSelf(type.color);

    return Row(
          children: [
            addActionActivityTypeIcon(type: type, color: baseColor),
            const SizedBox(width: 14),
            Text(
              type.title,
              style: AppTypography.bodyLMedium.copyWith(
                color: colors.textPrimary,
              ),
            ).expanded(),
            if (isSelected)
              Icon(Icons.check_rounded, color: baseColor, size: 30),
          ],
        )
        .container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? colors.bgSoft : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
        )
        .inkWell(onTap: onTap, borderRadius: BorderRadius.circular(20));
  }

  Widget addActionActivityTypeIcon({
    required ActivityType type,
    required Color color,
  }) {
    final fallback = Icon(
      _addActionIconBySlug(type.slug),
      color: color,
      size: 34,
    );
    final url = type.iconUrl.trim();

    if (url.isEmpty) return fallback;

    return Image.network(
      url,
      width: 24,
      height: 24,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => fallback,
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return fallback;
      },
    );
  }

  IconData _addActionIconBySlug(String slug) {
    final value = slug.toLowerCase();

    if (value.contains('feed') || value.contains('food')) {
      return Icons.local_drink_outlined;
    }
    if (value.contains('sleep')) {
      return Icons.bedtime_outlined;
    }
    if (value.contains('diaper')) {
      return Icons.baby_changing_station_outlined;
    }
    if (value.contains('bath')) {
      return Icons.bathtub_outlined;
    }
    if (value.contains('med')) {
      return Icons.medication_outlined;
    }

    return Icons.more_horiz;
  }
}
