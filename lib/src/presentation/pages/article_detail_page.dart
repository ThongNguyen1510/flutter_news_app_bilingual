import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../l10n/app_localizations.dart';
import '../../data/news_repository.dart';
import '../../models/news_article.dart';

class ArticleDetailPage extends StatefulWidget {
  const ArticleDetailPage({super.key, required this.article});

  final NewsArticle article;

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  late Future<String?> _fullContentFuture;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final repository = context.read<NewsRepository>();
      final locale = Localizations.localeOf(context);
      _fullContentFuture = repository.fetchFullContent(
        article: widget.article,
        locale: locale,
      );
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final theme = Theme.of(context);
    final publishedLabel =
        '${widget.article.source} • ${DateFormat.yMMMMEEEEd(locale.toLanguageTag()).format(widget.article.publishedAt.toLocal())}';

    return Scaffold(
      appBar: AppBar(title: Text(widget.article.titleFor(locale))),
      body: FutureBuilder<String?>(
        future: _fullContentFuture,
        builder: (context, snapshot) {
          final hasData =
              snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              (snapshot.data?.trim().isNotEmpty ?? false);

          final bodyChildren = <Widget>[
            if (widget.article.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.article.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) => progress == null
                      ? child
                      : const SizedBox(
                          height: 220,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 220,
                    color: theme.colorScheme.surfaceContainerHighest,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.broken_image_outlined,
                      size: 48,
                      color: theme.colorScheme.onSurface.withAlpha(
                        (0.6 * 255).round(),
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 18),
            Text(
              publishedLabel,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.article.titleFor(locale),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
          ];

          if (!hasData) {
            if (snapshot.hasError) {
              bodyChildren.add(
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    widget.article.contentFor(locale),
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              bodyChildren.add(
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            } else {
              bodyChildren.add(
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    widget.article.contentFor(locale),
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                ),
              );
            }
          } else {
            bodyChildren.add(
              HtmlWidget(
                snapshot.data!,
                renderMode: RenderMode.column,
                textStyle: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
              ),
            );
          }

          if (widget.article.url.isNotEmpty) {
            bodyChildren.add(const SizedBox(height: 24));
            bodyChildren.add(
              FilledButton.icon(
                onPressed: () => _openExternal(widget.article.url),
                icon: const Icon(Icons.open_in_new),
                label: Text(l10n.seeDetails),
              ),
            );
          }

          bodyChildren.add(const SizedBox(height: 32));

          return ListView(
            padding: const EdgeInsets.all(20),
            children: bodyChildren,
          );
        },
      ),
    );
  }

  Future<void> _openExternal(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
