import 'package:flutter/material.dart';
import 'package:novda_sdk/novda_sdk.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/extensions.dart';
import 'all_topics/all_topics_screen.dart';
import 'article/article_screen.dart';
import 'extensions/learn_tab_ui_extensions.dart';
import 'interactor/learn_tab_interactor.dart';
import 'topic_articles/topic_articles_screen.dart';
import 'view_model/learn_tab_view_model.dart';

class LearnTabContent extends StatelessWidget {
  const LearnTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LearnTabViewModel>(
      create: (_) =>
          LearnTabViewModel(interactor: LearnTabInteractor())..load(),
      child: Consumer<LearnTabViewModel>(
        builder: (context, viewModel, _) {
          _showActionErrorIfAny(context, viewModel);

          if (viewModel.isLoading && !viewModel.hasContent) {
            return const CircularProgressIndicator().center().safeArea();
          }

          if (viewModel.hasError && !viewModel.hasContent) {
            return context.learnLoadErrorView(
              message: viewModel.errorMessage ?? context.l10n.learnFailedLoad,
              onRetry: viewModel.load,
            );
          }

          return context.learnTabBody(
            viewModel: viewModel,
            onRefresh: viewModel.refresh,
            onSearchChanged: viewModel.searchArticles,
            onSeeAllTap: () => _openAllTopics(context, viewModel),
            onTopicTap: (topic) =>
                _openTopicArticles(context, viewModel, topic),
            onBookmarkTap: viewModel.toggleArticleSaved,
            onArticleTap: (article) =>
                _openArticle(context, viewModel, article),
          );
        },
      ),
    );
  }

  void _showActionErrorIfAny(
    BuildContext context,
    LearnTabViewModel viewModel,
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

  Future<void> _openTopicArticles(
    BuildContext context,
    LearnTabViewModel viewModel,
    Topic topic,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TopicArticlesScreen(topic: topic)),
    );

    if (!context.mounted) return;
    await viewModel.refresh();
  }

  Future<void> _openAllTopics(
    BuildContext context,
    LearnTabViewModel viewModel,
  ) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AllTopicsScreen()));

    if (!context.mounted) return;
    await viewModel.refresh();
  }

  Future<void> _openArticle(
    BuildContext context,
    LearnTabViewModel viewModel,
    ArticleListItem article,
  ) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => ArticleScreen(article: article)));

    if (!context.mounted) return;
    await viewModel.refresh();
  }
}
