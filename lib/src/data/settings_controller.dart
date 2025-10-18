import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Handles user appearance preferences such as theme mode and text scaling.
class SettingsController extends ChangeNotifier {
  SettingsController() {
    _restore();
  }

  static const _themeModeKey = 'settings_theme_mode';
  static const _textScaleKey = 'settings_text_scale';

  ThemeMode _themeMode = ThemeMode.system;
  double _textScale = 1.0;
  SharedPreferences? _prefs;

  ThemeMode get themeMode => _themeMode;
  double get textScale => _textScale;

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
    final storedTheme = prefs.getString(_themeModeKey);
    if (storedTheme != null) {
      _themeMode = _themeModeFromName(storedTheme);
    }
    _textScale = prefs.getDouble(_textScaleKey) ?? 1.0;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    final prefs = _prefs ??= await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.name);
  }

  Future<void> setTextScale(double value) async {
    final newValue = value.clamp(0.85, 1.3).toDouble();
    if ((_textScale - newValue).abs() < 0.001) return;
    _textScale = newValue;
    notifyListeners();
    final prefs = _prefs ??= await SharedPreferences.getInstance();
    await prefs.setDouble(_textScaleKey, _textScale);
  }

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
