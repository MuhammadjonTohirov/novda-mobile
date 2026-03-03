import 'package:flutter/material.dart';
import 'package:novda_sdk/novda_sdk.dart';
import 'package:provider/provider.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../learn/article/article_screen.dart';
import 'extensions/saved_articles_screen_ui_extensions.dart';
import 'extensions/saved_articles_screen_ui_state_extensions.dart';
import 'interactor/saved_articles_interactor.dart';
import 'view_model/saved_articles_view_model.dart';

class SavedArticlesScreen extends StatelessWidget {
  const SavedArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SavedArticlesViewModel>(
      create: (_) =>
          SavedArticlesViewModel(interactor: SavedArticlesInteractor())..load(),
      child: Consumer<SavedArticlesViewModel>(
        builder: (context, viewModel, _) {
          context.showDeferredSnackIfNeeded(viewModel.consumeActionError());

          if (viewModel.isLoading && !viewModel.hasContent) {
            return Scaffold(
              backgroundColor: context.appColors.bgSecondary,
              body: const CircularProgressIndicator().center().safeArea(),
            );
          }

          if (viewModel.hasError && !viewModel.hasContent) {
            return Scaffold(
              backgroundColor: context.appColors.bgSecondary,
              body: context.savedArticlesLoadErrorView(
                message: viewModel.errorMessage ?? context.l10n.learnFailedLoad,
                onRetry: viewModel.load,
              ),
            );
          }

          return Scaffold(
            backgroundColor: context.appColors.bgSecondary,
            body: context.savedArticlesScreenBody(
              viewModel: viewModel,
              onRefresh: viewModel.refresh,
              onBackTap: () => Navigator.of(context).pop(),
              onBookmarkTap: viewModel.toggleArticleSaved,
              onArticleTap: (article) =>
                  _openArticle(context, viewModel, article),
            ),
          );
        },
      ),
    );
  }

  Future<void> _openArticle(
    BuildContext context,
    SavedArticlesViewModel viewModel,
    ArticleListItem article,
  ) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => ArticleScreen(article: article)));

    if (!context.mounted) return;
    await viewModel.refresh();
  }
}
