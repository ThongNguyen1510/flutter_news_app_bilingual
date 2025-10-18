import '../../l10n/app_localizations.dart';

String? authErrorMessage(AppLocalizations l10n, String? code) {
  switch (code) {
    case 'invalidCredentials':
      return l10n.authErrorInvalidCredentials;
    case 'emailInUse':
      return l10n.authErrorEmailInUse;
    case 'weakPassword':
      return l10n.authErrorWeakPassword;
    case 'invalidEmail':
      return l10n.authErrorInvalidEmail;
    case 'operationNotAllowed':
      return l10n.authErrorOperationNotAllowed;
    case 'tooManyRequests':
      return l10n.authErrorTooManyRequests;
    case 'invalidCredentialsOrUser':
      return l10n.authErrorInvalidCredentials;
    case 'profileInvalidDisplayName':
      return l10n.profileErrorInvalidDisplayName;
    case 'profileRequiresRecentLogin':
      return l10n.profileErrorRequiresRecentLogin;
    case 'profileUpdateFailed':
      return l10n.profileErrorUpdateFailed;
    case 'profileSignInRequired':
      return l10n.profileSignInRequired;
    case 'authErrorPasswordMismatch':
      return l10n.authErrorPasswordMismatch;
    case 'profileUnknown':
      return l10n.profileErrorUpdateFailed;
    case 'unknownError':
      return l10n.authErrorUnknown;
    default:
      return code == null ? null : l10n.authErrorUnknown;
  }
}
