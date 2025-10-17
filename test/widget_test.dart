import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_news_app_bilingual/main.dart';
import 'package:flutter_news_app_bilingual/src/data/news_repository.dart';
import 'package:flutter_news_app_bilingual/src/data/news_source.dart';
import 'package:flutter_news_app_bilingual/src/models/news_article.dart';

void main() {
  testWidgets('Home screen renders bilingual title', (tester) async {
    await tester.pumpWidget(NewsApp(repository: FakeNewsRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Tin nhanh Việt'), findsOneWidget);
  });
}

class FakeNewsRepository extends NewsRepository {
  @override
  Future<List<NewsArticle>> fetchArticles({
    required Locale locale,
    required NewsSource source,
    String category = 'all',
    String keyword = '',
    bool forceRefresh = false,
  }) async {
    return [
      NewsArticle(
        id: 'fake-${locale.languageCode}',
        category: category,
        titleEn: 'Fake English Title',
        titleVi: 'Fake Vietnamese Title',
        summaryEn: 'Fake English Summary',
        summaryVi: 'Fake Vietnamese Summary',
        contentEn: 'Fake English Content',
        contentVi: 'Fake Vietnamese Content',
        source: 'Test Source',
        publishedAt: DateTime.now(),
        imageUrl: '',
        url: 'https://example.com',
      ),
    ];
  }

  @override
  Future<String?> fetchFullContent({
    required NewsArticle article,
    required Locale locale,
  }) async =>
      article.contentFor(locale);
}
