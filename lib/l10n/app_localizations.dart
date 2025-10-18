import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Viet News'**
  String get appTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Top stories'**
  String get homeTitle;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageVietnamese.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get languageVietnamese;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguage;

  /// No description provided for @tabVietnam.
  ///
  /// In en, this message translates to:
  /// **'Vietnam news'**
  String get tabVietnam;

  /// No description provided for @tabInternational.
  ///
  /// In en, this message translates to:
  /// **'World news'**
  String get tabInternational;

  /// No description provided for @seeDetails.
  ///
  /// In en, this message translates to:
  /// **'Read detail'**
  String get seeDetails;

  /// No description provided for @publishedAt.
  ///
  /// In en, this message translates to:
  /// **'Published {date}'**
  String publishedAt(String date);

  /// No description provided for @newsListError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load the latest stories.'**
  String get newsListError;

  /// No description provided for @emptyState.
  ///
  /// In en, this message translates to:
  /// **'No news available right now.'**
  String get emptyState;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated {time}'**
  String lastUpdated(String time);

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search news...'**
  String get searchHint;

  /// No description provided for @category_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get category_all;

  /// No description provided for @category_business.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get category_business;

  /// No description provided for @category_culture.
  ///
  /// In en, this message translates to:
  /// **'Culture'**
  String get category_culture;

  /// No description provided for @category_science.
  ///
  /// In en, this message translates to:
  /// **'Science'**
  String get category_science;

  /// No description provided for @category_sports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get category_sports;

  /// No description provided for @category_technology.
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get category_technology;

  /// No description provided for @authPanelTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get authPanelTitle;

  /// No description provided for @authPanelGuest.
  ///
  /// In en, this message translates to:
  /// **'Browsing as guest'**
  String get authPanelGuest;

  /// No description provided for @authPanelPrompt.
  ///
  /// In en, this message translates to:
  /// **'Sign in to synchronise your reading experience.'**
  String get authPanelPrompt;

  /// No description provided for @authPanelGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello {name}'**
  String authPanelGreeting(String name);

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignIn;

  /// No description provided for @authRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get authRegister;

  /// No description provided for @authSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get authSignOut;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get authConfirmPasswordLabel;

  /// No description provided for @authCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get authCancel;

  /// No description provided for @authDialogSignInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authDialogSignInTitle;

  /// No description provided for @authDialogRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authDialogRegisterTitle;

  /// No description provided for @authErrorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Email or password is incorrect.'**
  String get authErrorInvalidCredentials;

  /// No description provided for @authErrorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already in use.'**
  String get authErrorEmailInUse;

  /// No description provided for @authErrorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get authErrorWeakPassword;

  /// No description provided for @authErrorPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get authErrorPasswordMismatch;

  /// No description provided for @authErrorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Email format is invalid.'**
  String get authErrorInvalidEmail;

  /// No description provided for @authErrorOperationNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Email & password sign-in is disabled for this project.'**
  String get authErrorOperationNotAllowed;

  /// No description provided for @authErrorTooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Try again later.'**
  String get authErrorTooManyRequests;

  /// No description provided for @authErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get authErrorUnknown;

  /// No description provided for @menuFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorite articles'**
  String get menuFavorites;

  /// No description provided for @menuHistory.
  ///
  /// In en, this message translates to:
  /// **'Reading history'**
  String get menuHistory;

  /// No description provided for @favoritesLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to view your saved articles.'**
  String get favoritesLoginRequired;

  /// No description provided for @favoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favoritesTitle;

  /// No description provided for @favoritesEmpty.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t saved any articles yet.'**
  String get favoritesEmpty;

  /// No description provided for @favoritesSaveTooltip.
  ///
  /// In en, this message translates to:
  /// **'Save to favorites'**
  String get favoritesSaveTooltip;

  /// No description provided for @favoritesRemoveTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get favoritesRemoveTooltip;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Reading history'**
  String get historyTitle;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No articles read yet.'**
  String get historyEmpty;

  /// No description provided for @historyClear.
  ///
  /// In en, this message translates to:
  /// **'Clear history'**
  String get historyClear;

  /// No description provided for @historyClearConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will remove your entire reading history.'**
  String get historyClearConfirm;

  /// No description provided for @historyLoginRequired.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to view your reading history.'**
  String get historyLoginRequired;

  /// No description provided for @accountPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Account & settings'**
  String get accountPageTitle;

  /// No description provided for @accountOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountOverviewTitle;

  /// No description provided for @accountSignInDescription.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage your account and saved content.'**
  String get accountSignInDescription;

  /// No description provided for @accountProfileButton.
  ///
  /// In en, this message translates to:
  /// **'View profile'**
  String get accountProfileButton;

  /// No description provided for @accountAppearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get accountAppearanceTitle;

  /// No description provided for @themeModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeModeLabel;

  /// No description provided for @themeModeSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get themeModeSystem;

  /// No description provided for @themeModeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeModeLight;

  /// No description provided for @themeModeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeModeDark;

  /// No description provided for @textSizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Text size'**
  String get textSizeLabel;

  /// No description provided for @textSizeSmall.
  ///
  /// In en, this message translates to:
  /// **'Smaller'**
  String get textSizeSmall;

  /// No description provided for @textSizeLarge.
  ///
  /// In en, this message translates to:
  /// **'Larger'**
  String get textSizeLarge;

  /// No description provided for @accountItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String accountItemsCount(int count);

  /// No description provided for @profilePageTitle.
  ///
  /// In en, this message translates to:
  /// **'User profile'**
  String get profilePageTitle;

  /// No description provided for @profileDisplayNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get profileDisplayNameLabel;

  /// No description provided for @profileDisplayNameHint.
  ///
  /// In en, this message translates to:
  /// **'How your name appears in the app'**
  String get profileDisplayNameHint;

  /// No description provided for @profileUpdateButton.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get profileUpdateButton;

  /// No description provided for @profileResetButton.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get profileResetButton;

  /// No description provided for @profileUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully.'**
  String get profileUpdateSuccess;

  /// No description provided for @profileEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get profileEmailLabel;

  /// No description provided for @profileUidLabel.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get profileUidLabel;

  /// No description provided for @profileVerifiedLabel.
  ///
  /// In en, this message translates to:
  /// **'Email verification'**
  String get profileVerifiedLabel;

  /// No description provided for @profileVerifiedYes.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get profileVerifiedYes;

  /// No description provided for @profileVerifiedNo.
  ///
  /// In en, this message translates to:
  /// **'Not verified'**
  String get profileVerifiedNo;

  /// No description provided for @profileCreationLabel.
  ///
  /// In en, this message translates to:
  /// **'Created on'**
  String get profileCreationLabel;

  /// No description provided for @profileLastSignInLabel.
  ///
  /// In en, this message translates to:
  /// **'Last sign-in'**
  String get profileLastSignInLabel;

  /// No description provided for @profileErrorInvalidDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Display name must not be empty.'**
  String get profileErrorInvalidDisplayName;

  /// No description provided for @profileErrorRequiresRecentLogin.
  ///
  /// In en, this message translates to:
  /// **'Please sign in again to continue.'**
  String get profileErrorRequiresRecentLogin;

  /// No description provided for @profileErrorUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update your profile. Please try again.'**
  String get profileErrorUpdateFailed;

  /// No description provided for @profileSignInRequired.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to view your profile.'**
  String get profileSignInRequired;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
