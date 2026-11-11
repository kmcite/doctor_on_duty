import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  ThemeController({bool initialDark = false}) : _isDark = initialDark;

  static const _prefsKey = 'theme_dark';

  bool _isDark;

  bool get isDark => _isDark;

  static Future<bool> readPersistedDark() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefsKey) ?? false;
  }

  Future<void> setDark(bool value) async {
    if (_isDark == value) return;
    _isDark = value;
    notifyListeners();
    await _persist();
  }

  Future<void> toggle() async {
    await setDark(!_isDark);
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, _isDark);
  }
}
