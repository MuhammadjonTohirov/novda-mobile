import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:novda_sdk/novda_sdk.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../add_action/add_activity_screen.dart';
import 'activity_history/activity_history_screen.dart';
import 'extensions/home_screen_ui_extensions.dart';
import 'interactors/home_interactor.dart';
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
            return context.homeLoadErrorView(onRetry: viewModel.load);
          }

          final colors = context.appColors;

          return RefreshIndicator(
            onRefresh: viewModel.load,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(0),
              children: [
                context
                    .homeMyChildHeader(
                      onEditDetails: () => context.showSnackMessage(context.l10n.homeComingSoon),
                    )
                    .safeArea(bottom: false)
                    .paddingOnly(left: 16, right: 16, bottom: 16),
                const SizedBox(height: 14),

                context
                    .homeChildInfoCard(
                      childInfo: viewModel.activeChild,
                      childDetails: viewModel.activeChildDetails,
                      onTap: () => context.showSnackMessage(context.l10n.homeComingSoon),
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
                      onActionTap: () => context.showSnackMessage(context.l10n.homeComingSoon),
                    ),
                    const SizedBox(height: 12),
                    _RemindersList(viewModel: viewModel),
                    const SizedBox(height: 14),
                    _AddReminderButton(onTap: () => context.showSnackMessage(context.l10n.homeComingSoon)),
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

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ActivityHistoryScreen(
          childId: child.id,
          initialTypes: viewModel.activityTypes,
        ),
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

    final createdActivity = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AddActivityScreen(activityType: type)),
    );

    if (!context.mounted || createdActivity == null) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(context.l10n.addActivityCreated)));

    await viewModel.load();
  }
}
