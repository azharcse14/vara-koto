import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// User choices that outlive the app session. A `null` locale and
/// [ThemeMode.system] both mean "follow the phone".
class AppSettings extends ChangeNotifier {
  AppSettings._(this._prefs);

  static const _localeKey = 'locale';
  static const _themeKey = 'themeMode';

  static Future<AppSettings> load() async =>
      AppSettings._(await SharedPreferences.getInstance());

  final SharedPreferences _prefs;

  Locale? get locale {
    final code = _prefs.getString(_localeKey);
    return code == null ? null : Locale(code);
  }

  ThemeMode get themeMode => ThemeMode.values.asNameMap()[
          _prefs.getString(_themeKey)] ??
      ThemeMode.system;

  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setString(_themeKey, mode.name);
    notifyListeners();
  }

  Future<void> setLocale(Locale? locale) async {
    if (locale == null) {
      await _prefs.remove(_localeKey);
    } else {
      await _prefs.setString(_localeKey, locale.languageCode);
    }
    notifyListeners();
  }
}
