import 'package:equatable/equatable.dart';

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
      id: json['id'] as int,
      slug: json['slug'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      isPopular: json['is_popular'] as bool? ?? false,
      position: json['position'] as int? ?? 0,
      coverImageUrl: json['cover_image_url'] as String? ?? '',
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
  });

  final String slug;
  final String title;
  final String excerpt;
  final int readingTime;
  final DateTime? publishAt;
  final String heroImageUrl;
  final List<Topic> topics;

  factory ArticleListItem.fromJson(Map<String, dynamic> json) {
    return ArticleListItem(
      slug: json['slug'] as String,
      title: json['title'] as String,
      excerpt: json['excerpt'] as String,
      readingTime: json['reading_time'] as int? ?? 0,
      publishAt: json['publish_at'] != null
          ? DateTime.parse(json['publish_at'] as String)
          : null,
      heroImageUrl: json['hero_image_url'] as String? ?? '',
      topics: (json['topics'] as List<dynamic>?)
              ?.map((e) => Topic.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
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
  });

  final String slug;
  final String title;
  final String excerpt;
  final int readingTime;
  final DateTime? publishAt;
  final String heroImageUrl;
  final List<Topic> topics;
  final String body;

  factory ArticleDetail.fromJson(Map<String, dynamic> json) {
    return ArticleDetail(
      slug: json['slug'] as String,
      title: json['title'] as String,
      excerpt: json['excerpt'] as String,
      readingTime: json['reading_time'] as int? ?? 0,
      publishAt: json['publish_at'] != null
          ? DateTime.parse(json['publish_at'] as String)
          : null,
      heroImageUrl: json['hero_image_url'] as String? ?? '',
      topics: (json['topics'] as List<dynamic>?)
              ?.map((e) => Topic.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      body: json['body'] as String,
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
      ];
}

/// Query parameters for article list
class ArticleListQuery {
  const ArticleListQuery({
    this.query,
    this.topic,
  });

  final String? query;
  final String? topic;

  Map<String, dynamic> toQueryParams() => {
        if (query != null) 'q': query,
        if (topic != null) 'topic': topic,
      };
}
