import 'package:flutter/material.dart';
import 'package:novda/core/theme/app_theme.dart';
import 'package:novda_core/novda_core.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/extensions.dart';
import 'extensions/progress_tab_ui_extensions.dart';
import 'interactor/progress_tab_interactor.dart';
import 'view_model/progress_tab_view_model.dart';

class ProgressTabContent extends StatelessWidget {
  const ProgressTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    //img_progress_boy_baby.png
    return Stack(
      children: [
        Image.asset('assets/images/image_dots.png', fit: BoxFit.fill),
        Container(
          decoration: BoxDecoration(
            color: context.appColors.iconBoy.withAlpha(130),
          ),
          height: 100,
        ).paddingOnly(top: 250),
        Image.asset(
          'assets/images/image_kid_with_toys.png',
          fit: BoxFit.cover,
        ).paddingOnly(top: 185),

        Stack(
          children: [
            Image.asset(
              'assets/images/img_quote_baby_boy.png',
              fit: BoxFit.cover,
            ),
            Text(
              "Lorem impsum dolor sit amet, consectetur adipiscing elit. Donec suscipit auctor dui, sed efficitur.",
              style: AppTypography.bodyMRegular.copyWith(
                color: context.appColors.textOnly,
                fontStyle: FontStyle.italic,
                fontSize: 10,
              ),
            ).paddingOnly(left: 12, right: 8, top: 8, bottom: 8),
          ],
        ).sized(width: 180, height: 100).paddingOnly(top: 90, left: 200),
      ],
    ).decorated(BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))));
  }

  @override
  Widget _build(BuildContext context) {
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

          return context.progressTabBody(
            viewModel: viewModel,
            onRefresh: viewModel.load,
            onPeriodTap: viewModel.selectPeriod,
            onCalendarTap: () => _showComingSoon(context),
          );
        },
      ),
    );
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
