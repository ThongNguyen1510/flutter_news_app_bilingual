import 'dart:ui';

import '../models/news_article.dart';
import 'news_api_service.dart';
import 'news_source.dart';
import 'vnexpress_service.dart';
import 'html_content_service.dart';

/// Fetches news data from NewsAPI.org and VNExpress RSS, with caching support.
/// Ghi chú (VI): Lớp trung gian truy vấn dữ liệu từ 2 nguồn (NewsAPI quốc tế
/// và RSS VNExpress), chuẩn hóa về `NewsArticle`, đồng thời có cache đơn giản
/// theo khóa (nguồn + locale + danh mục + từ khóa).
class NewsRepository {
  NewsRepository({
    NewsApiService? apiService,
    VnExpressService? vnExpressService,
    HtmlContentService? htmlContentService,
  }) : _apiService = apiService ?? NewsApiService(),
       _vnExpressService = vnExpressService ?? VnExpressService(),
       _htmlContentService = htmlContentService ?? HtmlContentService();

  final NewsApiService _apiService;
  final VnExpressService _vnExpressService;
  final HtmlContentService _htmlContentService;
  final Map<String, List<NewsArticle>> _cache = {}; // Cache trong bộ nhớ

  // Lấy danh sách bài viết từ nguồn tương ứng và chuyển sang domain model
  Future<List<NewsArticle>> fetchArticles({
    required Locale locale,
    required NewsSource source,
    String category = 'all',
    String keyword = '',
    bool forceRefresh = false,
  }) async {
    final trimmedKeyword = keyword.trim();
    final cacheKey = _cacheKey(locale, source, category, trimmedKeyword);
    if (!forceRefresh && _cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    List<Map<String, dynamic>> articlesJson;
    if (source == NewsSource.vietnam) {
      // VN: dùng RSS của VNExpress
      articlesJson = await _vnExpressService.fetchArticles(
        category: category,
        keyword: trimmedKeyword.isEmpty ? null : trimmedKeyword,
      );
    } else {
      // Quốc tế: gọi NewsAPI.org (cần NEWS_API_KEY)
      final apiCategory = _mapCategory(category);
      articlesJson = await _apiService.fetchTopHeadlines(
        locale: locale,
        category: apiCategory,
        query: trimmedKeyword.isNotEmpty ? trimmedKeyword : null,
      );
    }

    final domainCategory = category == 'all' ? 'general' : category;
    final articles = articlesJson
        .map(
          (json) => NewsArticle.fromApi(
            json,
            locale: locale,
            category: domainCategory,
          ),
        )
        .toList(growable: false);

    _cache[cacheKey] = articles; // Lưu vào cache để dùng lại
    return articles;
  }

  void clearCache() => _cache.clear();

  // Lấy nội dung chi tiết: ưu tiên parse HTML từ nguồn (VNExpress/website)
  // nếu không có thì fallback về content tóm tắt theo locale.
  Future<String?> fetchFullContent({
    required NewsArticle article,
    required Locale locale,
  }) async {
    final lowerSource = article.source.toLowerCase();
    if (lowerSource.contains('vnexpress') && article.url.isNotEmpty) {
      return await _vnExpressService.fetchFullContent(article.url);
    }

    if (article.url.isNotEmpty) {
      final html = await _htmlContentService.fetchArticleHtml(article.url);
      if (html != null && html.trim().isNotEmpty) {
        return html;
      }
    }

    return article.contentFor(locale);
  }

  String _cacheKey(
    Locale locale,
    NewsSource source,
    String category,
    String keyword,
  ) => '${source.name}_${locale.languageCode}_${category}_$keyword';

  // Map danh mục của app sang danh mục của NewsAPI nếu cần
  String? _mapCategory(String category) {
    switch (category) {
      case 'all':
        return null;
      case 'culture':
        return 'entertainment';
      default:
        return category;
    }
  }
}
