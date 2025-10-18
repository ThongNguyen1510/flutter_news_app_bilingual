import 'package:flutter/material.dart';

class AuthRequiredView extends StatelessWidget {
  const AuthRequiredView({
    super.key,
    required this.icon,
    required this.message,
    required this.actionLabel,
    required this.onSignIn,
  });

  final IconData icon;
  final String message;
  final String actionLabel;
  final VoidCallback onSignIn;

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
              icon,
              size: 52,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 18),
            Text(
              message,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              icon: const Icon(Icons.login),
              onPressed: onSignIn,
              label: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}
