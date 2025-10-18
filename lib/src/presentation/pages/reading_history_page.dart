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

class ReadingHistoryPage extends StatelessWidget {
  const ReadingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.historyTitle),
        actions: [
          Consumer<ArticleTracker>(
            builder: (context, tracker, _) {
              final canClear =
                  tracker.hasSignedInUser && tracker.history.isNotEmpty;
              return IconButton(
                icon: const Icon(Icons.delete_sweep_outlined),
                tooltip: l10n.historyClear,
                onPressed: canClear
                    ? () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (dialogContext) {
                            return AlertDialog(
                              title: Text(l10n.historyClear),
                              content: Text(l10n.historyClearConfirm),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(false),
                                  child: Text(
                                    MaterialLocalizations.of(context)
                                        .cancelButtonLabel,
                                  ),
                                ),
                                FilledButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(true),
                                  child: Text(
                                    MaterialLocalizations.of(context)
                                        .okButtonLabel,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                        if (confirmed == true) {
                          await tracker.clearHistory();
                        }
                      }
                    : null,
              );
            },
          ),
        ],
      ),
      body: Consumer2<AuthController, ArticleTracker>(
        builder: (context, auth, tracker, _) {
          if (!tracker.hasSignedInUser) {
            return AuthRequiredView(
              icon: Icons.history_toggle_off,
              message: l10n.historyLoginRequired,
              actionLabel: l10n.authSignIn,
              onSignIn: () => showAuthDialog(
                context,
                auth,
                isRegister: false,
              ),
            );
          }
          final items = tracker.history;
          if (items.isEmpty) {
            return _EmptyState(message: l10n.historyEmpty);
          }
          return ListView.separated(
            padding: const EdgeInsets.only(bottom: 24),
            itemBuilder: (context, index) {
              final saved = items[index];
              return _SavedHistoryTile(
                article: saved,
                position: index + 1,
                onTap: () => _openArticle(context, saved),
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

class _SavedHistoryTile extends StatelessWidget {
  const _SavedHistoryTile({
    required this.article,
    required this.position,
    required this.onTap,
  });

  final SavedArticle article;
  final int position;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final languageCode = Localizations.localeOf(context).languageCode;
    final date = DateFormat.yMMMd(languageCode).format(article.publishedAt);
    final theme = Theme.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primary,
        child: Text(
          '$position',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ),
      title: Text(
        article.titleFor(languageCode),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text('${article.source} · $date'),
      onTap: onTap,
    );
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
              Icons.history_toggle_off,
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
