import 'package:flutter/material.dart';

/// Domain model for a news article that stores bilingual content.
/// Ghi chú (VI): Mô hình bài viết tin tức dạng song ngữ (vi/en).
/// Dữ liệu có thể đến từ NewsAPI hoặc RSS VNExpress và được chuẩn hóa
/// về cùng cấu trúc để hiển thị thống nhất trong UI.
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

  final String id; // Định danh duy nhất (thường là URL hoặc sinh từ thời gian)
  final String category; // Danh mục nội bộ (vd: general, business, ...)
  final String titleEn; // Tiêu đề tiếng Anh
  final String titleVi; // Tiêu đề tiếng Việt
  final String summaryEn; // Tóm tắt tiếng Anh
  final String summaryVi; // Tóm tắt tiếng Việt
  final String contentEn; // Nội dung tiếng Anh (nếu chỉ có 1 ngôn ngữ sẽ dùng chung)
  final String contentVi; // Nội dung tiếng Việt (nếu chỉ có 1 ngôn ngữ sẽ dùng chung)
  final String source; // Nguồn bài viết (tên báo/trang)
  final DateTime publishedAt; // Thời điểm xuất bản (local time)
  final String imageUrl; // Ảnh đại diện (có thể rỗng)
  final String url; // Liên kết gốc tới bài viết

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    // Ghi chú (VI): Parse từ JSON “nội bộ” (ví dụ khi lưu/khôi phục cục bộ)
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
    // Ghi chú (VI): Chuẩn hóa dữ liệu nhận từ nguồn bên ngoài (NewsAPI/RSS).
    // Nếu chỉ có một ngôn ngữ, cả trường vi/en sẽ dùng cùng giá trị.
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
      // Nếu không có URL thì sinh id tạm từ danh mục + timestamp
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

  // Trả về tiêu đề theo ngôn ngữ hiện tại
  String titleFor(Locale locale) =>
      locale.languageCode == 'vi' ? titleVi : titleEn;

  // Trả về tóm tắt theo ngôn ngữ hiện tại
  String summaryFor(Locale locale) =>
      locale.languageCode == 'vi' ? summaryVi : summaryEn;

  // Trả về nội dung theo ngôn ngữ hiện tại
  String contentFor(Locale locale) =>
      locale.languageCode == 'vi' ? contentVi : contentEn;
}
