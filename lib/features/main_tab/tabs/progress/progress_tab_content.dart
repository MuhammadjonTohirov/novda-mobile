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
          context.showDeferredSnackIfNeeded(viewModel.consumeActionError());

          if (viewModel.isInitialLoading) {
            return const CircularProgressIndicator().center().safeArea();
          }

          if (viewModel.hasError && !viewModel.hasContent) {
            final message =
                viewModel.errorMessage ?? context.l10n.progressFailedLoad;
            return context.loadErrorView(
              message: message,
              onRetry: viewModel.load,
            );
          }

          _centerSelectedPeriodIfNeeded(viewModel);

          return context.progressTabBody(
            viewModel: viewModel,
            onRefresh: viewModel.load,
            onPeriodTap: viewModel.selectPeriod,
            onCalendarTap: () => context.showSnackMessage(context.l10n.homeComingSoon),
            periodScrollController: _periodScrollController,
          );
        },
      ),
    );
  }

  void _centerSelectedPeriodIfNeeded(ProgressTabViewModel viewModel) {
    if (!viewModel.consumeScrollToSelected()) return;

    final selectedIndex = viewModel.periods.indexWhere((period) {
      return viewModel.isSelectedPeriod(period);
    });
    if (selectedIndex < 0) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_periodScrollController.hasClients) {
        // List not laid out yet — retry on next frame.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToPeriodIndex(selectedIndex);
        });
        return;
      }
      _scrollToPeriodIndex(selectedIndex);
    });
  }

  void _scrollToPeriodIndex(int selectedIndex) {
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
  }

}
