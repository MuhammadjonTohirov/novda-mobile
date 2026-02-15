import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:novda_sdk/novda_sdk.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/theme/app_theme.dart';
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
          _showActionErrorIfAny(context, viewModel);

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
                      onEditDetails: () => _showComingSoon(context),
                    )
                    .safeArea(bottom: false)
                    .paddingOnly(left: 16, right: 16, bottom: 16),
                const SizedBox(height: 14),

                context
                    .homeChildInfoCard(
                      childInfo: viewModel.activeChild,
                      childDetails: viewModel.activeChildDetails,
                      onTap: () => _showComingSoon(context),
                    )
                    .paddingOnly(left: 16, right: 16),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    context.homeSectionHeader(
                      title: context.l10n.homeActivities,
                      actionLabel: context.l10n.homeActivityHistory,
                      onActionTap: () => _showComingSoon(context),
                    ),
                    const SizedBox(height: 12),
                    _ActivitiesGrid(viewModel: viewModel),
                    const SizedBox(height: 22),
                    context.homeSectionHeader(
                      title: context.l10n.homeReminders,
                      actionLabel: context.l10n.homeSeeAll,
                      onActionTap: () => _showComingSoon(context),
                    ),
                    const SizedBox(height: 12),
                    _RemindersList(viewModel: viewModel),
                    const SizedBox(height: 14),
                    _AddReminderButton(onTap: () => _showComingSoon(context)),
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

  void _showActionErrorIfAny(BuildContext context, HomeViewModel viewModel) {
    final actionError = viewModel.consumeActionError();
    if (actionError == null || actionError.isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(actionError)));
    });
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(context.l10n.homeComingSoon)));
  }
}
