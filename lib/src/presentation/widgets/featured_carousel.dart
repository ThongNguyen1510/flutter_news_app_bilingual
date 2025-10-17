import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../models/news_article.dart';

class FeaturedCarousel extends StatefulWidget {
  const FeaturedCarousel({
    super.key,
    required this.articles,
    required this.locale,
    required this.onArticleTap,
  });

  final List<NewsArticle> articles;
  final Locale locale;
  final ValueChanged<NewsArticle> onArticleTap;

  @override
  State<FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<FeaturedCarousel> {
  late final PageController _controller = PageController(
    viewportFraction: 0.88,
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = widget.articles.take(5).toList(growable: false);
    final indicatorColor = theme.colorScheme.secondary;

    return Column(
      children: [
        SizedBox(
          height: 260,
          child: PageView.builder(
            controller: _controller,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final article = items[index];
              final date = DateFormat.MMMd(
                widget.locale.toLanguageTag(),
              ).format(article.publishedAt);
              final summary = article.summaryFor(widget.locale);
              final bullet = String.fromCharCode(0x2022);

              return GestureDetector(
                onTap: () => widget.onArticleTap(article),
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    double value = 1.0;
                    if (_controller.position.haveDimensions) {
                      value = _controller.page! - index;
                      value = (1 - (value.abs() * 0.2)).clamp(0.85, 1.0);
                    }
                    return Transform.scale(
                      scale: value,
                      alignment: Alignment.center,
                      child: child,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.shadow.withAlpha(
                            (0.12 * 255).round(),
                          ),
                          blurRadius: 24,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (article.imageUrl.isNotEmpty)
                            CachedNetworkImage(
                              imageUrl: article.imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color:
                                    theme.colorScheme.surfaceContainerHighest,
                                alignment: Alignment.center,
                                child:
                                    const CircularProgressIndicator.adaptive(),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color:
                                    theme.colorScheme.surfaceContainerHighest,
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  size: 48,
                                  color: theme.colorScheme.onSurface.withAlpha(
                                    (0.6 * 255).round(),
                                  ),
                                ),
                              ),
                            )
                          else
                            Container(
                              color: theme.colorScheme.primary.withAlpha(
                                (0.2 * 255).round(),
                              ),
                            ),
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Color(0xC0000000),
                                  Color(0x33000000),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.secondary
                                        .withAlpha((0.9 * 255).round()),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    article.category.toUpperCase(),
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(
                                          color: theme.colorScheme.onSecondary,
                                          letterSpacing: 0.8,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  article.titleFor(widget.locale),
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        height: 1.2,
                                      ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  summary,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white70,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '${article.source} $bullet $date',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        SmoothPageIndicator(
          controller: _controller,
          count: max(1, items.length),
          effect: ExpandingDotsEffect(
            activeDotColor: indicatorColor,
            dotColor: indicatorColor.withAlpha((0.3 * 255).round()),
            dotHeight: 8,
            dotWidth: 8,
            expansionFactor: 4,
          ),
        ),
      ],
    );
  }
}
