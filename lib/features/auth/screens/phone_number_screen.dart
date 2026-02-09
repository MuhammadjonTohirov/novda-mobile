import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:novda/core/ui/app_checkbox.dart';
import 'package:novda/features/onboarding/onboarding_screen.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/ui.dart';
import '../../home/home.dart';
import '../view_models/authorization_view_model.dart';
import '../../../core/ui/verification/verification_view_model.dart';
import 'baby_gender_screen.dart';
import '../../../core/ui/verification/verification_screen.dart';

class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({super.key});

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  final _controller = TextEditingController();
  bool _isTermsAccepted = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isPhoneValid {
    final phone = _controller.text.replaceAll(RegExp(r'[^\d]'), '');
    return phone.length >= 9;
  }

  Future<void> _continue() async {
    if (!_isPhoneValid || !_isTermsAccepted) return;

    final viewModel = context.read<AuthorizationViewModel>();

    final phoneDigits = _controller.text.replaceAll(RegExp(r'[^\d]'), '');
    final fullPhoneNumber = '+998$phoneDigits';

    final success = await viewModel.requestOtp(fullPhoneNumber);

    if (!mounted || !success) return;
    
    Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => ChangeNotifierProvider<VerificationViewModel>.value(
          value: viewModel,
          child: VerificationScreen(
            onSuccess: () async {
              // Check if user has existing children
              final hasChildren = await viewModel.checkExistingChildren();

              if (!mounted) return;

              if (hasChildren) {
                // User already has children, go to home screen
                _goToHomeScreen();
              } else {
                // User needs to add a child
                _goToBabyGenderScreen();
              }
            },
          ),
        ),
      ),
    );
  }

  void _goToBabyGenderScreen() {
    final viewModel = context.read<AuthorizationViewModel>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: viewModel,
          child: const BabyGenderScreen(),
        ),
      ),
    );
  }

  void _goToHomeScreen() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.bgPrimary,
      appBar: AppBar(
        backgroundColor: colors.bgPrimary,
        surfaceTintColor: colors.bgPrimary,
        elevation: 0,
        leading: const SizedBox(width: 48),
        title: _linearProgressIndicator(context),
        actions: [
          const SizedBox(width: 48), // Placeholder for spacing
        ],
      ),
      body: Consumer<AuthorizationViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              _bodyView(context, viewModel),
              _privacyPolicyView(
                context,
              ).paddingOnly(left: 16, right: 16, bottom: 16),
              _continueButton(context, viewModel: viewModel),
            ],
          );
        },
      ),
    );
  }

  Widget _linearProgressIndicator(BuildContext context) {
    final colors = context.appColors;

    return LinearProgressIndicator(
      value: 1 / 7,
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

  Widget _privacyPolicyView(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 16,
      children: [
        AppCheckbox(
          value: _isTermsAccepted,
          onChanged: (value) {
            setState(() => _isTermsAccepted = value);
          },
        ),
        RichText(
          text: TextSpan(
            style: AppTypography.bodySRegular.copyWith(
              color: colors.textSecondary,
            ),
            children: [
              TextSpan(text: '${l10n.termsCheckboxAcceptance} '),
              TextSpan(
                text: l10n.termsOfUse,
                style: TextStyle(color: colors.textOnly),
              ),
              TextSpan(text: ' ${l10n.and} '),
              TextSpan(
                text: l10n.privacyPolicy,
                style: TextStyle(color: colors.textOnly),
              ),
            ],
          ),
        ).padding(const EdgeInsets.only(top: 12)).expanded(),
      ],
    );
  }

  Widget _continueButton(
    BuildContext context, {
    required AuthorizationViewModel viewModel,
  }) {
    final colors = context.appColors;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.bgPrimary,
        border: Border(top: BorderSide(color: colors.bgSecondary, width: 1)),
      ),
      child: AppButton(
        text: l10n.continueButton,
        onPressed: _continue,
        isEnabled: _isPhoneValid && _isTermsAccepted,
        isLoading: viewModel.isLoading,
      ).safeArea(top: false),
    );
  }

  Widget _bodyView(BuildContext context, AuthorizationViewModel viewModel) {
    final l10n = context.l10n;
    final colors = context.appColors;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          l10n.enterPhoneNumber,
          style: AppTypography.headingL.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.receiveCodeDescription,
          style: AppTypography.bodyMRegular.copyWith(
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        AppPhoneField(
          controller: _controller,
          hint: l10n.phoneNumberHint,
          autofocus: true,
          errorText: viewModel.hasError ? viewModel.errorMessage : null,
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) => _continue(),
        ),
        const SizedBox(height: 24),
      ],
    ).expanded();
  }
}
