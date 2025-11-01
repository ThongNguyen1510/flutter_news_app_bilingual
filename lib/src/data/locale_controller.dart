import 'package:flutter/material.dart';

/// Keeps track of the current locale and notifies listeners on change.
/// Ghi chú (VI): Lưu và chuyển đổi ngôn ngữ hiển thị (vi/en) cho toàn app.
class LocaleController extends ChangeNotifier {
  LocaleController({Locale initialLocale = const Locale('vi')})
    : _locale = initialLocale;

  Locale _locale;

  Locale get locale => _locale;

  bool get isVietnamese => _locale.languageCode == 'vi'; // Đang là tiếng Việt?

  // Chuyển sang locale chỉ định và thông báo cho UI
  void switchLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }

  // Đảo ngược giữa vi <-> en
  void toggleLocale() {
    switchLocale(isVietnamese ? const Locale('en') : const Locale('vi'));
  }
}
