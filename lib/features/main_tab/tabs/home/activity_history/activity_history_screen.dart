import 'package:flutter/material.dart';
import 'package:novda_sdk/novda_sdk.dart';
import 'package:provider/provider.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../add_action/add_activity_screen.dart';
import '../extensions/home_screen_ui_extensions.dart';
import 'extensions/activity_history_screen_ui_extensions.dart';
import 'view_model/activity_history_view_model.dart';

class ActivityHistoryScreen extends StatelessWidget {
  const ActivityHistoryScreen({
    super.key,
    required this.childId,
    this.initialTypes = const [],
  });

  final int childId;
  final List<ActivityType> initialTypes;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ActivityHistoryViewModel>(
      create: (_) =>
          ActivityHistoryViewModel(childId: childId, initialTypes: initialTypes)
            ..load(),
      child: Consumer<ActivityHistoryViewModel>(
        builder: (context, viewModel, _) {
          final colors = context.appColors;

          return Scaffold(
            backgroundColor: colors.bgSecondary,
            appBar: AppBar(
              backgroundColor: colors.bgSecondary,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: colors.textPrimary),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: _body(context, viewModel),
          );
        },
      ),
    );
  }

  Widget _body(BuildContext context, ActivityHistoryViewModel viewModel) {
    final colors = context.appColors;

    if (viewModel.isLoading && !viewModel.hasActivities) {
      return const CircularProgressIndicator().center();
    }

    if (viewModel.hasError && !viewModel.hasActivities) {
      return context
          .homeLoadErrorView(onRetry: viewModel.load)
          .safeArea(top: false, bottom: false);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.homeActivityHistory,
          style: AppTypography.headingL.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: 12),
        context.activityHistoryTypeChips(
          types: viewModel.activityTypes,
          selectedTypeIds: viewModel.selectedTypeIds,
          onToggle: viewModel.toggleTypeFilter,
        ),
        const SizedBox(height: 14),
        if (!viewModel.hasActivities)
          Text(
            context.l10n.activityHistoryNoActivities,
            style: AppTypography.bodyMRegular.copyWith(
              color: colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ).center().expanded()
        else
          ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              for (final section in viewModel.sections)
                context
                    .activityHistorySectionCard(
                      section: section,
                      onItemTap: (item) =>
                          _openAddActivityByItem(context, viewModel, item),
                    )
                    .paddingOnly(bottom: 18),
            ],
          ).expanded(),
      ],
    ).paddingSymmetric(horizontal: 16).safeArea(top: false);
  }

  Future<void> _openAddActivityByItem(
    BuildContext context,
    ActivityHistoryViewModel viewModel,
    ActivityItem item,
  ) async {
    final createdActivity = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddActivityScreen(
          activityType: item.activityTypeDetail,
          initialActivity: item,
        ),
      ),
    );

    if (!context.mounted || createdActivity == null) return;

    await viewModel.load();
  }
}
