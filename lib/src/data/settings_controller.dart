import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Handles user appearance preferences such as theme mode and text scaling.
/// Ghi chú (VI): Quản lý cài đặt giao diện (theme sáng/tối, cỡ chữ) và lưu
/// lại bằng SharedPreferences để khôi phục ở lần mở app tiếp theo.
enum AppFontFamily { system, bookerly }

class SettingsController extends ChangeNotifier {
  SettingsController() {
    _restore();
  }

  static const _themeModeKey = 'settings_theme_mode';
  static const _textScaleKey = 'settings_text_scale';
  static const _fontFamilyKey = 'settings_font_family';

  ThemeMode _themeMode = ThemeMode.system; // Chế độ theme hiện tại
  double _textScale = 1.0; // Hệ số phóng chữ (0.85 - 1.3)
  AppFontFamily _fontFamily = AppFontFamily.system; // Font chữ
  SharedPreferences? _prefs;

  ThemeMode get themeMode => _themeMode;
  double get textScale => _textScale;
  AppFontFamily get fontFamily => _fontFamily;

  // Đọc giá trị đã lưu từ SharedPreferences và cập nhật UI
  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
    final storedTheme = prefs.getString(_themeModeKey);
    if (storedTheme != null) {
      _themeMode = _themeModeFromName(storedTheme);
    }
    _textScale = prefs.getDouble(_textScaleKey) ?? 1.0;
    final storedFont = prefs.getString(_fontFamilyKey);
    if (storedFont != null) {
      _fontFamily = storedFont == 'bookerly'
          ? AppFontFamily.bookerly
          : AppFontFamily.system;
    }
    notifyListeners();
  }

  // Đổi theme và lưu lại
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    final prefs = _prefs ??= await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.name);
  }

  // Đặt hệ số phóng chữ trong khoảng an toàn và lưu lại
  Future<void> setTextScale(double value) async {
    final newValue = value.clamp(0.85, 1.3).toDouble();
    if ((_textScale - newValue).abs() < 0.001) return;
    _textScale = newValue;
    notifyListeners();
    final prefs = _prefs ??= await SharedPreferences.getInstance();
    await prefs.setDouble(_textScaleKey, _textScale);
  }

  // Đổi font chữ và lưu lại
  Future<void> setFontFamily(AppFontFamily family) async {
    if (_fontFamily == family) return;
    _fontFamily = family;
    notifyListeners();
    final prefs = _prefs ??= await SharedPreferences.getInstance();
    await prefs.setString(
      _fontFamilyKey,
      family == AppFontFamily.bookerly ? 'bookerly' : 'system',
    );
  }

  // Chuyển tên lưu trữ sang ThemeMode tương ứng
  ThemeMode _themeModeFromName(String name) {
    switch (name) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}
