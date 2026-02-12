part of 'home_screen.dart';

class _ActivitiesGrid extends StatelessWidget {
  const _ActivitiesGrid({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final types = viewModel.activityTypes.take(6).toList();

    if (types.isEmpty) {
      final colors = context.appColors;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        decoration: BoxDecoration(
          color: colors.bgSecondary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          context.l10n.homeNoActivityTypes,
          style: AppTypography.bodyMRegular.copyWith(
            color: colors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: types.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.12,
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
    final baseColor = _parseColor(type.color, colors.accent);

    return Container(
      decoration: BoxDecoration(
        color: baseColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: baseColor.withValues(alpha: 0.20)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_iconForSlug(type.slug), size: 34, color: baseColor),
              const Spacer(),
              if (count > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$count',
                    style: AppTypography.bodyLMedium.copyWith(color: baseColor),
                  ),
                ),
            ],
          ),
          const Spacer(),
          Text(
            type.title,
            style: AppTypography.headingL.copyWith(color: baseColor),
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

  Color _parseColor(String rawColor, Color fallback) {
    var value = rawColor.trim();
    if (value.isEmpty) return fallback;

    if (value.startsWith('#')) {
      value = value.substring(1);
    }

    if (value.length == 6) {
      value = 'FF$value';
    }

    final intValue = int.tryParse(value, radix: 16);
    if (intValue == null) return fallback;

    return Color(intValue);
  }
}
