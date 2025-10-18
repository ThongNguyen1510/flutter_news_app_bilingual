import 'dart:convert';

import 'news_article.dart';

/// Lightweight cached representation of a news article
/// stored for favorites/history purposes.
class SavedArticle {
  const SavedArticle({
    required this.id,
    required this.category,
    required this.titleEn,
    required this.titleVi,
    required this.summaryEn,
    required this.summaryVi,
    required this.contentEn,
    required this.contentVi,
    required this.imageUrl,
    required this.source,
    required this.publishedAt,
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
  final String imageUrl;
  final String source;
  final DateTime publishedAt;
  final String url;

  factory SavedArticle.fromArticle(NewsArticle article) {
    return SavedArticle(
      id: article.id,
      category: article.category,
      titleEn: article.titleEn,
      titleVi: article.titleVi,
      summaryEn: article.summaryEn,
      summaryVi: article.summaryVi,
      contentEn: article.contentEn,
      contentVi: article.contentVi,
      imageUrl: article.imageUrl,
      source: article.source,
      publishedAt: article.publishedAt,
      url: article.url,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'titleEn': titleEn,
        'titleVi': titleVi,
        'summaryEn': summaryEn,
        'summaryVi': summaryVi,
        'contentEn': contentEn,
        'contentVi': contentVi,
        'imageUrl': imageUrl,
        'source': source,
        'publishedAt': publishedAt.toIso8601String(),
        'url': url,
      };

  factory SavedArticle.fromJson(Map<String, dynamic> json) {
    return SavedArticle(
      id: json['id'] as String,
      category: json['category'] as String? ?? 'general',
      titleEn: json['titleEn'] as String,
      titleVi: json['titleVi'] as String,
      summaryEn: json['summaryEn'] as String,
      summaryVi: json['summaryVi'] as String,
      contentEn: json['contentEn'] as String? ?? '',
      contentVi: json['contentVi'] as String? ?? '',
      imageUrl: json['imageUrl'] as String,
      source: json['source'] as String,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      url: json['url'] as String,
    );
  }

  String encode() => jsonEncode(toJson());

  static SavedArticle decode(String value) =>
      SavedArticle.fromJson(jsonDecode(value) as Map<String, dynamic>);

  String titleFor(String languageCode) =>
      languageCode == 'vi' ? titleVi : titleEn;

  String summaryFor(String languageCode) =>
      languageCode == 'vi' ? summaryVi : summaryEn;

  NewsArticle toNewsArticle() {
    return NewsArticle(
      id: id,
      category: category,
      titleEn: titleEn,
      titleVi: titleVi,
      summaryEn: summaryEn,
      summaryVi: summaryVi,
      contentEn: contentEn,
      contentVi: contentVi,
      source: source,
      publishedAt: publishedAt,
      imageUrl: imageUrl,
      url: url,
    );
  }
}
