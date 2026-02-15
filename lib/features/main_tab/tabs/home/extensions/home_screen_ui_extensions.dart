import 'package:flutter/material.dart';
import 'package:novda_sdk/novda_sdk.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/theme/app_theme.dart';

extension HomeScreenUiExtensions on BuildContext {
  Widget homeLoadErrorView({required VoidCallback onRetry}) {
    final colors = appColors;
    final l10n = this.l10n;

    return Column(
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
    ).paddingAll(24).center();
  }

  Widget homeMyChildHeader({required VoidCallback onEditDetails}) {
    final colors = appColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l10n.homeMyChild,
          style: AppTypography.headingL.copyWith(color: colors.textPrimary),
        ),
        Text(
            l10n.homeEditDetails,
            style: AppTypography.bodyLMedium.copyWith(
              color: colors.textPrimary,
            )
        ).onTap(onEditDetails),
        // TextButton(
        //   onPressed: onEditDetails,
        //   style: TextButton.styleFrom(padding: EdgeInsets.zero),
        //   child: Text(
        //     l10n.homeEditDetails,
        //     style: AppTypography.bodyLMedium.copyWith(
        //       color: colors.textPrimary,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget homeChildInfoCard({
    required ChildListItem? childInfo,
    required Child? childDetails,
    required VoidCallback onTap,
  }) {
    final colors = appColors;

    if (childInfo == null && childDetails == null) {
      return Text(
        l10n.homeNoActiveChildSelected,
        style: AppTypography.bodyMRegular.copyWith(color: colors.textSecondary),
      ).container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: colors.bgPrimary,
          borderRadius: BorderRadius.circular(24),
        ),
      );
    }

    final name = childDetails?.name ?? childInfo?.name ?? '-';
    final age = childDetails?.ageDisplay ?? childInfo?.ageDisplay ?? '-';
    final gender =
        childDetails?.gender ?? childInfo?.gender ?? Gender.undisclosed;
    final measurements = childDetails?.latestMeasurements;

    return Column(
          children: [
            Row(
              children: [
                Image.asset(_avatarByGender(gender), width: 44, height: 44),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTypography.bodyLMedium.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      age,
                      style: AppTypography.bodyMRegular.copyWith(
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
                _homeInfoMetric(
                  icon: Image.asset(
                    'assets/images/icon_baby.png',
                    width: 22,
                    height: 22,
                  ),
                  label: l10n.homeGender,
                  value: _genderLabel(gender),
                ),
                _homeInfoMetric(
                  icon: Image.asset(
                    'assets/images/icon_scale.png',
                    width: 22,
                    height: 22,
                  ),
                  label: l10n.weight,
                  value: _formatMeasurement(measurements?.weight),
                ),
                _homeInfoMetric(
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
        )
        .container(
          decoration: BoxDecoration(
            color: colors.bgPrimary,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
        )
        .inkWell(onTap: onTap, borderRadius: BorderRadius.circular(24));
  }

  Widget homeSectionHeader({
    required String title,
    required String actionLabel,
    required VoidCallback onActionTap,
  }) {
    final colors = appColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.headingS.copyWith(color: colors.textPrimary),
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
            style: AppTypography.bodyMMedium.copyWith(color: colors.accent),
          ),
        ),
      ],
    );
  }

  Widget _homeInfoMetric({
    required Widget icon,
    required String label,
    required String value,
  }) {
    final colors = appColors;

    return Row(
      children: [
        icon,
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTypography.bodySRegular.copyWith(
                color: colors.textSecondary,
              ),
            ),
            Text(
              value,
              style: AppTypography.headingXS.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ],
        ).expanded(),
      ],
    ).expanded();
  }

  String _avatarByGender(Gender gender) {
    return switch (gender) {
      Gender.boy => 'assets/images/img_boy_avatar.png',
      Gender.girl => 'assets/images/img_girl_avatar.png',
      _ => 'assets/images/icon_baby.png',
    };
  }

  String _genderLabel(Gender gender) {
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
