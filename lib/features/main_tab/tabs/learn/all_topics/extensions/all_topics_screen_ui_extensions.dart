import 'package:flutter/material.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../../core/extensions/extensions.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../extensions/learn_tab_ui_body_extensions.dart';
import '../view_model/all_topics_view_model.dart';
import 'all_topics_screen_ui_state_extensions.dart';

extension AllTopicsScreenUiExtensions on BuildContext {
  static const _contentPadding = EdgeInsets.fromLTRB(16, 0, 16, 20);

  Widget allTopicsScreenBody({
    required AllTopicsViewModel viewModel,
    required Future<void> Function() onRefresh,
    required VoidCallback onBackTap,
    required ValueChanged<Topic> onTopicTap,
  }) {
    final colors = appColors;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: _contentPadding,
        children: [
          _allTopicsHeader(onBackTap: onBackTap).safeArea(bottom: false),
          const SizedBox(height: 14),
          if (viewModel.topics.isEmpty)
            allTopicsEmptyView()
          else
            GridView.builder(
              itemCount: viewModel.topics.length,
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.72,
                mainAxisExtent: 156,
              ),
              itemBuilder: (_, index) {
                final topic = viewModel.topics[index];
                return learnTopicCard(
                  topic: topic,
                  articleCount: viewModel.topicArticleCount(topic.slug),
                  onTap: () => onTopicTap(topic),
                );
              },
            ),
        ],
      ),
    ).container(color: colors.bgSecondary);
  }

  Widget _allTopicsHeader({required VoidCallback onBackTap}) {
    final colors = appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.arrow_back_rounded, size: 24, color: colors.textPrimary)
            .paddingOnly(right: 8, bottom: 8)
            .inkWell(onTap: onBackTap, borderRadius: BorderRadius.circular(20)),
        const SizedBox(height: 8),
        Text(
          l10n.learnAllTopics,
          style: AppTypography.headingL.copyWith(color: colors.textPrimary),
        ),
      ],
    );
  }
}
