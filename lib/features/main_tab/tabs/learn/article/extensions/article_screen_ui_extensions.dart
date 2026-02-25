import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../../../core/extensions/extensions.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../extensions/learn_articles_ui_extensions.dart';
import '../view_model/article_screen_view_model.dart';

extension ArticleScreenUiExtensions on BuildContext {
  static const _contentPadding = EdgeInsets.fromLTRB(16, 0, 16, 20);

  Widget articleScreenBody({
    required ArticleScreenViewModel viewModel,
    required Future<void> Function() onRefresh,
    required VoidCallback onBackTap,
    required VoidCallback onBookmarkTap,
    required VoidCallback onHelpfulTap,
  }) {
    final colors = appColors;
    final viewportWidth = MediaQuery.sizeOf(this).width;
    final imageContentWidth = (viewportWidth - 32).clamp(1.0, viewportWidth);
    final rawHtml = viewModel.bodyHtml.isNotEmpty
        ? viewModel.bodyHtml
        : '<p>${viewModel.preview.excerpt}</p>';
    final normalizedHtml = _normalizeRelativeUrls(
      html: rawHtml,
      referenceUrl: viewModel.heroImageUrl,
    );
    final safeHtml = _sanitizeHtml(normalizedHtml);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: _contentPadding,
        children: [
          _articleHeader(
            viewModel: viewModel,
            onBackTap: onBackTap,
            onBookmarkTap: onBookmarkTap,
          ).safeArea(bottom: false),
          const SizedBox(height: 16),
          learnNetworkImage(
            imageUrl: viewModel.heroImageUrl,
            width: double.infinity,
            height: 300,
            borderRadius: BorderRadius.circular(24),
          ),
          const SizedBox(height: 12),
          Html(
            data: safeHtml,
            style: {
              'html': Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
                fontFamily: 'Geist',
                fontSize: FontSize(16),
                lineHeight: LineHeight.number(1.5),
                color: colors.textSecondary,
              ),
              'body': Style(
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
                fontFamily: 'Geist',
                fontSize: FontSize(16),
                lineHeight: LineHeight.number(1.5),
                color: colors.textSecondary,
              ),
              'p': Style(
                margin: Margins.only(bottom: 20),
                color: colors.textSecondary,
              ),
              'h1': Style(
                fontFamily: 'Geist',
                fontSize: FontSize(24),
                fontWeight: FontWeight.w500,
                margin: Margins.only(top: 6, bottom: 10),
                color: colors.textPrimary,
              ),
              'h2': Style(
                fontFamily: 'Geist',
                fontSize: FontSize(20),
                fontWeight: FontWeight.w500,
                margin: Margins.only(top: 6, bottom: 10),
                color: colors.textPrimary,
              ),
              'h3': Style(
                fontFamily: 'Geist',
                fontSize: FontSize(18),
                fontWeight: FontWeight.w500,
                margin: Margins.only(top: 6, bottom: 10),
                color: colors.textPrimary,
              ),
              'strong': Style(
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
              'ul': Style(margin: Margins.only(bottom: 16)),
              'ol': Style(margin: Margins.only(bottom: 16)),
              'li': Style(margin: Margins.only(bottom: 8)),
              'figure': Style(
                display: Display.block,
                margin: Margins.only(top: 4, bottom: 16),
                padding: HtmlPaddings.zero,
                width: Width(imageContentWidth),
                alignment: Alignment.center,
              ),
              'img': Style(
                display: Display.block,
                margin: Margins.only(top: 4, bottom: 16),
                width: Width(imageContentWidth),
              ),
              'a': Style(color: colors.accent),
            },
          ),
          const SizedBox(height: 8),
          _articleHelpfulSection(onHelpfulTap: onHelpfulTap),
          const SizedBox(height: 20),
        ],
      ),
    ).container(color: colors.bgSecondary);
  }

  Widget _articleHeader({
    required ArticleScreenViewModel viewModel,
    required VoidCallback onBackTap,
    required VoidCallback onBookmarkTap,
  }) {
    final colors = appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.arrow_back_rounded, size: 24, color: colors.textPrimary)
            .paddingOnly(right: 8, bottom: 8)
            .inkWell(onTap: onBackTap, borderRadius: BorderRadius.circular(16)),
        const SizedBox(height: 8),
        Text(
          viewModel.title,
          style: AppTypography.headingXL.copyWith(color: colors.textPrimary),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              l10n.learnReadMeta(
                viewModel.readingTime,
                _formatCompactCount(viewModel.viewCount),
              ),
              style: AppTypography.bodyLRegular.copyWith(
                color: colors.textSecondary,
              ),
            ).expanded(),
            if (viewModel.isBookmarkUpdating)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              SizedBox(
                width: 20,
                height: 20,
                child: Image.asset(
                  'assets/images/icon_bookmark_${viewModel.isSaved ? 'check' : 'add'}.png',
                ).sized(width: 20, height: 20),
              ).inkWell(
                onTap: onBookmarkTap,
                borderRadius: BorderRadius.circular(18),
              ),
          ],
        ),
      ],
    );
  }

  Widget _articleHelpfulSection({required VoidCallback onHelpfulTap}) {
    final colors = appColors;

    return Column(
      children: [
        Text(
          l10n.articleHelpfulQuestion,
          style: AppTypography.headingM.copyWith(color: colors.textPrimary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                  'assets/images/icon_thumbs-up.png',
                  color: colors.accent,
                  width: 24,
                  height: 24,
                )
                .paddingOnly(right: 24)
                .inkWell(
                  onTap: onHelpfulTap,
                  borderRadius: BorderRadius.circular(18),
                ),
            Image.asset(
              'assets/images/icon_thumbs-down.png',
              color: colors.textSecondary,
              width: 24,
              height: 24,
            ).inkWell(
              onTap: onHelpfulTap,
              borderRadius: BorderRadius.circular(18),
            ),
          ],
        ),
      ],
    );
  }

  String _formatCompactCount(int count) {
    if (count >= 1000000) {
      final million = (count / 1000000).toStringAsFixed(
        count % 1000000 == 0 ? 0 : 1,
      );
      return '${_trimDecimalZero(million)}M';
    }

    if (count >= 1000) {
      final thousand = (count / 1000).toStringAsFixed(
        count % 1000 == 0 ? 0 : 1,
      );
      return '${_trimDecimalZero(thousand)}K';
    }

    return count.toString();
  }

  String _trimDecimalZero(String value) {
    if (!value.contains('.')) return value;
    return value.replaceFirst(RegExp(r'\.0$'), '');
  }

  String _normalizeRelativeUrls({
    required String html,
    required String referenceUrl,
  }) {
    final origin = _extractOrigin(referenceUrl);
    if (origin == null) return html;

    final srcPattern = RegExp(
      r'''(src\s*=\s*["'])(/[^"']*)(["'])''',
      caseSensitive: false,
    );
    final hrefPattern = RegExp(
      r'''(href\s*=\s*["'])(/[^"']*)(["'])''',
      caseSensitive: false,
    );

    final srcResolved = html.replaceAllMapped(srcPattern, (match) {
      final prefix = match.group(1)!;
      final path = match.group(2)!;
      final suffix = match.group(3)!;
      return '$prefix$origin$path$suffix';
    });

    return srcResolved.replaceAllMapped(hrefPattern, (match) {
      final prefix = match.group(1)!;
      final path = match.group(2)!;
      final suffix = match.group(3)!;
      return '$prefix$origin$path$suffix';
    });
  }

  String? _extractOrigin(String referenceUrl) {
    final uri = Uri.tryParse(referenceUrl);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return null;
    }

    final port = uri.hasPort ? ':${uri.port}' : '';
    return '${uri.scheme}://${uri.host}$port';
  }

  String _sanitizeHtml(String html) {
    var result = html;

    // Drop figure inline width/style classes that can create invalid constraints.
    result = result.replaceAllMapped(
      RegExp(r'<figure\b[^>]*>', caseSensitive: false),
      (_) => '<figure>',
    );

    // Remove inline sizing from images; we control sizing via Html style map.
    result = result.replaceAllMapped(
      RegExp(r'<img\b[^>]*>', caseSensitive: false),
      (match) {
        var tag = match.group(0)!;
        tag = tag.replaceAll(
          RegExp("\\sstyle\\s*=\\s*(\".*?\"|'.*?')", caseSensitive: false),
          '',
        );
        tag = tag.replaceAll(
          RegExp("\\swidth\\s*=\\s*(\".*?\"|'.*?')", caseSensitive: false),
          '',
        );
        tag = tag.replaceAll(
          RegExp("\\sheight\\s*=\\s*(\".*?\"|'.*?')", caseSensitive: false),
          '',
        );
        return tag;
      },
    );

    return result;
  }
}
