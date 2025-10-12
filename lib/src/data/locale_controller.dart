import 'package:flutter/material.dart';

/// Keeps track of the current locale and notifies listeners on change.
class LocaleController extends ChangeNotifier {
  LocaleController({Locale initialLocale = const Locale('en')})
    : _locale = initialLocale;

  Locale _locale;

  Locale get locale => _locale;

  bool get isVietnamese => _locale.languageCode == 'vi';

  void switchLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }

  void toggleLocale() {
    switchLocale(isVietnamese ? const Locale('en') : const Locale('vi'));
  }
}
