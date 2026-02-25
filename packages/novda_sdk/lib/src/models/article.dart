import 'package:equatable/equatable.dart';

int _asInt(Object? value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

String _asString(Object? value, {String fallback = ''}) {
  if (value == null) return fallback;
  final asString = value.toString();
  if (asString.isEmpty) return fallback;
  return asString;
}

bool _asBool(Object? value, {bool fallback = false}) {
  if (value is bool) return value;

  final normalized = value?.toString().trim().toLowerCase();
  if (normalized == 'true' || normalized == '1') return true;
  if (normalized == 'false' || normalized == '0') return false;

  return fallback;
}

DateTime? _asDateTime(Object? value) {
  if (value == null) return null;

  if (value is DateTime) return value;
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value);
  }

  return null;
}

List<Topic> _asTopics(Object? value) {
  if (value is! List<dynamic>) return const [];

  return value
      .whereType<Map<String, dynamic>>()
      .map(Topic.fromJson)
      .toList(growable: false);
}

/// Topic model
class Topic extends Equatable {
  const Topic({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    required this.isPopular,
    required this.position,
    required this.coverImageUrl,
  });

  final int id;
  final String slug;
  final String title;
  final String description;
  final bool isPopular;
  final int position;
  final String coverImageUrl;

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: _asInt(json['id']),
      slug: _asString(json['slug']),
      title: _asString(json['title']),
      description: _asString(json['description']),
      isPopular: _asBool(json['is_popular']),
      position: _asInt(json['position']),
      coverImageUrl: _asString(json['cover_image_url'] ?? json['cover_image']),
    );
  }

  @override
  List<Object?> get props => [
    id,
    slug,
    title,
    description,
    isPopular,
    position,
    coverImageUrl,
  ];
}

/// Article list item model
class ArticleListItem extends Equatable {
  const ArticleListItem({
    required this.slug,
    required this.title,
    required this.excerpt,
    required this.readingTime,
    this.publishAt,
    required this.heroImageUrl,
    required this.topics,
    required this.viewCount,
    required this.isSaved,
  });

  final String slug;
  final String title;
  final String excerpt;
  final int readingTime;
  final DateTime? publishAt;
  final String heroImageUrl;
  final List<Topic> topics;
  final int viewCount;
  final bool isSaved;

  factory ArticleListItem.fromJson(Map<String, dynamic> json) {
    return ArticleListItem(
      slug: _asString(json['slug']),
      title: _asString(json['title']),
      excerpt: _asString(json['excerpt']),
      readingTime: _asInt(json['reading_time']),
      publishAt: _asDateTime(json['publish_at']),
      heroImageUrl: _asString(json['hero_image_url'] ?? json['hero_image']),
      topics: _asTopics(json['topics']),
      viewCount: _asInt(json['view_count']),
      isSaved: _asBool(json['is_saved'] ?? json['saved']),
    );
  }

  @override
  List<Object?> get props => [
    slug,
    title,
    excerpt,
    readingTime,
    publishAt,
    heroImageUrl,
    topics,
    viewCount,
    isSaved,
  ];
}

/// Article detail model
class ArticleDetail extends Equatable {
  const ArticleDetail({
    required this.slug,
    required this.title,
    required this.excerpt,
    required this.readingTime,
    this.publishAt,
    required this.heroImageUrl,
    required this.topics,
    required this.body,
    required this.viewCount,
    required this.isSaved,
  });

  final String slug;
  final String title;
  final String excerpt;
  final int readingTime;
  final DateTime? publishAt;
  final String heroImageUrl;
  final List<Topic> topics;
  final String body;
  final int viewCount;
  final bool isSaved;

  factory ArticleDetail.fromJson(Map<String, dynamic> json) {
    return ArticleDetail(
      slug: _asString(json['slug']),
      title: _asString(json['title']),
      excerpt: _asString(json['excerpt']),
      readingTime: _asInt(json['reading_time']),
      publishAt: _asDateTime(json['publish_at']),
      heroImageUrl: _asString(json['hero_image_url'] ?? json['hero_image']),
      topics: _asTopics(json['topics']),
      body: _asString(json['body']),
      viewCount: _asInt(json['view_count']),
      isSaved: _asBool(json['is_saved'] ?? json['saved']),
    );
  }

  @override
  List<Object?> get props => [
    slug,
    title,
    excerpt,
    readingTime,
    publishAt,
    heroImageUrl,
    topics,
    body,
    viewCount,
    isSaved,
  ];
}

/// Query parameters for article list
class ArticleListQuery {
  const ArticleListQuery({this.query, this.topic});

  final String? query;
  final String? topic;

  Map<String, dynamic> toQueryParams() => {
    if (query != null) 'q': query,
    if (topic != null) 'topic': topic,
  };
}
