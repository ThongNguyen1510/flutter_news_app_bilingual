import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../l10n/app_localizations.dart';
import '../../models/news_article.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({
    super.key,
    required this.article,
    required this.locale,
    required this.onTap,
    required this.ctaLabel,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  final NewsArticle article;
  final Locale locale;
  final VoidCallback onTap;
  final String ctaLabel;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final dateFormat = DateFormat.yMMMMd(locale.toLanguageTag());
    final subtitle = '${article.source} · ${dateFormat.format(article.publishedAt)}';
    final summary = article.summaryFor(locale);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: article.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: theme.colorScheme.surfaceContainerHighest,
                        highlightColor: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.5),
                        child: Container(color: theme.colorScheme.surface),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 48,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      top: 12,
                      child: _FavoriteButton(
                        isFavorite: isFavorite,
                        onPressed: onToggleFavorite,
                        tooltip: isFavorite
                            ? l10n.favoritesRemoveTooltip
                            : l10n.favoritesSaveTooltip,
                      ),
                    ),
                    IgnorePointer(
                      ignoring: true,
                      child: Container(
                        height: 200,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black54],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 18,
                      child: Text(
                        article.titleFor(locale),
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.article_outlined,
                        size: 18,
                        color: theme.colorScheme.primary.withValues(alpha: 0.8),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          subtitle,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                      if (article.imageUrl.isEmpty)
                        _FavoriteButton(
                          isFavorite: isFavorite,
                          onPressed: onToggleFavorite,
                          tooltip: isFavorite
                              ? l10n.favoritesRemoveTooltip
                              : l10n.favoritesSaveTooltip,
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    summary,
                    style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        ctaLabel,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: theme.colorScheme.secondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({
    required this.isFavorite,
    required this.onPressed,
    required this.tooltip,
  });

  final bool isFavorite;
  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface.withValues(alpha: 0.85),
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: tooltip,
        splashRadius: 20,
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
          color: isFavorite
              ? theme.colorScheme.error
              : theme.colorScheme.primary,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
