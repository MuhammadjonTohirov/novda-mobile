import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/app/app.dart';
import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import 'extensions/child_details_screen_ui_extensions.dart';
import 'view_model/child_details_view_model.dart';

class ChildDetailsScreen extends StatelessWidget {
  const ChildDetailsScreen({super.key, this.childId});

  final int? childId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChildDetailsViewModel>(
      create: (_) => ChildDetailsViewModel(childId: childId)..load(),
      child: Consumer<ChildDetailsViewModel>(
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
              body: context.loadErrorView(
                message: viewModel.errorMessage,
                onRetry: viewModel.load,
              ),
            );
          }

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: context.appColors.bgPrimary,
              appBar: _appBar(context),
              body: Column(
                children: [
                  context.childDetailsBody(viewModel: viewModel).expanded(),
                  context.childDetailsBottomSave(
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

  PreferredSizeWidget _appBar(BuildContext context) =>
      context.novdaAppBar();

  Future<void> _save(
    BuildContext context,
    ChildDetailsViewModel viewModel,
  ) async {
    final saved = await viewModel.save();

    if (!context.mounted || !saved) return;

    final resolvedTheme = viewModel.resolvedThemeVariant;
    if (resolvedTheme != null) {
      context.appController.setThemeVariant(resolvedTheme);
    }

    Navigator.of(context).pop(true);
  }
}
