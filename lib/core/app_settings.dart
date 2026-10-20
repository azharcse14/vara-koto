import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// User choices that outlive the app session. `null` locale means "follow the
/// phone's language".
class AppSettings extends ChangeNotifier {
  AppSettings._(this._prefs);

  static const _localeKey = 'locale';

  static Future<AppSettings> load() async =>
      AppSettings._(await SharedPreferences.getInstance());

  final SharedPreferences _prefs;

  Locale? get locale {
    final code = _prefs.getString(_localeKey);
    return code == null ? null : Locale(code);
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
