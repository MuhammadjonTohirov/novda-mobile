import 'package:flutter/material.dart';
import 'package:novda_sdk/novda_sdk.dart';
import 'package:provider/provider.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import 'extensions/article_screen_ui_extensions.dart';
import 'extensions/article_screen_ui_state_extensions.dart';
import 'interactor/article_screen_interactor.dart';
import 'view_model/article_screen_view_model.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key, required this.article});

  final ArticleListItem article;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ArticleScreenViewModel>(
      create: (_) => ArticleScreenViewModel(
        preview: article,
        interactor: ArticleScreenInteractor(),
      )..load(),
      child: Consumer<ArticleScreenViewModel>(
        builder: (context, viewModel, _) {
          _showActionErrorIfAny(context, viewModel);

          if (viewModel.isLoading && !viewModel.hasDetail) {
            return Scaffold(
              backgroundColor: context.appColors.bgSecondary,
              body: const CircularProgressIndicator().center().safeArea(),
            );
          }

          if (viewModel.hasError && !viewModel.hasDetail) {
            return Scaffold(
              backgroundColor: context.appColors.bgSecondary,
              body: context.articleLoadErrorView(
                message: viewModel.errorMessage ?? context.l10n.learnFailedLoad,
                onRetry: viewModel.load,
              ),
            );
          }

          return Scaffold(
            backgroundColor: context.appColors.bgSecondary,
            body: context.articleScreenBody(
              viewModel: viewModel,
              onRefresh: viewModel.load,
              onBackTap: () => Navigator.of(context).pop(),
              onBookmarkTap: viewModel.toggleSaved,
              onHelpfulTap: () => _showComingSoon(context),
            ),
          );
        },
      ),
    );
  }

  void _showActionErrorIfAny(
    BuildContext context,
    ArticleScreenViewModel viewModel,
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
