import 'dart:ui';

import '../models/news_article.dart';
import 'news_api_service.dart';

/// Fetches news data from NewsAPI.org and applies lightweight caching.
class NewsRepository {
  NewsRepository({NewsApiService? apiService})
    : _apiService = apiService ?? NewsApiService();

  final NewsApiService _apiService;
  final Map<String, List<NewsArticle>> _cache = {};

  Future<List<NewsArticle>> fetchArticles({
    required Locale locale,
    String category = 'all',
    String keyword = '',
    bool forceRefresh = false,
  }) async {
    final cacheKey = _cacheKey(locale, category, keyword);
    if (!forceRefresh && _cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    final apiCategory = _mapCategory(category);
    final articlesJson = await _apiService.fetchTopHeadlines(
      locale: locale,
      category: apiCategory,
      query: keyword.isNotEmpty ? keyword : null,
    );

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

  String _cacheKey(Locale locale, String category, String keyword) =>
      '${locale.languageCode}_${category}_${keyword.trim()}';

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
