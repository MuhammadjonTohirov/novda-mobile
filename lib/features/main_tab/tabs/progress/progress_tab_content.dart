import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/extensions.dart';
import 'extensions/progress_tab_ui_extensions.dart';
import 'interactor/progress_tab_interactor.dart';
import 'view_model/progress_tab_view_model.dart';

class ProgressTabContent extends StatefulWidget {
  const ProgressTabContent({super.key});

  @override
  State<ProgressTabContent> createState() => _ProgressTabContentState();
}

class _ProgressTabContentState extends State<ProgressTabContent> {
  static const double _periodChipWidth = 110;
  static const double _periodChipSpacing = 10;
  static const double _periodListHorizontalPadding = 16;

  final ScrollController _periodScrollController = ScrollController();
  String? _lastCenteredPeriodKey;

  @override
  void dispose() {
    _periodScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProgressTabViewModel>(
      create: (_) =>
          ProgressTabViewModel(interactor: ProgressTabInteractor())..load(),
      child: Consumer<ProgressTabViewModel>(
        builder: (context, viewModel, _) {
          _showActionErrorIfAny(context, viewModel);

          if (viewModel.isLoading && !viewModel.hasContent) {
            return const CircularProgressIndicator().center().safeArea();
          }

          if (viewModel.hasError && !viewModel.hasContent) {
            final message =
                viewModel.errorMessage ?? context.l10n.progressFailedLoad;
            return context.progressLoadErrorView(
              message: message,
              onRetry: viewModel.load,
            );
          }

          _centerSelectedPeriodIfNeeded(viewModel);

          return context.progressTabBody(
            viewModel: viewModel,
            onRefresh: viewModel.load,
            onPeriodTap: viewModel.selectPeriod,
            onCalendarTap: () => _showComingSoon(context),
            periodScrollController: _periodScrollController,
          );
        },
      ),
    );
  }

  void _centerSelectedPeriodIfNeeded(ProgressTabViewModel viewModel) {
    final selected = viewModel.selectedPeriod;
    if (selected == null) {
      _lastCenteredPeriodKey = null;
      return;
    }
    if (viewModel.periods.isEmpty) return;

    final selectedIndex = viewModel.periods.indexWhere((period) {
      return viewModel.isSelectedPeriod(period);
    });
    if (selectedIndex < 0) return;

    final selectedKey =
        '${selected.periodUnit.name}:${selected.periodIndex}:$selectedIndex:${viewModel.periods.length}';
    if (_lastCenteredPeriodKey == selectedKey) return;
    _lastCenteredPeriodKey = selectedKey;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_periodScrollController.hasClients) return;

      final viewportWidth = _periodScrollController.position.viewportDimension;
      final itemExtent = _periodChipWidth + _periodChipSpacing;
      final selectedItemCenter =
          _periodListHorizontalPadding +
          (selectedIndex * itemExtent) +
          (_periodChipWidth / 2);
      final maxScroll = _periodScrollController.position.maxScrollExtent;
      final targetOffset = (selectedItemCenter - (viewportWidth / 2)).clamp(
        0.0,
        maxScroll,
      );

      _periodScrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _showActionErrorIfAny(
    BuildContext context,
    ProgressTabViewModel viewModel,
  ) {
    final message = viewModel.consumeActionError();
    if (message == null || message.isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    });
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(context.l10n.homeComingSoon)));
  }
}
