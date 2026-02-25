import 'package:equatable/equatable.dart';

import 'article.dart';

int _asInt(Object? value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

bool? _asNullableBool(Object? value) {
  if (value is bool) return value;

  final normalized = value?.toString().trim().toLowerCase();
  if (normalized == 'true' || normalized == '1') return true;
  if (normalized == 'false' || normalized == '0') return false;

  return null;
}

Map<String, dynamic>? _asMap(Object? value) {
  if (value is Map<String, dynamic>) return value;
  return null;
}

List<dynamic> _extractArticlesList(Map<String, dynamic> json) {
  for (final key in const ['articles', 'results', 'items', 'data']) {
    final value = json[key];
    if (value is List<dynamic>) {
      return value;
    }
  }

  for (final value in json.values) {
    if (value is List<dynamic>) {
      return value;
    }
  }

  return const [];
}

Map<String, dynamic>? _extractPagination(Map<String, dynamic> json) {
  for (final key in const ['pagination', 'meta', 'page_info']) {
    final value = _asMap(json[key]);
    if (value != null) return value;
  }

  final nestedPage = _asMap(json['page']);
  if (nestedPage != null) return nestedPage;

  return null;
}

/// Query parameters for v2 article list endpoint.
class ArticlesV2Query {
  const ArticlesV2Query({this.page, this.pageSize, this.query, this.topic});

  final int? page;
  final int? pageSize;
  final String? query;
  final String? topic;

  Map<String, dynamic> toQueryParams() => {
    if (page != null) 'page': page,
    if (pageSize != null) 'page_size': pageSize,
    if (query != null) 'q': query,
    if (topic != null) 'topic': topic,
  };
}

/// Query parameters for recommended child articles endpoint.
class RecommendedArticlesQuery {
  const RecommendedArticlesQuery({
    required this.childId,
    required this.progressIndex,
    required this.progressType,
  });

  final int childId;
  final int progressIndex;
  final String progressType;

  Map<String, dynamic> toQueryParams() => {
    'progress_index': progressIndex,
    'progress_type': progressType,
  };
}

/// Paginated article list payload for `/api/v2/articles`.
class ArticlesV2Page extends Equatable {
  const ArticlesV2Page({
    required this.articles,
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  final List<ArticleListItem> articles;
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  factory ArticlesV2Page.fromJson(Map<String, dynamic> json) {
    final pagination = _extractPagination(json);

    int readInt(List<Object?> values, {int fallback = 0}) {
      for (final value in values) {
        final parsed = _asInt(value, fallback: -1);
        if (parsed >= 0) return parsed;
      }
      return fallback;
    }

    final page = readInt([
      pagination?['page'],
      json['page'],
      json['current_page'],
    ], fallback: 1);

    final pageSize = readInt([
      pagination?['page_size'],
      pagination?['per_page'],
      json['page_size'],
      json['per_page'],
      json['limit'],
    ], fallback: 0);

    final totalCount = readInt([
      pagination?['total_count'],
      pagination?['total'],
      pagination?['count'],
      json['total_count'],
      json['total'],
      json['count'],
    ], fallback: 0);

    var totalPages = readInt([
      pagination?['total_pages'],
      pagination?['pages'],
      json['total_pages'],
      json['pages'],
    ], fallback: 0);

    if (totalPages == 0 && totalCount > 0 && pageSize > 0) {
      totalPages = (totalCount / pageSize).ceil();
    }

    final explicitHasNext =
        _asNullableBool(pagination?['has_next']) ??
        _asNullableBool(json['has_next']);

    final explicitHasPrevious =
        _asNullableBool(pagination?['has_previous']) ??
        _asNullableBool(pagination?['has_prev']) ??
        _asNullableBool(json['has_previous']) ??
        _asNullableBool(json['has_prev']);

    final hasNext =
        explicitHasNext ?? (totalPages > 0 ? page < totalPages : false);
    final hasPrevious = explicitHasPrevious ?? (page > 1);

    final articles = _extractArticlesList(json)
        .whereType<Map<String, dynamic>>()
        .map(ArticleListItem.fromJson)
        .toList(growable: false);

    return ArticlesV2Page(
      articles: articles,
      page: page <= 0 ? 1 : page,
      pageSize: pageSize,
      totalCount: totalCount,
      totalPages: totalPages,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
    );
  }

  @override
  List<Object?> get props => [
    articles,
    page,
    pageSize,
    totalCount,
    totalPages,
    hasNext,
    hasPrevious,
  ];
}
