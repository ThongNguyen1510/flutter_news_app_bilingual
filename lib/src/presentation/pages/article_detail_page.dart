import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/news_article.dart';

class ArticleDetailPage extends StatelessWidget {
  const ArticleDetailPage({super.key, required this.article});

  final NewsArticle article;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final publishedLabel =
        '${article.source} - '
        '${DateFormat.yMMMMEEEEd(locale.toLanguageTag()).format(article.publishedAt.toLocal())}';

    return Scaffold(
      appBar: AppBar(title: Text(article.titleFor(locale))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (article.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                article.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) => progress == null
                    ? child
                    : const SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    size: 48,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 16),
          Text(
            publishedLabel,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            article.titleFor(locale),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(
            article.contentFor(locale),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
