import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../data/news_controller.dart';
import '../../models/news_article.dart';
import '../widgets/article_card.dart';
import '../widgets/category_selector.dart';
import '../widgets/language_toggle.dart';
import 'article_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final initialTerm = context.read<NewsController>().searchTerm;
    _searchController = TextEditingController(text: initialTerm);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: const [LanguageToggle()],
      ),
      body: Consumer<NewsController>(
        builder: (context, controller, _) {
          final children = <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: l10n.searchHint,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _handleSearch(context),
                  ),
                ),
                onSubmitted: (_) => _handleSearch(context),
              ),
            ),
            CategorySelector(
              selectedCategory: controller.selectedCategory,
              onSelected: controller.updateCategory,
            ),
          ];

          if (controller.lastUpdated != null) {
            final timeFormat = DateFormat.Hm(locale.toLanguageTag());
            final formatted = timeFormat.format(
              controller.lastUpdated!.toLocal(),
            );
            children.add(
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  l10n.lastUpdated(formatted),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            );
          }

          if (controller.isLoading && controller.articles.isEmpty) {
            children.add(
              const Padding(
                padding: EdgeInsets.only(top: 80),
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          } else if (controller.errorMessage != null &&
              controller.articles.isEmpty) {
            children.add(
              _ErrorState(
                message: controller.errorMessage ?? l10n.newsListError,
                onRetry: controller.loadArticles,
                fallbackMessage: l10n.newsListError,
              ),
            );
          } else if (controller.articles.isEmpty) {
            children.add(
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Center(
                  child: Text(
                    l10n.emptyState,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            );
          } else {
            for (final article in controller.articles) {
              children.add(
                ArticleCard(
                  article: article,
                  locale: locale,
                  onTap: () => _openDetail(context, article),
                  ctaLabel: l10n.seeDetails,
                ),
              );
            }
          }

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () => controller.loadArticles(forceRefresh: true),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 32),
                  children: children,
                ),
              ),
              if (controller.isLoading && controller.articles.isNotEmpty)
                const Align(
                  alignment: Alignment.topCenter,
                  child: LinearProgressIndicator(),
                ),
            ],
          );
        },
      ),
    );
  }

  void _handleSearch(BuildContext context) {
    final controller = context.read<NewsController>();
    controller.updateSearchTerm(_searchController.text);
    FocusScope.of(context).unfocus();
  }

  void _openDetail(BuildContext context, NewsArticle article) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ArticleDetailPage(article: article)),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
    required this.fallbackMessage,
  });

  final String message;
  final Future<void> Function({bool forceRefresh}) onRetry;
  final String fallbackMessage;

  @override
  Widget build(BuildContext context) {
    final displayMessage = message.isEmpty ? fallbackMessage : message;

    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              displayMessage,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => onRetry(forceRefresh: true),
            child: Text(AppLocalizations.of(context).retry),
          ),
        ],
      ),
    );
  }
}
