import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../extensions/extensions.dart';
import '../../theme/app_theme.dart';
import '../ui.dart';
import 'verification_view_model.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key, required this.onSuccess});

  final VoidCallback onSuccess;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool _hasError = false;
  int _resendCountdown = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendCountdown = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() => _resendCountdown--);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _resendCode() async {
    if (_resendCountdown > 0) return;

    final viewModel = context.read<VerificationViewModel>();
    final success = await viewModel.resend();

    if (success && mounted) {
      _startResendTimer();
    }
  }

  Future<void> _verifyCode(String code) async {
    setState(() => _hasError = false);

    final viewModel = context.read<VerificationViewModel>();
    final success = await viewModel.verify(code);

    if (!mounted) return;

    if (success) {
      if (mounted) Navigator.of(context).pop();
      widget.onSuccess();
    } else {
      setState(() => _hasError = true);
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
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: colors.textPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _bodyView(context),
    );
  }

  Widget _bodyView(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;

    return Consumer<VerificationViewModel>(
      builder: (context, viewModel, child) {
        final destination = viewModel.destination;

        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    l10n.enterVerificationCode,
                    style: AppTypography.headingL.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: AppTypography.bodyMRegular.copyWith(
                        color: colors.textSecondary,
                      ),
                      children: [
                        TextSpan(text: '${l10n.codeSentTo} '),
                        TextSpan(
                          text: _maskDestination(destination),
                          style: TextStyle(color: colors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  AppOtpField(
                    length: 6,
                    hasError: _hasError,
                    errorText: _hasError ? l10n.errorWrongCode : null,
                    onCompleted: _verifyCode,
                    onChanged: (code) {
                      if (_hasError) {
                        setState(() => _hasError = false);
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  if (_resendCountdown > 0)
                    Text(
                      '${l10n.sendAgainAfter} 0:${_resendCountdown.toString().padLeft(2, '0')}',
                      style: AppTypography.bodyMRegular.copyWith(
                        color: colors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    )
                  else
                    AppTextButton(
                      text: l10n.resendCode,
                      onPressed: _resendCode,
                    ).center(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String _maskDestination(String dest) {
    if (dest.length < 4) return dest;
    final visibleEnd = dest.substring(dest.length - 2);
    final visibleStart = dest.substring(0, dest.length - 6);
    return '$visibleStart****$visibleEnd';
  }
}
