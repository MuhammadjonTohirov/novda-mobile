import 'package:flutter/material.dart';
import 'package:novda/features/auth/view_models/authorization_view_model.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/ui.dart';
import 'baby_weight_screen.dart';

class BabyBirthdateScreen extends StatefulWidget {
  const BabyBirthdateScreen({super.key});

  @override
  State<BabyBirthdateScreen> createState() => _BabyBirthdateScreenState();
}

class _BabyBirthdateScreenState extends State<BabyBirthdateScreen> {
  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<AuthorizationViewModel>();
    final birthdate = viewModel.registrationData.birthdate;

    if (birthdate != null) {
      _dayController.text = birthdate.day.toString();
      _monthController.text = birthdate.month.toString();
      _yearController.text = birthdate.year.toString();
    } else {
      _yearController.text = DateTime.now().year.toString();
    }
  }

  @override
  void dispose() {
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  bool get _isDateValid {
    final day = int.tryParse(_dayController.text);
    final month = int.tryParse(_monthController.text);
    final year = int.tryParse(_yearController.text);

    if (day == null || month == null || year == null) return false;
    if (day < 1 || day > 31) return false;
    if (month < 1 || month > 12) return false;
    if (year < 1900 || year > DateTime.now().year) return false;

    try {
      final date = DateTime(year, month, day);
      return date.isBefore(DateTime.now().add(const Duration(days: 1)));
    } catch (e) {
      return false;
    }
  }

  DateTime? get _selectedDate {
    if (!_isDateValid) return null;
    return DateTime(
      int.parse(_yearController.text),
      int.parse(_monthController.text),
      int.parse(_dayController.text),
    );
  }

  void _continue() {
    if (!_isDateValid || _selectedDate == null) return;

    final viewModel = context.read<AuthorizationViewModel>();
    viewModel.setBirthdate(_selectedDate!);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: viewModel,
          child: const BabyWeightScreen(),
        ),
      ),
    );
  }

  Widget _linearProgressIndicator(BuildContext context) {
    final colors = context.appColors;

    return LinearProgressIndicator(
      value: 5 / 7,
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
          _BirthdateInputContent(
            dayController: _dayController,
            monthController: _monthController,
            yearController: _yearController,
            onChanged: (_) => setState(() {}),
          ).expanded(),
          _BottomBar(
            onPressed: _continue,
            isEnabled: _isDateValid,
          ),
        ],
      ),
    );
  }
}

class _BirthdateInputContent extends StatelessWidget {
  const _BirthdateInputContent({
    required this.dayController,
    required this.monthController,
    required this.yearController,
    required this.onChanged,
  });

  final TextEditingController dayController;
  final TextEditingController monthController;
  final TextEditingController yearController;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          l10n.babyBirthdateQuestion,
          style: AppTypography.headingL.copyWith(
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.enterBabyBirthdate,
          style: AppTypography.bodyMRegular.copyWith(
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            _DateField(
              controller: dayController,
              label: l10n.day,
              maxLength: 2,
              onChanged: onChanged,
            ).expanded(),
            const SizedBox(width: 12),
            _DateField(
              controller: monthController,
              label: l10n.month,
              maxLength: 2,
              onChanged: onChanged,
            ).expanded(),
            const SizedBox(width: 12),
            _DateField(
              controller: yearController,
              label: l10n.year,
              maxLength: 4,
              onChanged: onChanged,
            ).expanded(flex: 2),
          ],
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.controller,
    required this.label,
    required this.maxLength,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final int maxLength;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: controller.text.isNotEmpty
              ? colors.accent
              : Colors.transparent,
          width: controller.text.isNotEmpty ? 1 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTypography.bodySRegular.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.start,
            maxLength: maxLength,
            style: AppTypography.bodyLRegular.copyWith(
              color: colors.textPrimary,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              counterText: '',
              contentPadding: EdgeInsets.zero,
              isDense: true,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
            ),
            onChanged: onChanged,
          ),
        ],
      ),
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