import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../add_action/add_reminder_screen.dart';
import '../extensions/home_screen_ui_extensions.dart';
import 'extensions/reminders_screen_ui_extensions.dart';
import 'view_model/reminders_view_model.dart';

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RemindersViewModel>(
      create: (_) => RemindersViewModel()..load(),
      child: Consumer<RemindersViewModel>(
        builder: (context, viewModel, _) {
          context.showDeferredSnackIfNeeded(viewModel.consumeActionError());

          if (viewModel.isLoading && !viewModel.isReady) {
            return Scaffold(
              backgroundColor: context.appColors.bgSecondary,
              appBar: _appBar(context),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          if (viewModel.hasError && !viewModel.canShowContent) {
            return Scaffold(
              backgroundColor: context.appColors.bgSecondary,
              appBar: _appBar(context),
              body: context.homeLoadErrorView(onRetry: viewModel.load),
            );
          }

          return Scaffold(
            backgroundColor: context.appColors.bgSecondary,
            appBar: _appBar(context),
            body: RefreshIndicator(
              onRefresh: viewModel.refresh,
              child: _body(context, viewModel),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    final colors = context.appColors;

    return AppBar(
      backgroundColor: colors.bgSecondary,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: colors.textPrimary),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _body(BuildContext context, RemindersViewModel viewModel) {
    final colors = context.appColors;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      children: [
        Text(
          context.l10n.homeReminders,
          style: AppTypography.headingM.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: 16),
        if (!viewModel.hasChild)
          Text(
            context.l10n.homeNoActiveChildSelected,
            style: AppTypography.bodyMRegular.copyWith(color: colors.error),
          ).paddingOnly(bottom: 12),
        context.remindersCalendarCard(
          viewModel: viewModel,
          onPreviousMonthTap: viewModel.previousMonth,
          onNextMonthTap: viewModel.nextMonth,
          onDateTap: (date) {
            viewModel.selectDate(date);
          },
          onExpandCollapseTap: viewModel.toggleCalendarExpanded,
          onTodayTap: viewModel.selectToday,
        ),
        const SizedBox(height: 14),
        context.remindersListCard(
          viewModel: viewModel,
          onReminderCheckTap: viewModel.completeReminder,
          onAddReminderTap: () => _openAddReminder(context, viewModel),
        ),
        const SizedBox(height: 32),
      ],
    ).safeArea(top: false, bottom: false);
  }

  Future<void> _openAddReminder(
    BuildContext context,
    RemindersViewModel viewModel,
  ) async {
    final createdReminder = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddReminderScreen(
          initialDueAt: _initialDueAtFromSelectedDate(viewModel.selectedDate),
        ),
      ),
    );

    if (!context.mounted || createdReminder == null) return;

    context.showSnackMessage(context.l10n.addReminderCreated);
    await viewModel.onReminderCreated();
  }

  DateTime _initialDueAtFromSelectedDate(DateTime selectedDate) {
    final now = DateTime.now();
    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      now.hour,
      now.minute,
    );
  }
}
