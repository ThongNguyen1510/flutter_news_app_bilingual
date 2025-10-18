import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../data/auth_controller.dart';
import '../pages/account_page.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, auth, _) {
        final user = auth.user;
        final l10n = AppLocalizations.of(context);
        final theme = Theme.of(context);

        Widget icon;
        if (auth.isBusy) {
          icon = const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        } else if (user != null) {
          icon = CircleAvatar(
            radius: 18,
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            child: Text(_initialsFor(user.displayName ?? user.email ?? '?')),
          );
        } else {
          icon = const Icon(Icons.person_outline);
        }

        return IconButton(
          tooltip: user != null
              ? l10n.authPanelGreeting(
                  user.displayName ?? user.email ?? l10n.authPanelGuest,
                )
              : l10n.authSignIn,
          icon: icon,
          onPressed: auth.isBusy
              ? null
              : () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AccountPage()),
                  );
                },
        );
      },
    );
  }

  static String _initialsFor(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(RegExp(r'\s+'));
    final first = _letter(parts.first);
    if (parts.length == 1) {
      return first;
    }
    final last = _letter(parts.last);
    return '$first$last';
  }

  static String _letter(String value) {
    if (value.isEmpty) return '?';
    final rune = value.runes.first;
    return String.fromCharCode(rune).toUpperCase();
  }
}
