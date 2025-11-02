import 'dart:convert';

import 'news_article.dart';

/// Lightweight cached representation of a news article
/// stored for favorites/history purposes.
/// Ghi chú (VI): Mô hình dữ liệu rút gọn của bài viết dùng để lưu cục bộ
/// (Yêu thích/Lịch sử) bằng SharedPreferences. Chỉ giữ các trường cần thiết
/// để khôi phục lại `NewsArticle` khi cần hiển thị.
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

  final String id; // ID duy nhất (thường là URL bài viết hoặc sinh từ timestamp)
  final String category; // Danh mục nội bộ (general, business, ...)
  final String titleEn; // Tiêu đề tiếng Anh
  final String titleVi; // Tiêu đề tiếng Việt
  final String summaryEn; // Tóm tắt tiếng Anh
  final String summaryVi; // Tóm tắt tiếng Việt
  final String contentEn; // Nội dung tiếng Anh (có thể rỗng)
  final String contentVi; // Nội dung tiếng Việt (có thể rỗng)
  final String imageUrl; // Ảnh đại diện (nếu có)
  final String source; // Nguồn bài viết (tên báo/trang)
  final DateTime publishedAt; // Thời điểm xuất bản
  final String url; // Liên kết gốc của bài viết

  factory SavedArticle.fromArticle(NewsArticle article) {
    // Ghi chú (VI): Tạo bản lưu cục bộ từ `NewsArticle` đầy đủ
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

  // Chuyển đối tượng sang JSON (để lưu vào SharedPreferences dạng String)
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
    // Parse JSON (từ chuỗi đã lưu) thành đối tượng SavedArticle
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

  // Mã hóa đối tượng thành chuỗi JSON để lưu trữ
  String encode() => jsonEncode(toJson());

  // Giải mã chuỗi JSON đã lưu thành đối tượng
  static SavedArticle decode(String value) =>
      SavedArticle.fromJson(jsonDecode(value) as Map<String, dynamic>);

  // Lấy tiêu đề theo mã ngôn ngữ ('vi' hoặc 'en')
  String titleFor(String languageCode) =>
      languageCode == 'vi' ? titleVi : titleEn;

  // Lấy tóm tắt theo mã ngôn ngữ
  String summaryFor(String languageCode) =>
      languageCode == 'vi' ? summaryVi : summaryEn;

  NewsArticle toNewsArticle() {
    // Chuyển ngược lại thành `NewsArticle` đầy đủ để hiển thị trong UI
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
