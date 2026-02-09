import 'package:flutter/material.dart';
import 'package:novda_sdk/novda_sdk.dart';
import 'package:provider/provider.dart';

import '../../../core/app/app_controller.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/ui.dart';
import '../view_models/authorization_view_model.dart';
import 'baby_name_screen.dart';

class BabyGenderScreen extends StatelessWidget {
  const BabyGenderScreen({super.key});

  void _continue(BuildContext context) {
    final viewModel = context.read<AuthorizationViewModel>();
    if (!viewModel.registrationData.hasGender) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: viewModel,
          child: const BabyNameScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      appBar: AppBar(
        backgroundColor: colors.bgPrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: _linearProgressIndicator(context),
        actions: [
          const SizedBox(width: 48), // Placeholder for spacing
        ],
      ),
      body: Consumer<AuthorizationViewModel>(
        builder: (context, viewModel, child) {
          final selectedGender = viewModel.registrationData.gender;

          return Column(
            children: [
              _GenderSelectionContent(
                selectedGender: selectedGender,
                onGenderSelected: (gender) {
                  viewModel.setGender(gender);
                  if (gender == Gender.boy) {
                    context.appController
                        .setThemeVariant(ThemeVariant.softBlue);
                  } else {
                    context.appController
                        .setThemeVariant(ThemeVariant.warmOrange);
                  }
                },
              ).expanded(),
              _BottomBar(
                onPressed: () => _continue(context),
                isEnabled: selectedGender != null,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _linearProgressIndicator(BuildContext context) {
    final colors = context.appColors;

    return LinearProgressIndicator(
      value: 3 / 7,
      backgroundColor: colors.bgSecondary,
      valueColor: AlwaysStoppedAnimation<Color>(colors.bgBarOnProgress),
      borderRadius: BorderRadius.circular(2),
    ).container(
      height: 4,
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _GenderSelectionContent extends StatelessWidget {
  const _GenderSelectionContent({
    required this.selectedGender,
    required this.onGenderSelected,
  });

  final Gender? selectedGender;
  final ValueChanged<Gender> onGenderSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          l10n.whoIsYourBaby,
          style: AppTypography.headingL.copyWith(
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.selectBabyGender,
          style: AppTypography.bodyMRegular.copyWith(
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            _GenderCard(
              gender: Gender.boy,
              isSelected: selectedGender == Gender.boy,
              onTap: () => onGenderSelected(Gender.boy),
            ).expanded(),
            const SizedBox(width: 16),
            _GenderCard(
              gender: Gender.girl,
              isSelected: selectedGender == Gender.girl,
              onTap: () => onGenderSelected(Gender.girl),
            ).expanded(),
          ],
        ),
        const SizedBox(height: 32),
        const _ThemeInfoCard(),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.onPressed,
    required this.isEnabled,
  });

  final VoidCallback onPressed;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.bgPrimary,
        border: Border(
          top: BorderSide(color: colors.bgSecondary, width: 1),
        ),
      ),
      child: AppButton(
        text: l10n.continueButton,
        onPressed: onPressed,
        isEnabled: isEnabled,
      ).safeArea(top: false),
    );
  }
}

class _ThemeInfoCard extends StatelessWidget {
  const _ThemeInfoCard();

  void _showThemeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const _ThemeSelectionSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final controller = context.appController;

    final themeName = controller.themeVariant == ThemeVariant.warmOrange
        ? l10n.warm
        : l10n.cold;

    return GestureDetector(
      onTap: () => _showThemeSelector(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.bgSecondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/images/icon_baby.png',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 12),
            Text(
              l10n.appTheme,
              style: AppTypography.bodyMRegular.copyWith(
                color: colors.textPrimary,
              ),
            ),
            const Spacer(),
            Text(
              themeName,
              style: AppTypography.bodyMRegular.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: colors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeSelectionSheet extends StatelessWidget {
  const _ThemeSelectionSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final controller = context.appController;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.bgPrimary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.appTheme,
            style: AppTypography.headingS.copyWith(color: colors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _ThemeOption(
            title: l10n.warm,
            isSelected: controller.themeVariant == ThemeVariant.warmOrange,
            onTap: () {
              controller.setThemeVariant(ThemeVariant.warmOrange);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 12),
          _ThemeOption(
            title: l10n.cold,
            isSelected: controller.themeVariant == ThemeVariant.softBlue,
            onTap: () {
              controller.setThemeVariant(ThemeVariant.softBlue);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? colors.bgSecondary : colors.bgPrimary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colors.accent : colors.border,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTypography.bodyMRegular.copyWith(
                color: colors.textPrimary,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check,
                color: colors.accent,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

class _GenderCard extends StatelessWidget {
  const _GenderCard({
    required this.gender,
    required this.isSelected,
    required this.onTap,
  });

  final Gender gender;
  final bool isSelected;
  final VoidCallback onTap;

  String _getIconPath() {
    return switch (gender) {
      Gender.boy => 'assets/images/icon_baby_boy.png',
      Gender.girl => 'assets/images/icon_baby_girl.png',
      _ => 'assets/images/icon_baby.png',
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final genderName = gender == Gender.boy ? l10n.boy : l10n.girl;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? colors.bgSecondary : colors.bgPrimary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? colors.accent : colors.bgSecondary,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              _getIconPath(),
              width: 32,
              height: 32,
            ),
            const SizedBox(height: 12),
            Text(
              genderName,
              style: AppTypography.bodyLMedium.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}