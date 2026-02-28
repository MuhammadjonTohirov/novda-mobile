import 'package:flutter/material.dart';
import 'package:novda_sdk/novda_sdk.dart';
import 'package:provider/provider.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import '../article/article_screen.dart';
import 'extensions/topic_articles_screen_ui_extensions.dart';
import 'extensions/topic_articles_screen_ui_state_extensions.dart';
import 'interactor/topic_articles_interactor.dart';
import 'view_model/topic_articles_view_model.dart';

class TopicArticlesScreen extends StatelessWidget {
  const TopicArticlesScreen({super.key, required this.topic});

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TopicArticlesViewModel>(
      create: (_) => TopicArticlesViewModel(
        topic: topic,
        interactor: TopicArticlesInteractor(),
      )..load(),
      child: Consumer<TopicArticlesViewModel>(
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
              body: context.topicArticlesLoadErrorView(
                message: viewModel.errorMessage ?? context.l10n.learnFailedLoad,
                onRetry: viewModel.load,
              ),
            );
          }

          return Scaffold(
            backgroundColor: context.appColors.bgSecondary,
            body: context.topicArticlesScreenBody(
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
    TopicArticlesViewModel viewModel,
    ArticleListItem article,
  ) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => ArticleScreen(article: article)));

    if (!context.mounted) return;
    await viewModel.refresh();
  }
}
