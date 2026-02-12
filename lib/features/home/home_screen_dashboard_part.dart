part of 'home_screen.dart';

class _HomeDashboardTab extends StatelessWidget {
  const _HomeDashboardTab();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (_) => HomeViewModel(interactor: HomeInteractor())..load(),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, _) {
          _showActionErrorIfAny(context, viewModel);

          if (viewModel.isLoading && !viewModel.hasAnyContent) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.hasError && !viewModel.hasAnyContent) {
            return _HomeLoadErrorView(onRetry: viewModel.load);
          }

          final colors = context.appColors;

          return RefreshIndicator(
            onRefresh: viewModel.load,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                SafeArea(
                  bottom: false,
                  child: _MyChildHeader(
                    onEditDetails: () => _showComingSoon(context),
                  ),
                ),
                const SizedBox(height: 14),
                _ChildInfoCard(
                  childInfo: viewModel.activeChild,
                  childDetails: viewModel.activeChildDetails,
                  onTap: () => _showComingSoon(context),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: colors.bgPrimary,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(
                        title: context.l10n.homeActivities,
                        actionLabel: context.l10n.homeActivityHistory,
                        onActionTap: () => _showComingSoon(context),
                      ),
                      const SizedBox(height: 12),
                      _ActivitiesGrid(viewModel: viewModel),
                      const SizedBox(height: 22),
                      _SectionHeader(
                        title: context.l10n.homeReminders,
                        actionLabel: context.l10n.homeSeeAll,
                        onActionTap: () => _showComingSoon(context),
                      ),
                      const SizedBox(height: 12),
                      _RemindersList(viewModel: viewModel),
                      const SizedBox(height: 14),
                      _AddReminderButton(onTap: () => _showComingSoon(context)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showActionErrorIfAny(BuildContext context, HomeViewModel viewModel) {
    final actionError = viewModel.consumeActionError();
    if (actionError == null || actionError.isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(actionError)));
    });
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(context.l10n.homeComingSoon)));
  }
}

class _HomeLoadErrorView extends StatelessWidget {
  const _HomeLoadErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.homeFailedLoad,
              style: AppTypography.bodyMRegular.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: Text(l10n.homeRetry)),
          ],
        ),
      ),
    );
  }
}

class _MyChildHeader extends StatelessWidget {
  const _MyChildHeader({required this.onEditDetails});

  final VoidCallback onEditDetails;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.l10n.homeMyChild,
          style: AppTypography.headingL.copyWith(color: colors.textPrimary),
        ),
        TextButton(
          onPressed: onEditDetails,
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: Text(
            context.l10n.homeEditDetails,
            style: AppTypography.bodyLMedium.copyWith(
              color: colors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _ChildInfoCard extends StatelessWidget {
  const _ChildInfoCard({
    required this.childInfo,
    required this.childDetails,
    required this.onTap,
  });

  final ChildListItem? childInfo;
  final Child? childDetails;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;

    if (childInfo == null && childDetails == null) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: colors.bgPrimary,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          l10n.homeNoActiveChildSelected,
          style: AppTypography.bodyMRegular.copyWith(
            color: colors.textSecondary,
          ),
        ),
      );
    }

    final name = childDetails?.name ?? childInfo?.name ?? '-';
    final age = childDetails?.ageDisplay ?? childInfo?.ageDisplay ?? '-';
    final gender =
        childDetails?.gender ?? childInfo?.gender ?? Gender.undisclosed;
    final measurements = childDetails?.latestMeasurements;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.bgPrimary,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset(_avatarByGender(gender), width: 56, height: 56),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTypography.headingM.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      age,
                      style: AppTypography.bodyLRegular.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ).expanded(),
                Icon(
                  Icons.chevron_right,
                  color: colors.textSecondary,
                  size: 28,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Divider(height: 1, color: colors.border),
            const SizedBox(height: 12),
            Row(
              children: [
                _InfoMetric(
                  icon: Image.asset(
                    'assets/images/icon_baby.png',
                    width: 22,
                    height: 22,
                  ),
                  label: l10n.homeGender,
                  value: _genderLabel(context, gender),
                ),
                _InfoMetric(
                  icon: Image.asset(
                    'assets/images/icon_scale.png',
                    width: 22,
                    height: 22,
                  ),
                  label: l10n.weight,
                  value: _formatMeasurement(measurements?.weight),
                ),
                _InfoMetric(
                  icon: Image.asset(
                    'assets/images/icon_arrow_topbottom.png',
                    width: 22,
                    height: 22,
                  ),
                  label: l10n.height,
                  value: _formatMeasurement(measurements?.height),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _avatarByGender(Gender gender) {
    return switch (gender) {
      Gender.boy => 'assets/images/icon_baby_boy.png',
      Gender.girl => 'assets/images/icon_baby_girl.png',
      _ => 'assets/images/icon_baby.png',
    };
  }

  String _genderLabel(BuildContext context, Gender gender) {
    final l10n = context.l10n;

    return switch (gender) {
      Gender.boy => l10n.boy,
      Gender.girl => l10n.girl,
      _ => l10n.homeUndisclosed,
    };
  }

  String _formatMeasurement(Measurement? measurement) {
    if (measurement == null) return '-';

    final value = measurement.value;
    final formatted = value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(1);

    return '$formatted ${measurement.unit}';
  }
}

class _InfoMetric extends StatelessWidget {
  const _InfoMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final Widget icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Expanded(
      child: Row(
        children: [
          icon,
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.bodyMRegular.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: AppTypography.bodyLSemiBold.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onActionTap,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onActionTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.headingL.copyWith(color: colors.textPrimary),
        ),
        TextButton(
          onPressed: onActionTap,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            actionLabel,
            style: AppTypography.headingM.copyWith(color: colors.accent),
          ),
        ),
      ],
    );
  }
}
