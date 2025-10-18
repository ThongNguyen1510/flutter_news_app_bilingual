// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Viet News';

  @override
  String get homeTitle => 'Top stories';

  @override
  String get categories => 'Categories';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageVietnamese => 'Vietnamese';

  @override
  String get changeLanguage => 'Change language';

  @override
  String get tabVietnam => 'Vietnam news';

  @override
  String get tabInternational => 'World news';

  @override
  String get seeDetails => 'Read detail';

  @override
  String publishedAt(String date) {
    return 'Published $date';
  }

  @override
  String get newsListError => 'Unable to load the latest stories.';

  @override
  String get emptyState => 'No news available right now.';

  @override
  String get retry => 'Retry';

  @override
  String lastUpdated(String time) {
    return 'Last updated $time';
  }

  @override
  String get searchHint => 'Search news...';

  @override
  String get category_all => 'All';

  @override
  String get category_business => 'Business';

  @override
  String get category_culture => 'Culture';

  @override
  String get category_science => 'Science';

  @override
  String get category_sports => 'Sports';

  @override
  String get category_technology => 'Technology';

  @override
  String get authPanelTitle => 'Account';

  @override
  String get authPanelGuest => 'Browsing as guest';

  @override
  String get authPanelPrompt =>
      'Sign in to synchronise your reading experience.';

  @override
  String authPanelGreeting(String name) {
    return 'Hello $name';
  }

  @override
  String get authSignIn => 'Sign in';

  @override
  String get authRegister => 'Register';

  @override
  String get authSignOut => 'Sign out';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authConfirmPasswordLabel => 'Confirm password';

  @override
  String get authCancel => 'Cancel';

  @override
  String get authDialogSignInTitle => 'Sign in';

  @override
  String get authDialogRegisterTitle => 'Create account';

  @override
  String get authErrorInvalidCredentials => 'Email or password is incorrect.';

  @override
  String get authErrorEmailInUse => 'This email is already in use.';

  @override
  String get authErrorWeakPassword => 'Password must be at least 6 characters.';

  @override
  String get authErrorPasswordMismatch => 'Passwords do not match.';

  @override
  String get authErrorInvalidEmail => 'Email format is invalid.';

  @override
  String get authErrorOperationNotAllowed =>
      'Email & password sign-in is disabled for this project.';

  @override
  String get authErrorTooManyRequests => 'Too many attempts. Try again later.';

  @override
  String get authErrorUnknown => 'Something went wrong. Please try again.';

  @override
  String get menuFavorites => 'Favorite articles';

  @override
  String get menuHistory => 'Reading history';

  @override
  String get favoritesLoginRequired =>
      'Please sign in to view your saved articles.';

  @override
  String get favoritesTitle => 'Favorites';

  @override
  String get favoritesEmpty => 'You haven\'t saved any articles yet.';

  @override
  String get favoritesSaveTooltip => 'Save to favorites';

  @override
  String get favoritesRemoveTooltip => 'Remove from favorites';

  @override
  String get historyTitle => 'Reading history';

  @override
  String get historyEmpty => 'No articles read yet.';

  @override
  String get historyClear => 'Clear history';

  @override
  String get historyClearConfirm =>
      'This will remove your entire reading history.';

  @override
  String get historyLoginRequired =>
      'Please sign in to view your reading history.';

  @override
  String get accountPageTitle => 'Account & settings';

  @override
  String get accountOverviewTitle => 'Account';

  @override
  String get accountSignInDescription =>
      'Sign in to manage your account and saved content.';

  @override
  String get accountProfileButton => 'View profile';

  @override
  String get accountAppearanceTitle => 'Appearance';

  @override
  String get themeModeLabel => 'Theme';

  @override
  String get themeModeSystem => 'System default';

  @override
  String get themeModeLight => 'Light';

  @override
  String get themeModeDark => 'Dark';

  @override
  String get textSizeLabel => 'Text size';

  @override
  String get textSizeSmall => 'Smaller';

  @override
  String get textSizeLarge => 'Larger';

  @override
  String accountItemsCount(int count) {
    return '$count items';
  }

  @override
  String get profilePageTitle => 'User profile';

  @override
  String get profileDisplayNameLabel => 'Display name';

  @override
  String get profileDisplayNameHint => 'How your name appears in the app';

  @override
  String get profileUpdateButton => 'Save changes';

  @override
  String get profileResetButton => 'Reset';

  @override
  String get profileUpdateSuccess => 'Profile updated successfully.';

  @override
  String get profileEmailLabel => 'Email';

  @override
  String get profileUidLabel => 'User ID';

  @override
  String get profileVerifiedLabel => 'Email verification';

  @override
  String get profileVerifiedYes => 'Verified';

  @override
  String get profileVerifiedNo => 'Not verified';

  @override
  String get profileCreationLabel => 'Created on';

  @override
  String get profileLastSignInLabel => 'Last sign-in';

  @override
  String get profileErrorInvalidDisplayName =>
      'Display name must not be empty.';

  @override
  String get profileErrorRequiresRecentLogin =>
      'Please sign in again to continue.';

  @override
  String get profileErrorUpdateFailed =>
      'Could not update your profile. Please try again.';

  @override
  String get profileSignInRequired => 'Please sign in to view your profile.';
}
