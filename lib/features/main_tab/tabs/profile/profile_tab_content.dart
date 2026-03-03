import 'package:flutter/material.dart';
import 'package:novda/core/ui/ui.dart';
import 'package:provider/provider.dart';

import '../../../../core/extensions/extensions.dart';
import 'child_details/child_details_screen.dart';
import 'extensions/profile_tab_ui_extensions.dart';
import 'follow_us/follow_us_screen.dart';
import 'legal_documents/legal_documents_screen.dart';
import 'saved_articles/saved_articles_screen.dart';
import 'settings/settings_screen.dart';
import 'support/support_screen.dart';
import 'view_model/profile_tab_view_model.dart';

class ProfileTabContent extends StatelessWidget {
  const ProfileTabContent({super.key, required this.onLogout});

  final Future<void> Function() onLogout;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileTabViewModel>(
      create: (_) => ProfileTabViewModel()..load(),
      child: Consumer<ProfileTabViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading && !viewModel.hasContent) {
            return const CircularProgressIndicator().center();
          }

          if (viewModel.hasError && !viewModel.hasContent) {
            return Text(
              viewModel.errorMessage ?? context.l10n.homeFailedLoad,
              textAlign: TextAlign.center,
            ).center();
          }

          return context.profileTabBody(
            viewModel: viewModel,
            onLogoutTap: () => _openLogoutSheet(context),
            onParentTap: () =>
                context.showSnackMessage(context.l10n.homeComingSoon),
            onAddChildTap: () =>
                _openChildDetails(context, viewModel: viewModel),
            onChildTap: () => _openChildDetails(
              context,
              viewModel: viewModel,
              childId: viewModel.activeChild?.id,
            ),
            onSavedArticlesTap: () =>
                _openSavedArticles(context, viewModel: viewModel),
            onFollowUsTap: () => _openFollowUs(context),
            onSupportTap: () => _openSupport(context),
            onLegalDocumentsTap: () => _openLegalDocuments(context),
            onActionTap: () =>
                context.showSnackMessage(context.l10n.homeComingSoon),
            onSettingsTap: () => _openSettings(context),
          );
        },
      ),
    );
  }

  void _openSettings(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
  }

  Future<void> _openLogoutSheet(BuildContext context) async {
    await AppBottomSheet.show<void>(
      context: context,
      showDragHandle: true,
      child: Builder(
        builder: (sheetContext) {
          return sheetContext.profileLogoutBottomSheet(
            onCancel: () => Navigator.of(sheetContext).pop(),
            onLogout: () async {
              Navigator.of(sheetContext).pop();
              await onLogout();
            },
          );
        },
      ),
    );
  }

  Future<void> _openChildDetails(
    BuildContext context, {
    required ProfileTabViewModel viewModel,
    int? childId,
  }) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => ChildDetailsScreen(childId: childId)),
    );

    if (!context.mounted || saved != true) return;
    await viewModel.load();
  }

  Future<void> _openSavedArticles(
    BuildContext context, {
    required ProfileTabViewModel viewModel,
  }) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SavedArticlesScreen()));

    if (!context.mounted) return;
    await viewModel.load();
  }

  Future<void> _openFollowUs(BuildContext context) {
    return Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const FollowUsScreen()));
  }

  Future<void> _openSupport(BuildContext context) {
    return Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SupportScreen()));
  }

  Future<void> _openLegalDocuments(BuildContext context) {
    return Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const LegalDocumentsScreen()));
  }
}
