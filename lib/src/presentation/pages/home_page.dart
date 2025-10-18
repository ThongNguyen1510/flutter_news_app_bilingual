import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../data/article_tracker.dart';
import '../../data/auth_controller.dart';
import '../../data/locale_controller.dart';
import '../../data/news_controller.dart';
import '../../data/news_source.dart';
import '../../models/news_article.dart';
import '../../utils/auth_dialog.dart';
import '../widgets/article_card.dart';
import '../widgets/auth_button.dart';
import '../widgets/category_selector.dart';
import '../widgets/featured_carousel.dart';
import 'article_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _searchController;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    final newsController = context.read<NewsController>();
    _searchController = TextEditingController(text: newsController.searchTerm);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index = newsController.source == NewsSource.vietnam ? 0 : 1;
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: const [
          AuthButton(),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              labelColor: colorScheme.onPrimaryContainer,
              unselectedLabelColor: colorScheme.onSurface.withAlpha(
                (0.6 * 255).round(),
              ),
              tabs: [
                _SourceTab(
                  label: l10n.tabVietnam,
                  emoji: String.fromCharCodes(const [0x1F1FB, 0x1F1F3]),
                ),
                _SourceTab(
                  label: l10n.tabInternational,
                  emoji: String.fromCharCodes(const [0x1F1EC, 0x1F1E7]),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<NewsController>(
        builder: (context, controller, _) {
          final articles = controller.articles;
          final featuredCount = min(3, articles.length);
          final tracker = context.watch<ArticleTracker>();
          final auth = context.read<AuthController>();

          final children = <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest.withAlpha(
                    (0.35 * 255).round(),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  hintText: l10n.searchHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send_rounded),
                    onPressed: () => _handleSearch(context),
                  ),
                ),
                onSubmitted: (_) => _handleSearch(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CategorySelector(
                selectedCategory: controller.selectedCategory,
                onSelected: controller.updateCategory,
              ),
            ),
          ];

          if (controller.lastUpdated != null) {
            final formatted = DateFormat.Hm(
              locale.toLanguageTag(),
            ).format(controller.lastUpdated!.toLocal());
            children.add(
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Text(
                  l10n.lastUpdated(formatted),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurface.withAlpha((0.6 * 255).round()),
                  ),
                ),
              ),
            );
          }

          if (controller.isLoading && articles.isEmpty) {
            children.add(
              const Padding(
                padding: EdgeInsets.only(top: 100),
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          } else if (controller.errorMessage != null && articles.isEmpty) {
            children.add(
              _ErrorState(
                message: controller.errorMessage ?? l10n.newsListError,
                onRetry: controller.loadArticles,
                fallbackMessage: l10n.newsListError,
              ),
            );
          } else if (articles.isEmpty) {
            children.add(
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Center(
                  child: Text(
                    l10n.emptyState,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ),
            );
          } else {
            if (featuredCount > 0) {
              children.add(
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.homeTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              );
              children.add(
                FeaturedCarousel(
                  articles: articles.take(featuredCount).toList(),
                  locale: locale,
                  onArticleTap: (article) => _openDetail(context, article),
                  isFavorite: (article) => tracker.isFavorite(article.id),
                  onToggleFavorite: (article) {
                    if (!_ensureSignedIn(
                      context,
                      l10n,
                      tracker,
                      auth,
                      l10n.favoritesLoginRequired,
                    )) {
                      return;
                    }
                    tracker.toggleFavorite(article);
                  },
                ),
              );
            }

            if (articles.length > featuredCount) {
              children.add(
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.categories,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface.withAlpha(
                          (0.75 * 255).round(),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }

            for (final article in articles.skip(featuredCount)) {
              children.add(
                ArticleCard(
                  article: article,
                  locale: locale,
                  onTap: () => _openDetail(context, article),
                  ctaLabel: l10n.seeDetails,
                  isFavorite: tracker.isFavorite(article.id),
                  onToggleFavorite: () {
                    if (!_ensureSignedIn(
                      context,
                      l10n,
                      tracker,
                      auth,
                      l10n.favoritesLoginRequired,
                    )) {
                      return;
                    }
                    tracker.toggleFavorite(article);
                  },
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
                  padding: const EdgeInsets.only(bottom: 40),
                  children: children,
                ),
              ),
              if (controller.isLoading && articles.isNotEmpty)
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

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) return;
    final localeController = context.read<LocaleController>();
    final newsController = context.read<NewsController>();

    if (_tabController.index == 0) {
      localeController.switchLocale(const Locale('vi'));
      newsController.updateSource(NewsSource.vietnam, const Locale('vi'));
    } else {
      localeController.switchLocale(const Locale('en'));
      newsController.updateSource(NewsSource.international, const Locale('en'));
    }

    if (_searchController.text.isNotEmpty) {
      _searchController.clear();
    }
  }

  void _handleSearch(BuildContext context) {
    final controller = context.read<NewsController>();
    controller.updateSearchTerm(_searchController.text);
    FocusScope.of(context).unfocus();
  }

  void _openDetail(BuildContext context, NewsArticle article) {
    context.read<ArticleTracker>().addToHistory(article);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ArticleDetailPage(article: article)),
    );
  }

  bool _ensureSignedIn(
    BuildContext context,
    AppLocalizations l10n,
    ArticleTracker tracker,
    AuthController auth,
    String message,
  ) {
    if (tracker.hasSignedInUser) {
      return true;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          action: SnackBarAction(
            label: l10n.authSignIn,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              showAuthDialog(context, auth, isRegister: false);
            },
          ),
        ),
      );
    return false;
  }
}

class _SourceTab extends StatelessWidget {
  const _SourceTab({required this.label, required this.emoji});

  final String label;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
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
      padding: const EdgeInsets.only(top: 100),
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
