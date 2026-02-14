part of '../home_screen.dart';

class _ActivitiesGrid extends StatelessWidget {
  const _ActivitiesGrid({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final types = _topDashboardTypes(viewModel.activityTypes);

    if (types.isEmpty) {
      final colors = context.appColors;

      return Text(
        context.l10n.homeNoActivityTypes,
        style: AppTypography.bodyMRegular.copyWith(color: colors.textSecondary),
        textAlign: TextAlign.center,
      ).container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        decoration: BoxDecoration(
          color: colors.bgSecondary,
          borderRadius: BorderRadius.circular(16),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: types.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.31,
      ),
      itemBuilder: (context, index) {
        final type = types[index];
        final latest = viewModel.latestActivitiesByType[type.id];
        final count = viewModel.todayCountByType[type.id] ?? 0;

        return _ActivityTypeTile(
          type: type,
          lastActivity: latest,
          count: count,
        );
      },
    );
  }

  List<ActivityType> _topDashboardTypes(List<ActivityType> allTypes) {
    if (allTypes.isEmpty) return const [];

    final nonOther = <ActivityType>[];
  
    for (final type in allTypes) {
      nonOther.add(type);
    }

    final selected = <ActivityType>[...nonOther.take(5)];
    // first where title is other
    final other = nonOther.firstWhere(_isOtherType, orElse: () => _hardcodedOtherType());

    selected.add(other);

    return selected.take(6).toList();
  }

  bool _isOtherType(ActivityType type) {
    final normalizedSlug = type.slug.trim().toLowerCase();
    final normalizedTitle = type.title.trim().toLowerCase();
    
    return normalizedSlug == 'other' || normalizedTitle == 'other';
  }

  ActivityType _hardcodedOtherType() {
    return const ActivityType(
      id: -1,
      slug: 'other',
      iconUrl: '',
      color: '#706A93',
      hasDuration: false,
      hasQuality: false,
      isActive: true,
      order: 999,
      title: 'Other',
      description: '',
    );
  }
}

class _ActivityTypeTile extends StatelessWidget {
  const _ActivityTypeTile({
    required this.type,
    required this.lastActivity,
    required this.count,
  });

  final ActivityType type;
  final ActivityItem? lastActivity;
  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final baseColor = colors.accent.parseHexOrSelf(type.color);

    return Container(
      decoration: BoxDecoration(
        color: baseColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: baseColor.withValues(alpha: 0.20)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildActivityIcon(baseColor),
              const Spacer(),
              if (count > 0)
                Text(
                  '$count',
                  style: AppTypography.bodyLMedium.copyWith(color: baseColor),
                ).container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
            ],
          ),
          const Spacer(),
          Text(
            type.title,
            style: AppTypography.bodyLMedium.copyWith(color: baseColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          Text(
            _formatLastActivity(context, lastActivity?.startDate),
            style: AppTypography.bodyLRegular.copyWith(color: baseColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _formatLastActivity(BuildContext context, DateTime? dateTime) {
    if (dateTime == null) return '-';

    final local = dateTime.toLocal();
    final now = DateTime.now();

    if (_isSameDate(local, now)) {
      return '${context.l10n.today}, ${DateFormat('HH:mm').format(local)}';
    }

    return DateFormat('MMM d, HH:mm').format(local);
  }

  bool _isSameDate(DateTime lhs, DateTime rhs) {
    return lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day;
  }

  Widget _buildActivityIcon(Color baseColor) {
    final fallbackIcon = Icon(
      _iconForSlug(type.slug),
      size: 34,
      color: baseColor,
    );

    final url = type.iconUrl.trim();

    // if (_isOtherType()) return fallbackIcon;
    if (url.isEmpty) return fallbackIcon;

    return Image.network(
      url,
      width: 32,
      height: 32,
      fit: BoxFit.fill,
      errorBuilder: (_, error, trace) {
        debugPrint("Failed to load image: $url with error: $error");
        return fallbackIcon;
      },
      loadingBuilder: (_, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return fallbackIcon;
      },
    );
  }

  IconData _iconForSlug(String slug) {
    final value = slug.toLowerCase();

    if (value.contains('feed') || value.contains('food')) {
      return Icons.local_drink_outlined;
    }
    if (value.contains('sleep')) {
      return Icons.bedtime_outlined;
    }
    if (value.contains('diaper')) {
      return Icons.baby_changing_station_outlined;
    }
    if (value.contains('bath')) {
      return Icons.bathtub_outlined;
    }
    if (value.contains('med')) {
      return Icons.medication_outlined;
    }

    return Icons.more_horiz;
  }
}
