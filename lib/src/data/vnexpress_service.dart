import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';

class VnExpressException implements Exception {
  VnExpressException(this.message);

  final String message;

  @override
  String toString() => 'VnExpressException: $message';
}

class VnExpressService {
  VnExpressService({http.Client? client}) : _client = client ?? http.Client();

  static const _defaultFeed = 'https://vnexpress.net/rss/tin-moi-nhat.rss';

  static const Map<String, String> _categoryFeeds = {
    'all': _defaultFeed,
    'business': 'https://vnexpress.net/rss/kinh-doanh.rss',
    'technology': 'https://vnexpress.net/rss/so-hoa.rss',
    'science': 'https://vnexpress.net/rss/khoa-hoc.rss',
    'sports': 'https://vnexpress.net/rss/the-thao.rss',
    'culture': 'https://vnexpress.net/rss/giai-tri.rss',
  };

  final http.Client _client;

  Future<List<Map<String, dynamic>>> fetchArticles({
    required String category,
    String? keyword,
  }) async {
    final feedUrl = _categoryFeeds[category] ?? _defaultFeed;
    final response = await _client.get(Uri.parse(feedUrl));

    if (response.statusCode != 200) {
      throw VnExpressException(
        'RSS request failed with status ${response.statusCode}',
      );
    }

    final document = XmlDocument.parse(utf8.decode(response.bodyBytes));
    final items = document.findAllElements('item');

    final normalizedKeyword = keyword == null
        ? null
        : _normalize(keyword.toLowerCase().trim());

    final List<Map<String, dynamic>> articles = [];
    for (final item in items) {
      final title =
          item.getElement('title')?.innerText.trim() ?? 'Tin tức tổng hợp';
      final descriptionRaw =
          item.getElement('description')?.innerText.trim() ?? title;
      final description = _stripHtml(descriptionRaw);
      final link = item.getElement('link')?.innerText.trim() ?? '';
      final pubDateRaw = item.getElement('pubDate')?.innerText.trim();
      final pubDate = _parseRssDate(pubDateRaw);
      final enclosureUrl =
          item.getElement('enclosure')?.getAttribute('url')?.trim() ?? '';

      if (normalizedKeyword != null && normalizedKeyword.isNotEmpty) {
        final combinedText = _normalize('$title $description');
        if (!combinedText.contains(normalizedKeyword)) {
          continue;
        }
      }

      articles.add({
        'title': title,
        'description': description,
        'content': description,
        'source': {'name': 'VNExpress'},
        'publishedAt': pubDate.toIso8601String(),
        'url': link,
        'urlToImage': enclosureUrl,
      });
    }

    return articles;
  }

  Future<String?> fetchFullContent(String url) async {
    if (url.isEmpty) return null;

    final ampUrl = _toAmpUrl(url);
    final response = await _client.get(Uri.parse(ampUrl));
    if (response.statusCode != 200) {
      final fallback = await _client.get(Uri.parse(url));
      if (fallback.statusCode != 200) return null;
      return _extractArticleHtml(fallback.bodyBytes);
    }

    return _extractArticleHtml(response.bodyBytes);
  }

  DateTime _parseRssDate(String? value) {
    if (value == null || value.isEmpty) {
      return DateTime.now();
    }
    try {
      final format = DateFormat('EEE, dd MMM yyyy HH:mm:ss Z', 'en_US');
      return format.parseUtc(value).toLocal();
    } catch (_) {
      return DateTime.now();
    }
  }

  String _stripHtml(String input) {
    final decoded = input
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&ldquo;', '"')
        .replaceAll('&rdquo;', '"')
        .replaceAll('&apos;', "'")
        .replaceAll('&lsquo;', "'")
        .replaceAll('&rsquo;', "'")
        .replaceAll('&hellip;', '...')
        .replaceAll('&ndash;', '-');
    return decoded.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  String _normalize(String input) {
    const accentGroups = {
      'a': 'áàạảãâấầậẩẫăắằặẳẵ',
      'e': 'éèẹẻẽêếềệểễ',
      'i': 'íìịỉĩ',
      'o': 'óòọỏõôốồộổỗơớờợởỡ',
      'u': 'úùụủũưứừựửữ',
      'y': 'ýỳỵỷỹ',
      'd': 'đ',
    };

    var output = input.toLowerCase();
    accentGroups.forEach((plain, accents) {
      output = output.replaceAll(RegExp('[$accents]'), plain);
    });
    return output;
  }

  String _toAmpUrl(String url) {
    try {
      final uri = Uri.parse(url);
      if (uri.queryParameters.containsKey('amp') || url.endsWith('/amp')) {
        return url;
      }
      final updated = Map<String, String>.from(uri.queryParameters);
      updated['amp'] = '';
      return uri.replace(queryParameters: updated).toString();
    } catch (_) {
      return url.endsWith('?amp') ? url : '$url?amp';
    }
  }

  String? _extractArticleHtml(List<int> bodyBytes) {
    final document = html_parser.parse(utf8.decode(bodyBytes));
    final selectors = <String>[
      '[data-role="content"]',
      '.fck_detail',
      '.article-content',
      'article',
    ];

    dom.Element? contentNode;
    for (final selector in selectors) {
      final node = document.querySelector(selector);
      if (node != null && node.text.trim().length > 80) {
        contentNode = node;
        break;
      }
    }
    contentNode ??= document.body;
    if (contentNode == null) return null;

    for (final tag in ['script', 'style', 'svg', 'noscript', 'iframe']) {
      contentNode.querySelectorAll(tag).forEach((element) => element.remove());
    }
    contentNode
        .querySelectorAll(
          '.box_brief_info, .box_comment, .social, .list-news, .box_category__list-news',
        )
        .forEach((element) => element.remove());
    contentNode.querySelectorAll('[style]').forEach((element) {
      element.attributes.remove('style');
    });

    return contentNode.innerHtml.trim();
  }
}
