import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:novda/core/app/app.dart';
import 'package:novda_sdk/novda_sdk.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../add_action/add_activity_screen.dart';
import '../add_action/add_reminder_screen.dart';
import '../profile/child_details/child_details_screen.dart';
import 'activity_history/activity_history_screen.dart';
import 'body_measurements/body_measurements_screen.dart';
import 'extensions/home_screen_ui_extensions.dart';
import 'interactors/home_interactor.dart';
import 'reminders/reminders_screen.dart';
import 'view_models/home_view_model.dart';

part 'views/home_screen_activity_part.dart';
part 'views/home_screen_reminder_part.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (_) => HomeViewModel(interactor: HomeInteractor())..load(),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, _) {
          context.showDeferredSnackIfNeeded(viewModel.consumeActionError());

          if (viewModel.isLoading && !viewModel.hasAnyContent) {
            return const CircularProgressIndicator().center();
          }

          if (viewModel.hasError && !viewModel.hasAnyContent) {
            return context.loadErrorView(onRetry: viewModel.load);
          }

          final colors = context.appColors;

          return RefreshIndicator(
            onRefresh: viewModel.load,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                context
                    .homeMyChildHeader(
                      onEditDetails: () =>
                          _openChildDetails(context, viewModel),
                    )
                    .safeArea(bottom: false)
                    .paddingOnly(left: 16, right: 16, bottom: 16),
                const SizedBox(height: 14),

                context
                    .homeChildInfoCard(
                      childInfo: viewModel.activeChild,
                      childDetails: viewModel.activeChildDetails,
                      onTap: () => _openChildSelectorSheet(context, viewModel),
                      onMetricTap: () =>
                          _openBodyMeasurements(context, viewModel),
                    )
                    .paddingOnly(left: 16, right: 16),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    context.homeSectionHeader(
                      title: context.l10n.homeActivities,
                      actionLabel: context.l10n.homeActivityHistory,
                      onActionTap: () =>
                          _openActivityHistory(context, viewModel),
                    ),
                    const SizedBox(height: 12),
                    _ActivitiesGrid(
                      viewModel: viewModel,
                      onTypeTap: (type) =>
                          _openAddActivityByType(context, viewModel, type),
                    ),
                    const SizedBox(height: 22),
                    context.homeSectionHeader(
                      title: context.l10n.homeReminders,
                      actionLabel: context.l10n.homeSeeAll,
                      onActionTap: () => _openAllReminders(context, viewModel),
                    ),
                    const SizedBox(height: 12),
                    _RemindersList(viewModel: viewModel),
                    const SizedBox(height: 14),
                    _AddReminderButton(
                      onTap: () => _openAddReminder(context, viewModel),
                    ),
                  ],
                ).container(
                  decoration: BoxDecoration(
                    color: colors.bgPrimary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                ),
              ],
            ),
          ).container(color: colors.accent.withValues(alpha: 0.08));
        },
      ),
    );
  }

  Future<void> _openActivityHistory(
    BuildContext context,
    HomeViewModel viewModel,
  ) async {
    final child = viewModel.activeChild;
    if (child == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(context.l10n.homeNoActiveChildSelected)),
        );
      return;
    }

    await context.pushRoute(
      ActivityHistoryScreen(
        childId: child.id,
        initialTypes: viewModel.activityTypes,
      ),
    );

    if (!context.mounted) return;
    await viewModel.load();
  }

  Future<void> _openAddActivityByType(
    BuildContext context,
    HomeViewModel viewModel,
    ActivityType type,
  ) async {
    if (type.id <= 0) {
      context.showSnackMessage(context.l10n.homeComingSoon);
      return;
    }

    final createdActivity = await context.pushRoute(
      AddActivityScreen(activityType: type),
    );

    if (!context.mounted || createdActivity == null) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(context.l10n.addActivityCreated)));

    await viewModel.load();
  }

  Future<void> _openChildDetails(
    BuildContext context,
    HomeViewModel viewModel,
  ) async {
    final saved = await context.pushRoute<bool>(
      ChildDetailsScreen(childId: viewModel.activeChild?.id),
    );

    if (!context.mounted || saved != true) return;
    await viewModel.load();
  }

  Future<void> _openBodyMeasurements(
    BuildContext context,
    HomeViewModel viewModel,
  ) async {
    final child = viewModel.activeChild;
    if (child == null) {
      context.showSnackMessage(context.l10n.homeNoActiveChildSelected);
      return;
    }

    await context.pushRoute(
      BodyMeasurementsScreen(childId: child.id),
    );

    if (!context.mounted) return;
    await viewModel.load();
  }

  Future<void> _openChildSelectorSheet(
    BuildContext context,
    HomeViewModel viewModel,
  ) async {
    final selectedChildId = await context.showHomeChildSelectorSheet(
      children: viewModel.children,
      selectedChildId: viewModel.activeChild?.id,
    );

    if (!context.mounted || selectedChildId == null) return;
    final resolvedTheme = await viewModel.selectChild(selectedChildId);
    if (!context.mounted) return;

    if (resolvedTheme != null) {
      context.appController.setThemeVariant(resolvedTheme);
    }
  }

  Future<void> _openAllReminders(
    BuildContext context,
    HomeViewModel viewModel,
  ) async {
    await context.pushRoute(const RemindersScreen());

    if (!context.mounted) return;
    await viewModel.load();
  }

  Future<void> _openAddReminder(
    BuildContext context,
    HomeViewModel viewModel,
  ) async {
    final createdReminder = await context.pushRoute(const AddReminderScreen());

    if (!context.mounted || createdReminder == null) return;

    context.showSnackMessage(context.l10n.addReminderCreated);
    await viewModel.load();
  }
}
