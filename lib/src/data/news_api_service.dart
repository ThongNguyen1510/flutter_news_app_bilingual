import 'dart:convert';
import 'dart:ui';

import 'package:http/http.dart' as http;

class NewsApiException implements Exception {
  NewsApiException(this.message);

  final String message;

  @override
  String toString() => 'NewsApiException: $message';
}

class NewsApiService {
  NewsApiService({http.Client? client, String? apiKey})
    : _client = client ?? http.Client(),
      _apiKey = apiKey ?? const String.fromEnvironment('NEWS_API_KEY');

  static const _authority = 'newsapi.org';
  static const _topHeadlinesPath = '/v2/top-headlines';

  final http.Client _client;
  final String _apiKey;

  Future<List<Map<String, dynamic>>> fetchTopHeadlines({
    required Locale locale,
    String? category,
    String? query,
  }) async {
    if (_apiKey.isEmpty) {
      throw NewsApiException(
        'Missing NEWS_API_KEY. Provide it via --dart-define=NEWS_API_KEY=your_key',
      );
    }

    final queryParameters = <String, String>{
      'country': _countryForLocale(locale),
      'pageSize': '20',
    };

    if (category != null && category.isNotEmpty) {
      queryParameters['category'] = category;
    }
    if (query != null && query.trim().isNotEmpty) {
      queryParameters['q'] = query.trim();
    }

    final uri = Uri.https(_authority, _topHeadlinesPath, queryParameters);
    final response = await _client.get(uri, headers: {'X-Api-Key': _apiKey});

    if (response.statusCode != 200) {
      throw NewsApiException(
        'Request failed with status ${response.statusCode}: ${response.body}',
      );
    }

    final decoded = json.decode(response.body) as Map<String, dynamic>;
    if (decoded['status'] != 'ok') {
      throw NewsApiException(decoded['message'] as String? ?? 'Unknown error');
    }

    final articles = decoded['articles'] as List<dynamic>?;
    if (articles == null) {
      return const [];
    }

    return articles.whereType<Map<String, dynamic>>().toList(growable: false);
  }

  String _countryForLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'us':
      case 'en':
        return 'us';
      case 'gb':
        return 'gb';
      default:
        return 'us';
    }
  }
}
