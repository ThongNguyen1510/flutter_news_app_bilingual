import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

class HtmlContentService {
  HtmlContentService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<String?> fetchArticleHtml(String url) async {
    if (url.isEmpty) return null;
    try {
      final uri = Uri.parse(url);
      final response = await _client.get(uri);
      if (response.statusCode != 200) return null;

      final document = html_parser.parse(
        utf8.decode(response.bodyBytes, allowMalformed: true),
      );

      final selectors = <String>[
        'article',
        '[itemprop="articleBody"]',
        '.article-body',
        '.entry-content',
        '#article-body',
        '.post-content',
        '.story-content',
        '.content__article-body',
        '.ArticleBody__content',
      ];

      dom.Element? contentNode;
      for (final selector in selectors) {
        final node = document.querySelector(selector);
        if (node != null && node.text.trim().length > 120) {
          contentNode = node;
          break;
        }
      }
      contentNode ??= document.body;
      if (contentNode == null) return null;

      for (final tag in ['script', 'style', 'noscript', 'svg', 'iframe']) {
        contentNode
            .querySelectorAll(tag)
            .forEach((element) => element.remove());
      }
      contentNode
          .querySelectorAll(
            '[class*="sidebar"], [class*="advert"], [class*="share"], header, footer, nav',
          )
          .forEach((element) => element.remove());
      contentNode.querySelectorAll('[style]').forEach((element) {
        element.attributes.remove('style');
      });

      final html = contentNode.innerHtml.trim();
      if (html.isNotEmpty) {
        return html;
      }

      final text = contentNode.text.trim();
      if (text.isNotEmpty) {
        return text.replaceAll(RegExp(r'\n+'), '<br />');
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}
