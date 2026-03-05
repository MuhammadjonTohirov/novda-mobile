import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import '../extensions/home_screen_ui_extensions.dart';
import 'extensions/body_measurements_screen_ui_extensions.dart';
import 'extensions/body_measurements_screen_ui_sheets_extensions.dart';
import 'models/body_measurement_entry.dart';
import 'view_model/body_measurements_view_model.dart';

class BodyMeasurementsScreen extends StatelessWidget {
  const BodyMeasurementsScreen({super.key, required this.childId});

  final int childId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BodyMeasurementsViewModel>(
      create: (_) => BodyMeasurementsViewModel(childId: childId)..load(),
      child: Consumer<BodyMeasurementsViewModel>(
        builder: (context, viewModel, _) {
          context.showDeferredSnackIfNeeded(viewModel.consumeActionError());

          if (viewModel.isLoading && !viewModel.hasMeasurements) {
            return Scaffold(
              backgroundColor: context.appColors.bgSecondary,
              appBar: _appBar(context),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          if (viewModel.hasError && !viewModel.hasMeasurements) {
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
              child: context.bodyMeasurementsBody(
                viewModel: viewModel,
                onEntryActionTap: (entry) =>
                    _openEntryActions(context, viewModel, entry),
              ),
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

  Future<void> _openEntryActions(
    BuildContext context,
    BodyMeasurementsViewModel viewModel,
    BodyMeasurementEntry entry,
  ) async {
    if (viewModel.isMutatingEntry(entry.entryKey)) return;

    final action = await context.showBodyMeasurementItemActionsSheet();
    if (!context.mounted || action == null) return;

    switch (action) {
      case BodyMeasurementItemAction.edit:
        await _editEntry(context, viewModel, entry);
        break;
      case BodyMeasurementItemAction.delete:
        await _deleteEntry(context, viewModel, entry);
        break;
    }
  }

  Future<void> _editEntry(
    BuildContext context,
    BodyMeasurementsViewModel viewModel,
    BodyMeasurementEntry entry,
  ) async {
    final draft = await context.showBodyMeasurementEditSheet(entry: entry);
    if (!context.mounted || draft == null) return;

    final hasWeightInput = draft.weightInput.trim().isNotEmpty;
    final hasHeightInput = draft.heightInput.trim().isNotEmpty;

    final weightValue = draft.weightInput.toMetricValue(max: 200);
    final heightValue = draft.heightInput.toMetricValue(max: 250);

    if ((hasWeightInput && weightValue == null) ||
        (hasHeightInput && heightValue == null)) {
      context.showSnackMessage(context.l10n.errorWrongFormat);
      return;
    }

    if (weightValue == null && heightValue == null) {
      context.showSnackMessage(context.l10n.bodyMeasurementsAtLeastOneValue);
      return;
    }

    await viewModel.saveEntry(
      entry: entry,
      weightValue: weightValue,
      heightValue: heightValue,
    );
  }

  Future<void> _deleteEntry(
    BuildContext context,
    BodyMeasurementsViewModel viewModel,
    BodyMeasurementEntry entry,
  ) async {
    final confirmed = await context.showBodyMeasurementDeleteSheet();
    if (!context.mounted || !confirmed) return;

    await viewModel.deleteEntry(entry);
  }

}
