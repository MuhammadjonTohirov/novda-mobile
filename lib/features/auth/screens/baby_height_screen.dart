import 'package:flutter/material.dart';
import 'package:novda/features/auth/view_models/authorization_view_model.dart';
import 'package:provider/provider.dart';

import '../../../core/app/app.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/ui.dart';
import '../../main_tab/tabs/home/home.dart';
import '../widgets/auth_bottom_bar.dart';
import '../widgets/auth_step_progress_bar.dart';

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

      final resolvedTheme = await viewModel.resolveThemeVariant(
        selectedChildId: viewModel.createdChild!.id,
      );
      if (!mounted) return;
      context.appController.setThemeVariant(resolvedTheme);

      // Navigate to home screen, clearing the navigation stack
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainTabScreen()),
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
        title: const AuthStepProgressBar(step: 7),
        actions: [
          const SizedBox(width: 48),
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
              AuthBottomBar(
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

