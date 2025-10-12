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
}
