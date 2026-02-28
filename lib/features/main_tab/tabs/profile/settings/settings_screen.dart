import 'package:flutter/material.dart';
import 'package:novda/core/app/app.dart';
import 'package:novda/core/extensions/extensions.dart';
import 'package:novda/core/theme/app_theme.dart';
import 'package:novda/core/ui/ui.dart';
import 'package:novda_sdk/novda_sdk.dart';
import 'package:provider/provider.dart';

import '../../../../splash/splash.dart';
import 'extensions/settings_screen_ui_extensions.dart';
import 'view_model/settings_view_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsViewModel>(
      create: (_) => SettingsViewModel()..load(),
      child: Consumer<SettingsViewModel>(
        builder: (context, viewModel, _) {
          context.showDeferredSnackIfNeeded(viewModel.consumeActionError());

          if (viewModel.isLoading && !viewModel.hasLoaded) {
            return Scaffold(
              appBar: _settingsAppBar(context),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          if (viewModel.hasError && !viewModel.hasLoaded) {
            return Scaffold(
              appBar: _settingsAppBar(context),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    viewModel.errorMessage ?? context.l10n.homeFailedLoad,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: viewModel.load,
                    child: Text(context.l10n.homeRetry),
                  ),
                ],
              ).center(),
            );
          }

          return Scaffold(
            backgroundColor: context.appColors.bgSecondary,
            appBar: _settingsAppBar(context),
            body: context.settingsScreenContent(
              viewModel: viewModel,
              onThemeTap: () => _openThemePicker(context, viewModel),
              onLanguageTap: () => _openLanguagePicker(context, viewModel),
              onNotificationChanged: viewModel.changeNotifications,
              onDeleteTap: () => _openDeleteAccountSheet(context, viewModel),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _settingsAppBar(BuildContext context) {
    final colors = context.appColors;

    return AppBar(
      backgroundColor: colors.bgSecondary,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: colors.textPrimary),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Future<void> _openThemePicker(
    BuildContext context,
    SettingsViewModel viewModel,
  ) async {
    final selected = await AppBottomSheet.show<ThemePreference>(
      context: context,
      title: context.l10n.settingsAppTheme,
      showDragHandle: true,
      child: context.settingsThemePickerSheet(
        selected: viewModel.themePreference,
        onSelect: (value) => Navigator.of(context).pop(value),
      ),
    );

    if (!context.mounted || selected == null) return;

    final themeVariant = await viewModel.changeTheme(selected);
    if (!context.mounted || themeVariant == null) return;

    context.appController.setThemeVariant(themeVariant);
  }

  Future<void> _openLanguagePicker(
    BuildContext context,
    SettingsViewModel viewModel,
  ) async {
    final selected = await AppBottomSheet.show<PreferredLocale>(
      context: context,
      title: context.l10n.settingsSelectLanguage,
      showDragHandle: true,
      child: context.settingsLanguagePickerSheet(
        selected: viewModel.preferredLocale,
        onSelect: (value) => Navigator.of(context).pop(value),
      ),
    );

    if (!context.mounted || selected == null) return;

    final locale = await viewModel.changeLanguage(selected);
    if (!context.mounted || locale == null) return;

    context.appController.setLocale(Locale(locale.name));
  }

  Future<void> _openDeleteAccountSheet(
    BuildContext context,
    SettingsViewModel viewModel,
  ) async {
    await AppBottomSheet.show<void>(
      context: context,
      showDragHandle: true,
      isDismissible: true,
      child: AnimatedBuilder(
        animation: viewModel,
        builder: (sheetContext, _) {
          return sheetContext.settingsDeleteAccountSheet(
            isDeleting: viewModel.isDeletingAccount,
            onCancel: () => Navigator.of(sheetContext).pop(),
            onDelete: () => _deleteAccount(context, viewModel),
          );
        },
      ),
    );
  }

  Future<void> _deleteAccount(
    BuildContext context,
    SettingsViewModel viewModel,
  ) async {
    final success = await viewModel.deleteAccount();
    if (!context.mounted || !success) return;

    Navigator.of(context).pop();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SplashScreen()),
      (route) => false,
    );
  }

}
