import 'package:flutter/material.dart';
import 'package:novda_sdk/novda_sdk.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/ui.dart';
import '../../home/home.dart';
import '../view_models/authorization_view_model.dart';
import 'baby_gender_screen.dart';

class ChildrenSelectionScreen extends StatefulWidget {
  const ChildrenSelectionScreen({super.key});

  @override
  State<ChildrenSelectionScreen> createState() =>
      _ChildrenSelectionScreenState();
}

class _ChildrenSelectionScreenState extends State<ChildrenSelectionScreen> {
  List<ChildListItem>? _children;
  int? _selectedChildId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadChildren();
    });
  }

  Future<void> _loadChildren() async {
    final viewModel = context.read<AuthorizationViewModel>();

    try {
      final children = await viewModel.loadChildren();
      if (!mounted) return;

      setState(() {
        _children = children;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _children = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _continue() async {
    if (_selectedChildId == null) return;

    final viewModel = context.read<AuthorizationViewModel>();

    final success = await viewModel.selectChild(_selectedChildId!);

    if (!mounted || !success) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  void _addNewChild() {
    final viewModel = context.read<AuthorizationViewModel>();
    viewModel.clearRegistrationData();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: viewModel,
          child: const BabyGenderScreen(),
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
          const SizedBox(width: 48),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _ChildrenListContent(
                  children: _children ?? [],
                  selectedChildId: _selectedChildId,
                  onChildSelected: (childId) {
                    setState(() => _selectedChildId = childId);
                  },
                  onAddChild: _addNewChild,
                ).expanded(),
                _BottomBar(
                  onPressed: _continue,
                  isEnabled: _selectedChildId != null,
                ),
              ],
            ),
    );
  }

  Widget _linearProgressIndicator(BuildContext context) {
    final colors = context.appColors;

    return LinearProgressIndicator(
      value: 2 / 7,
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

class _ChildrenListContent extends StatelessWidget {
  const _ChildrenListContent({
    required this.children,
    required this.selectedChildId,
    required this.onChildSelected,
    required this.onAddChild,
  });

  final List<ChildListItem> children;
  final int? selectedChildId;
  final ValueChanged<int> onChildSelected;
  final VoidCallback onAddChild;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          l10n.yourChildren,
          style: AppTypography.headingL.copyWith(
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.whichChildToSelect,
          style: AppTypography.bodyMRegular.copyWith(
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        ...children.map(
          (child) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ChildCard(
              child: child,
              isSelected: selectedChildId == child.id,
              onTap: () => onChildSelected(child.id),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _AddChildButton(onTap: onAddChild),
      ],
    );
  }
}

class _ChildCard extends StatelessWidget {
  const _ChildCard({
    required this.child,
    required this.isSelected,
    required this.onTap,
  });

  final ChildListItem child;
  final bool isSelected;
  final VoidCallback onTap;

  String _getIconPath() {
    return switch (child.gender) {
      Gender.boy => 'assets/images/icon_baby_boy.png',
      Gender.girl => 'assets/images/icon_baby_girl.png',
      _ => 'assets/images/icon_baby.png',
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? colors.bgSecondary : colors.bgPrimary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colors.accent : colors.bgSecondary,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              _getIconPath(),
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  child.name,
                  style: AppTypography.bodyLMedium.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  child.ageDisplay,
                  style: AppTypography.bodySRegular.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ).expanded(),
            Icon(
              Icons.chevron_right,
              color: colors.textSecondary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class _AddChildButton extends StatelessWidget {
  const _AddChildButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: Text(
          l10n.addAChild,
          style: AppTypography.bodyLMedium.copyWith(
            color: colors.accent,
          ),
        ),
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
