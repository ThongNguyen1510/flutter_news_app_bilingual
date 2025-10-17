import 'package:flutter/material.dart';

/// Domain model for a news article that stores bilingual content.
class NewsArticle {
  const NewsArticle({
    required this.id,
    required this.category,
    required this.titleEn,
    required this.titleVi,
    required this.summaryEn,
    required this.summaryVi,
    required this.contentEn,
    required this.contentVi,
    required this.source,
    required this.publishedAt,
    required this.imageUrl,
    required this.url,
  });

  final String id;
  final String category;
  final String titleEn;
  final String titleVi;
  final String summaryEn;
  final String summaryVi;
  final String contentEn;
  final String contentVi;
  final String source;
  final DateTime publishedAt;
  final String imageUrl;
  final String url;

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['id'] as String,
      category: json['category'] as String,
      titleEn: json['title_en'] as String,
      titleVi: json['title_vi'] as String,
      summaryEn: json['summary_en'] as String,
      summaryVi: json['summary_vi'] as String,
      contentEn: json['content_en'] as String,
      contentVi: json['content_vi'] as String,
      source: json['source'] as String,
      publishedAt: DateTime.parse(json['published_at'] as String),
      imageUrl: json['image_url'] as String,
      url: (json['url'] as String?) ?? '',
    );
  }

  factory NewsArticle.fromApi(
    Map<String, dynamic> json, {
    required Locale locale,
    required String category,
  }) {
    final title = (json['title'] as String?)?.trim() ?? 'Untitled';
    final description = (json['description'] as String?)?.trim() ?? '';
    final rawContent = (json['content'] as String?)?.trim();
    final content = (rawContent == null || rawContent.isEmpty)
        ? (description.isEmpty ? title : description)
        : rawContent;
    final source =
        ((json['source'] as Map<String, dynamic>?)?['name'] as String?)
            ?.trim() ??
        'Unknown source';
    final publishedRaw = json['publishedAt'] as String?;
    final publishedAt = publishedRaw != null
        ? DateTime.tryParse(publishedRaw)?.toLocal() ?? DateTime.now()
        : DateTime.now();
    final link = (json['url'] as String?)?.trim();
    final imageUrl = (json['urlToImage'] as String?)?.trim() ?? '';
    final normalizedCategory = category.isEmpty ? 'general' : category;

    return NewsArticle(
      id: link == null || link.isEmpty
          ? '${normalizedCategory}_${publishedAt.microsecondsSinceEpoch}'
          : link,
      category: normalizedCategory,
      titleEn: title,
      titleVi: title,
      summaryEn: description.isEmpty ? content : description,
      summaryVi: description.isEmpty ? content : description,
      contentEn: content,
      contentVi: content,
      source: source,
      publishedAt: publishedAt,
      imageUrl: imageUrl,
      url: link ?? '',
    );
  }

  String titleFor(Locale locale) =>
      locale.languageCode == 'vi' ? titleVi : titleEn;

  String summaryFor(Locale locale) =>
      locale.languageCode == 'vi' ? summaryVi : summaryEn;

  String contentFor(Locale locale) =>
      locale.languageCode == 'vi' ? contentVi : contentEn;
}
