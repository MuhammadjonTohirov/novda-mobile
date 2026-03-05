import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import 'extensions/parent_details_screen_ui_extensions.dart';
import 'view_model/parent_details_view_model.dart';

class ParentDetailsScreen extends StatelessWidget {
  const ParentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ParentDetailsViewModel>(
      create: (_) => ParentDetailsViewModel()..load(),
      child: Consumer<ParentDetailsViewModel>(
        builder: (context, viewModel, _) {
          context.showDeferredSnackIfNeeded(viewModel.consumeActionError());

          if (viewModel.isLoading && !viewModel.hasLoadedForm) {
            return Scaffold(
              backgroundColor: context.appColors.bgPrimary,
              appBar: _appBar(context),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          if (viewModel.hasError && !viewModel.hasLoadedForm) {
            return Scaffold(
              backgroundColor: context.appColors.bgPrimary,
              appBar: _appBar(context),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    viewModel.errorMessage ?? context.l10n.homeFailedLoad,
                    style: AppTypography.bodyMRegular.copyWith(
                      color: context.appColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  12.h,
                  TextButton(
                    onPressed: viewModel.load,
                    child: Text(context.l10n.homeRetry),
                  ),
                ],
              ).paddingAll(16).center(),
            );
          }

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: context.appColors.bgPrimary,
              appBar: _appBar(context),
              body: Column(
                children: [
                  context.parentDetailsBody(viewModel: viewModel).expanded(),
                  context.parentDetailsBottomSave(
                    viewModel: viewModel,
                    onSave: () => _save(context, viewModel),
                  ),
                ],
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
      backgroundColor: colors.bgPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: colors.textPrimary),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Future<void> _save(
    BuildContext context,
    ParentDetailsViewModel viewModel,
  ) async {
    final saved = await viewModel.save();
    if (!context.mounted || !saved) return;

    Navigator.of(context).pop(true);
  }
}
