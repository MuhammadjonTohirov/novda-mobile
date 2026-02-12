import 'package:flutter/material.dart';
import 'package:novda/features/auth/view_models/authorization_view_model.dart';
import 'package:provider/provider.dart';

import '../../../core/app/app.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/ui.dart';
import '../../home/home.dart';

class BabyHeightScreen extends StatefulWidget {
  const BabyHeightScreen({super.key});

  @override
  State<BabyHeightScreen> createState() => _BabyHeightScreenState();
}

class _BabyHeightScreenState extends State<BabyHeightScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<AuthorizationViewModel>();
    final height = viewModel.registrationData.height;
    if (height != null) {
      _controller.text = height.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isHeightValid {
    final height = double.tryParse(_controller.text);
    return height != null && height > 0 && height < 200;
  }

  Future<void> _complete() async {
    if (!_isHeightValid) return;

    final viewModel = context.read<AuthorizationViewModel>();
    viewModel.setHeight(double.parse(_controller.text));

    final success = await viewModel.completeRegistration();

    if (!mounted) return;

    if (success && viewModel.createdChild != null) {
      // Select the newly created child
      await viewModel.selectChild(viewModel.createdChild!.id);

      if (!mounted) return;

      final resolvedTheme = await viewModel.resolveThemeVariant();
      if (!mounted) return;
      context.appController.setThemeVariant(resolvedTheme);

      // Navigate to home screen, clearing the navigation stack
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.errorMessage ?? 'Registration failed'),
          backgroundColor: context.appColors.error,
        ),
      );
    }
  }

  Widget _linearProgressIndicator(BuildContext context) {
    final colors = context.appColors;

    return LinearProgressIndicator(
      value: 7 / 7,
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
          return Column(
            children: [
              _HeightInputContent(
                controller: _controller,
                onChanged: (_) => setState(() {}),
                onSubmitted: (_) => _complete(),
              ).expanded(),
              _BottomBar(
                onPressed: _complete,
                isEnabled: _isHeightValid,
                isLoading: viewModel.isLoading,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HeightInputContent extends StatelessWidget {
  const _HeightInputContent({
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          l10n.babyHeightQuestion,
          style: AppTypography.headingL.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.enterHeightCm,
          style: AppTypography.bodyMRegular.copyWith(
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        AppTextField(
          controller: controller,
          label: l10n.heightInCm,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.done,
          autofocus: true,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.onPressed,
    required this.isEnabled,
    this.isLoading = false,
  });

  final VoidCallback onPressed;
  final bool isEnabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.bgPrimary,
        border: Border(top: BorderSide(color: colors.bgSecondary, width: 1)),
      ),
      child: AppButton(
        text: l10n.continueButton,
        onPressed: onPressed,
        isEnabled: isEnabled,
        isLoading: isLoading,
      ).safeArea(top: false),
    );
  }
}
