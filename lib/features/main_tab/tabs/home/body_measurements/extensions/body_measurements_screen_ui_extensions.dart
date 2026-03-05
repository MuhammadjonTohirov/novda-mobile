import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../../core/extensions/extensions.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../models/body_measurement_entry.dart';
import '../view_model/body_measurements_view_model.dart';
import '../widgets/measurement_line_chart.dart';

extension BodyMeasurementsScreenUiExtensions on BuildContext {
  Widget bodyMeasurementsBody({
    required BodyMeasurementsViewModel viewModel,
    required ValueChanged<BodyMeasurementEntry> onEntryActionTap,
  }) {
    final colors = appColors;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      children: [
        Text(
          l10n.bodyMeasurementsTitle,
          style: AppTypography.headingL.copyWith(color: colors.textPrimary),
        ),
        20.h,
        _bodyMeasurementsChartCard(
          title: l10n.bodyMeasurementsHeightChart,
          measurements: viewModel.heightMeasurements,
        ),
        12.h,
        _bodyMeasurementsChartCard(
          title: l10n.bodyMeasurementsWeightChart,
          measurements: viewModel.weightMeasurements,
        ),
        14.h,
        _bodyMeasurementsHistoryCard(
          entries: viewModel.entries,
          isMutatingEntry: viewModel.isMutatingEntry,
          onEntryActionTap: onEntryActionTap,
        ),
        24.h,
      ],
    ).safeArea(top: false, bottom: false);
  }

  Widget _bodyMeasurementsChartCard({
    required String title,
    required List<Measurement> measurements,
  }) {
    final colors = appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.headingS.copyWith(color: colors.textPrimary),
        ),
        10.h,
        MeasurementLineChart(
          measurements: measurements,
          emptyText: l10n.bodyMeasurementsNoData,
        ),
      ],
    ).container(
      decoration: BoxDecoration(
        color: colors.bgPrimary,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
    );
  }

  Widget _bodyMeasurementsHistoryCard({
    required List<BodyMeasurementEntry> entries,
    required bool Function(String entryKey) isMutatingEntry,
    required ValueChanged<BodyMeasurementEntry> onEntryActionTap,
  }) {
    final colors = appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.bodyMeasurementsHistory,
          style: AppTypography.headingS.copyWith(color: colors.textPrimary),
        ),
        10.h,
        if (entries.isEmpty)
          Text(
            l10n.bodyMeasurementsNoData,
            style: AppTypography.bodyMRegular.copyWith(
              color: colors.textSecondary,
            ),
          ).paddingOnly(top: 4, bottom: 2)
        else
          Column(
            children: [
              for (var i = 0; i < entries.length; i++) ...[
                _bodyMeasurementHistoryItem(
                  entry: entries[i],
                  isMutating: isMutatingEntry(entries[i].entryKey),
                  onTap: () => onEntryActionTap(entries[i]),
                ),
                if (i != entries.length - 1) 6.h,
              ],
            ],
          ),
      ],
    ).container(
      decoration: BoxDecoration(
        color: colors.bgPrimary,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
    );
  }

  Widget _bodyMeasurementHistoryItem({
    required BodyMeasurementEntry entry,
    required bool isMutating,
    required VoidCallback onTap,
  }) {
    final colors = appColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_valueLabel(entry.weight)} / ${_valueLabel(entry.height)}',
              style: AppTypography.headingM.copyWith(color: colors.textPrimary),
            ),
            2.h,
            Text(
              _timeLabel(entry.takenAt),
              style: AppTypography.bodyMRegular.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ).expanded(),
        if (isMutating)
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        else
          IconButton(
            icon: Icon(Icons.edit_outlined, color: colors.textSecondary),
            onPressed: onTap,
            splashRadius: 20,
            tooltip: l10n.bodyMeasurementsEdit,
          ),
      ],
    ).container(
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    );
  }

  String _valueLabel(Measurement? measurement) {
    if (measurement == null) return '-';
    return '${measurement.value.toCompactString()} ${measurement.unit}';
  }

  String _timeLabel(DateTime value) {
    final local = value.toLocal();
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final time = DateFormat('HH:mm').format(local);

    if (local.isToday) {
      return '${l10n.today} • $time';
    }
    if (local.isSameDate(yesterday)) {
      return '${l10n.homeYesterday} • $time';
    }
    if (local.isTomorrow) {
      return '${l10n.homeTomorrow} • $time';
    }

    return '${DateFormat('MMM d').format(local)} • $time';
  }
}
