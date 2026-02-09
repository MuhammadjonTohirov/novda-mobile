import 'package:flutter/material.dart';
import 'package:novda/features/auth/view_models/authorization_view_model.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/ui.dart';
import 'baby_birthdate_screen.dart';

class BabyNameScreen extends StatefulWidget {
  const BabyNameScreen({super.key});

  @override
  State<BabyNameScreen> createState() => _BabyNameScreenState();
}

class _BabyNameScreenState extends State<BabyNameScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<AuthorizationViewModel>();
    _controller.text = viewModel.registrationData.babyName ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isNameValid => _controller.text.trim().isNotEmpty;

  void _continue() {
    if (!_isNameValid) return;

    final viewModel = context.read<AuthorizationViewModel>();
    viewModel.setBabyName(_controller.text.trim());

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: viewModel,
          child: const BabyBirthdateScreen(),
        ),
      ),
    );
  }

  Widget _linearProgressIndicator(BuildContext context) {
    final colors = context.appColors;

    return LinearProgressIndicator(
      value: 4 / 7,
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
          _NameInputContent(
            controller: _controller,
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _continue(),
          ).expanded(),
          _BottomBar(
            onPressed: _continue,
            isEnabled: _isNameValid,
          ),
        ],
      ),
    );
  }
}

class _NameInputContent extends StatelessWidget {
  const _NameInputContent({
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
          l10n.babyNameQuestion,
          style: AppTypography.headingL.copyWith(
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.enterBabyName,
          style: AppTypography.bodyMRegular.copyWith(
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        AppTextField(
          controller: controller,
          hint: l10n.babyNameHint,
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