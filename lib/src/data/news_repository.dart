import 'dart:ui';

import '../models/news_article.dart';
import 'news_api_service.dart';
import 'news_source.dart';
import 'vnexpress_service.dart';
import 'html_content_service.dart';

/// Fetches news data from NewsAPI.org and VNExpress RSS, with caching support.
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
  final Map<String, List<NewsArticle>> _cache = {};

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
      articlesJson = await _vnExpressService.fetchArticles(
        category: category,
        keyword: trimmedKeyword.isEmpty ? null : trimmedKeyword,
      );
    } else {
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

    _cache[cacheKey] = articles;
    return articles;
  }

  void clearCache() => _cache.clear();

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
