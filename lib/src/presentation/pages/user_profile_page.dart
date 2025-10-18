import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../data/auth_controller.dart';
import '../../utils/auth_error_mapper.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late final TextEditingController _displayNameController;
  User? _lastUser;
  bool _isSaving = false;
  String? _localError;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController();
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Consumer<AuthController>(
      builder: (context, auth, _) {
        final user = auth.user;
        if (_lastUser != user) {
          _lastUser = user;
          _displayNameController.text = user?.displayName ?? '';
        }

        return Scaffold(
          appBar: AppBar(title: Text(l10n.profilePageTitle)),
          body: user == null
              ? _SignedOutState(onClose: () => Navigator.of(context).pop())
              : _buildProfileContent(context, auth, user),
        );
      },
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    AuthController auth,
    User user,
  ) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final dateFormatter = DateFormat.yMMMd(localeTag).add_Hm();
    final creation = user.metadata.creationTime?.toLocal();
    final lastSignIn = user.metadata.lastSignInTime?.toLocal();
    final creationText =
        creation != null ? dateFormatter.format(creation) : '—';
    final lastSignInText =
        lastSignIn != null ? dateFormatter.format(lastSignIn) : '—';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.profileDisplayNameLabel,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _displayNameController,
                  decoration: InputDecoration(
                    hintText: l10n.profileDisplayNameHint,
                  ),
                ),
                if (_localError != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _localError!,
                    style: TextStyle(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    FilledButton(
                      onPressed: _isSaving
                          ? null
                        : () => _saveProfile(auth),
                      child: _isSaving
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.profileUpdateButton),
                    ),
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: _isSaving
                          ? null
                          : () {
                              setState(() {
                                _displayNameController.text =
                                    user.displayName ?? '';
                                _localError = null;
                              });
                            },
                      child: Text(l10n.profileResetButton),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.email_outlined),
                title: Text(l10n.profileEmailLabel),
                subtitle: Text(user.email ?? '—'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.badge_outlined),
                title: Text(l10n.profileUidLabel),
                subtitle: Text(user.uid),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.verified_outlined),
                title: Text(l10n.profileVerifiedLabel),
                subtitle: Text(
                  user.emailVerified
                      ? l10n.profileVerifiedYes
                      : l10n.profileVerifiedNo,
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.calendar_today_outlined),
                title: Text(l10n.profileCreationLabel),
                subtitle: Text(creationText),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: Text(l10n.profileLastSignInLabel),
                subtitle: Text(lastSignInText),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _saveProfile(AuthController auth) async {
    setState(() {
      _isSaving = true;
      _localError = null;
    });

    final success =
        await auth.updateDisplayName(_displayNameController.text.trim());
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);

    if (success) {
      setState(() {
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.profileUpdateSuccess)),
      );
    } else {
      setState(() {
        _isSaving = false;
        _localError = authErrorMessage(l10n, auth.errorCode);
      });
    }
  }
}

class _SignedOutState extends StatelessWidget {
  const _SignedOutState({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_outline,
              size: 48,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.profileSignInRequired,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onClose,
              child: Text(l10n.authSignIn),
            ),
          ],
        ),
      ),
    );
  }
}

