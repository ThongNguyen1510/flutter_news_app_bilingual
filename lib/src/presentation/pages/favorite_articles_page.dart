import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../data/article_tracker.dart';
import '../../data/auth_controller.dart';
import '../../models/saved_article.dart';
import '../../utils/auth_dialog.dart';
import 'article_detail_page.dart';
import '../widgets/auth_required_view.dart';

class FavoriteArticlesPage extends StatelessWidget {
  const FavoriteArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.favoritesTitle)),
      body: Consumer2<AuthController, ArticleTracker>(
        builder: (context, auth, tracker, _) {
          if (!tracker.hasSignedInUser) {
            return AuthRequiredView(
              icon: Icons.favorite_border_outlined,
              message: l10n.favoritesLoginRequired,
              actionLabel: l10n.authSignIn,
              onSignIn: () => showAuthDialog(
                context,
                auth,
                isRegister: false,
              ),
            );
          }
          final items = tracker.favorites;
          if (items.isEmpty) {
            return _EmptyState(message: l10n.favoritesEmpty);
          }
          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 24),
            itemBuilder: (context, index) {
              final saved = items[index];
              return _SavedArticleTile(
                article: saved,
                onTap: () => _openArticle(context, saved),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.redAccent),
                  onPressed: () {
                    context
                        .read<ArticleTracker>()
                        .toggleFavorite(saved.toNewsArticle());
                  },
                ),
              );
            },
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemCount: items.length,
          );
        },
      ),
    );
  }

  void _openArticle(BuildContext context, SavedArticle saved) {
    final article = saved.toNewsArticle();
    context.read<ArticleTracker>().addToHistory(article);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ArticleDetailPage(article: article)),
    );
  }
}

class _SavedArticleTile extends StatelessWidget {
  const _SavedArticleTile({
    required this.article,
    required this.onTap,
    this.trailing,
  });

  final SavedArticle article;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final theme = Theme.of(context);
    final date = DateFormat.yMMMd(locale.toLanguageTag())
        .format(article.publishedAt.toLocal());

    return ListTile(
      leading: article.imageUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                article.imageUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 56,
                  height: 56,
                  color: theme.colorScheme.surfaceContainerHighest,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          : CircleAvatar(
              child: Text(_initialFrom(article.source)),
            ),
      title: Text(
        article.titleFor(locale.languageCode),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${article.source} · $date',
        style: theme.textTheme.bodySmall,
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  String _initialFrom(String source) {
    final trimmed = source.trim();
    if (trimmed.isEmpty) return '?';
    return String.fromCharCode(trimmed.runes.first).toUpperCase();
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
