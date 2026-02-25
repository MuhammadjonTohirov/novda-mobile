import 'package:flutter/material.dart';
import 'package:novda_sdk/novda_sdk.dart';
import 'package:provider/provider.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';
import '../topic_articles/topic_articles_screen.dart';
import 'extensions/all_topics_screen_ui_extensions.dart';
import 'extensions/all_topics_screen_ui_state_extensions.dart';
import 'interactor/all_topics_interactor.dart';
import 'view_model/all_topics_view_model.dart';

class AllTopicsScreen extends StatelessWidget {
  const AllTopicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AllTopicsViewModel>(
      create: (_) =>
          AllTopicsViewModel(interactor: AllTopicsInteractor())..load(),
      child: Consumer<AllTopicsViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading && !viewModel.hasTopics) {
            return Scaffold(
              backgroundColor: context.appColors.bgSecondary,
              body: const CircularProgressIndicator().center().safeArea(),
            );
          }

          if (viewModel.hasError && !viewModel.hasTopics) {
            return Scaffold(
              backgroundColor: context.appColors.bgSecondary,
              body: context.allTopicsLoadErrorView(
                message: viewModel.errorMessage ?? context.l10n.learnFailedLoad,
                onRetry: viewModel.load,
              ),
            );
          }

          return Scaffold(
            backgroundColor: context.appColors.bgSecondary,
            body: context.allTopicsScreenBody(
              viewModel: viewModel,
              onRefresh: viewModel.load,
              onBackTap: () => Navigator.of(context).pop(),
              onTopicTap: (topic) => _openTopic(context, viewModel, topic),
            ),
          );
        },
      ),
    );
  }

  Future<void> _openTopic(
    BuildContext context,
    AllTopicsViewModel viewModel,
    Topic topic,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TopicArticlesScreen(topic: topic)),
    );

    if (!context.mounted) return;
    await viewModel.load();
  }
}
