import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../../../core/theme/app_theme.dart';
import '../view_model/article_screen_view_model.dart';

extension ArticleScreenHtmlExtensions on BuildContext {
  static const _contentHorizontalPadding = 32.0;

  Widget articleHtmlContent({required ArticleScreenViewModel viewModel}) {
    final viewportWidth = MediaQuery.sizeOf(this).width;
    final imageContentWidth = (viewportWidth - _contentHorizontalPadding).clamp(
      1.0,
      viewportWidth,
    );

    final rawHtml = viewModel.bodyHtml.isNotEmpty
        ? viewModel.bodyHtml
        : '<p>${viewModel.preview.excerpt}</p>';
    final normalizedHtml = _normalizeRelativeUrls(
      html: rawHtml,
      referenceUrl: viewModel.heroImageUrl,
    );
    final safeHtml = _sanitizeHtml(normalizedHtml);

    final colors = appColors;
    return Html(data: safeHtml, style: _htmlStyles(colors, imageContentWidth));
  }

  Map<String, Style> _htmlStyles(
    AppColorScheme colors,
    double imageContentWidth,
  ) {
    return {
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
      'p': Style(margin: Margins.only(bottom: 20), color: colors.textSecondary),
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
      'strong': Style(fontWeight: FontWeight.w600, color: colors.textPrimary),
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
    };
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

    result = result.replaceAllMapped(
      RegExp(r'<figure\b[^>]*>', caseSensitive: false),
      (_) => '<figure>',
    );

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
