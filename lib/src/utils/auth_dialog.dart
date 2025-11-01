import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../data/auth_controller.dart';
import 'auth_error_mapper.dart';

Future<void> showAuthDialog(
  BuildContext context,
  AuthController auth, {
  required bool isRegister,
}) async {
  final l10n = AppLocalizations.of(context);
  auth.clearError();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      String? localError;
      bool submitting = false;

      return StatefulBuilder(
        builder: (context, setState) {
          Future<void> submit() async {
            FocusScope.of(dialogContext).unfocus();
            if (isRegister &&
                passwordController.text != confirmController.text) {
              setState(() {
                localError = l10n.authErrorPasswordMismatch;
              });
              return;
            }

            setState(() {
              submitting = true;
              localError = null;
            });

            final success = isRegister
                ? await auth.registerWithEmail(
                    email: emailController.text.trim(),
                    password: passwordController.text,
                  )
                : await auth.signInWithEmail(
                    email: emailController.text.trim(),
                    password: passwordController.text,
                  );

            if (!dialogContext.mounted) {
              return;
            }

            if (success) {
              Navigator.of(dialogContext).pop();
            } else {
              setState(() {
                submitting = false;
                localError = authErrorMessage(l10n, auth.errorCode);
              });
            }
          }

          return AlertDialog(
            title: Text(
              isRegister
                  ? l10n.authDialogRegisterTitle
                  : l10n.authDialogSignInTitle,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: l10n.authEmailLabel),
                  autofillHints: const [AutofillHints.email],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration:
                      InputDecoration(labelText: l10n.authPasswordLabel),
                  autofillHints: const [AutofillHints.password],
                ),
                if (isRegister) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: confirmController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: l10n.authConfirmPasswordLabel,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: const [
                    Expanded(child: Divider()),
                    SizedBox(width: 8),
                    Text('or'),
                    SizedBox(width: 8),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.login),
                    label: const Text('Continue with Google'),
                    onPressed: submitting
                        ? null
                        : () async {
                            FocusScope.of(dialogContext).unfocus();
                            setState(() {
                              submitting = true;
                              localError = null;
                            });
                            final ok = await auth.signInWithGoogle();
                            if (!dialogContext.mounted) return;
                            if (ok) {
                              Navigator.of(dialogContext).pop();
                            } else {
                              setState(() {
                                submitting = false;
                                localError = authErrorMessage(l10n, auth.errorCode);
                              });
                            }
                          },
                  ),
                ),
                if (localError != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    localError!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: submitting
                    ? null
                    : () => Navigator.of(dialogContext).pop(),
                child: Text(l10n.authCancel),
              ),
              FilledButton(
                onPressed: submitting ? null : submit,
                child: submitting
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(isRegister ? l10n.authRegister : l10n.authSignIn),
              ),
            ],
          );
        },
      );
    },
  );
}
