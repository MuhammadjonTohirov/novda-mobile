import 'package:flutter/material.dart';
import 'package:novda/features/auth/view_models/authorization_view_model.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/ui.dart';
import '../widgets/auth_bottom_bar.dart';
import '../widgets/auth_step_progress_bar.dart';
import 'baby_height_screen.dart';

class BabyWeightScreen extends StatefulWidget {
  const BabyWeightScreen({super.key});

  @override
  State<BabyWeightScreen> createState() => _BabyWeightScreenState();
}

class _BabyWeightScreenState extends State<BabyWeightScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<AuthorizationViewModel>();
    final weight = viewModel.registrationData.weight;
    if (weight != null) {
      _controller.text = weight.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isWeightValid {
    final weight = double.tryParse(_controller.text);
    return weight != null && weight > 0 && weight < 50;
  }

  void _continue() {
    if (!_isWeightValid) return;

    final viewModel = context.read<AuthorizationViewModel>();
    viewModel.setWeight(double.parse(_controller.text));

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: viewModel,
          child: const BabyHeightScreen(),
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
        title: const AuthStepProgressBar(step: 6),
        actions: [
          const SizedBox(width: 48),
        ],
      ),
      body: Column(
        children: [
          _WeightInputContent(
            controller: _controller,
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _continue(),
          ).expanded(),
          AuthBottomBar(
            onPressed: _continue,
            isEnabled: _isWeightValid,
          ),
        ],
      ),
    );
  }
}

class _WeightInputContent extends StatelessWidget {
  const _WeightInputContent({
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
          l10n.babyWeightQuestion,
          style: AppTypography.headingL.copyWith(
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.enterWeightKg,
          style: AppTypography.bodyMRegular.copyWith(
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        AppTextField(
          controller: controller,
          label: l10n.weightInKg,
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

