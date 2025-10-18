import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../data/article_tracker.dart';
import '../../data/auth_controller.dart';
import '../../data/settings_controller.dart';
import '../../utils/auth_dialog.dart';
import 'favorite_articles_page.dart';
import 'reading_history_page.dart';
import 'user_profile_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.accountPageTitle)),
      body: Consumer3<AuthController, SettingsController, ArticleTracker>(
        builder: (context, auth, settings, tracker, _) {
          final favoritesCount = tracker.favorites.length;
          final historyCount = tracker.history.length;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _AccountCard(auth: auth),
              const SizedBox(height: 16),
              _AppearanceCard(settings: settings),
              const SizedBox(height: 16),
              _ContentCard(
                favoritesCount: favoritesCount,
                historyCount: historyCount,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({required this.auth});

  final AuthController auth;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = auth.user;
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.accountOverviewTitle,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            if (user != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        child: Text(
                          _initialFor(
                            user.displayName ?? user.email ?? l10n.authPanelGuest,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.authPanelGreeting(
                                user.displayName ??
                                    user.email ??
                                    l10n.authPanelGuest,
                              ),
                              style: theme.textTheme.titleMedium,
                            ),
                            if (user.email != null)
                              Text(
                                user.email!,
                                style: theme.textTheme.bodyMedium,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton.icon(
                        icon: const Icon(Icons.person),
                        label: Text(l10n.accountProfileButton),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const UserProfilePage(),
                            ),
                          );
                        },
                      ),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.logout),
                        label: Text(l10n.authSignOut),
                        onPressed: auth.isBusy ? null : auth.signOut,
                      ),
                    ],
                  ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.accountSignInDescription,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton.icon(
                        icon: const Icon(Icons.login),
                        label: Text(l10n.authSignIn),
                        onPressed: auth.isBusy
                            ? null
                            : () => showAuthDialog(
                                  context,
                                  auth,
                                  isRegister: false,
                                ),
                      ),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.person_add_alt_1),
                        label: Text(l10n.authRegister),
                        onPressed: auth.isBusy
                            ? null
                            : () => showAuthDialog(
                                  context,
                                  auth,
                                  isRegister: true,
                                ),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

String _initialFor(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return '?';
  final codePoint = trimmed.runes.first;
  return String.fromCharCode(codePoint).toUpperCase();
}

class _AppearanceCard extends StatelessWidget {
  const _AppearanceCard({required this.settings});

  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final textScale = settings.textScale;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.accountAppearanceTitle,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.color_lens_outlined),
              title: Text(l10n.themeModeLabel),
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton<ThemeMode>(
                  value: settings.themeMode,
                  onChanged: (mode) {
                    if (mode != null) {
                      settings.setThemeMode(mode);
                    }
                  },
                  items: [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text(l10n.themeModeSystem),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text(l10n.themeModeLight),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text(l10n.themeModeDark),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.textSizeLabel,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            Slider(
              value: textScale,
              onChanged: (value) => settings.setTextScale(value),
              min: 0.85,
              max: 1.3,
              divisions: 9,
              label: '${(textScale * 100).round()}%',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.textSizeSmall),
                Text('${(textScale * 100).round()}%'),
                Text(l10n.textSizeLarge),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({
    required this.favoritesCount,
    required this.historyCount,
  });

  final int favoritesCount;
  final int historyCount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = context.watch<AuthController>();

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.favorite_outline),
            title: Text(l10n.menuFavorites),
            subtitle: Text(l10n.accountItemsCount(favoritesCount)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _handleContentTap(
                context,
                auth,
                message: l10n.favoritesLoginRequired,
                pageBuilder: () => const FavoriteArticlesPage(),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.history_rounded),
            title: Text(l10n.menuHistory),
            subtitle: Text(l10n.accountItemsCount(historyCount)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _handleContentTap(
                context,
                auth,
                message: l10n.historyLoginRequired,
                pageBuilder: () => const ReadingHistoryPage(),
              );
            },
          ),
        ],
      ),
    );
  }
}

void _handleContentTap(
  BuildContext context,
  AuthController auth, {
  required String message,
  required Widget Function() pageBuilder,
}) {
  if (auth.user == null) {
    final l10n = AppLocalizations.of(context);
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
    return;
  }

  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => pageBuilder()),
  );
}
