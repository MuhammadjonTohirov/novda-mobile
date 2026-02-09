import 'package:flutter/material.dart';
import 'package:novda/features/auth/view_models/authorization_view_model.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/ui.dart';
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

  Widget _linearProgressIndicator(BuildContext context) {
    final colors = context.appColors;

    return LinearProgressIndicator(
      value: 6 / 7,
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
      body: Column(
        children: [
          _WeightInputContent(
            controller: _controller,
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _continue(),
          ).expanded(),
          _BottomBar(
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