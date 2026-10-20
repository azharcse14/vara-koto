import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';
import 'bangla_text.dart' as bangla;

export '../l10n/app_localizations.dart';

/// Strings, digits and names in the language the app is showing.
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  bool get isBn => Localizations.localeOf(this).languageCode == 'bn';

  /// 12 -> "১২" in Bangla, "12" in English.
  String digits(Object value) => isBn ? bangla.toBnDigits(value) : '$value';

  String taka(int amount) => bangla.taka(amount, bn: isBn);

  String km(double value) => bangla.formatKm(value, bn: isBn);

  /// Picks the stop or route name for the current language.
  String name(String bn, String en) => isBn ? bn : en;

  /// The other language's name, shown smaller beside [name].
  String altName(String bn, String en) => isBn ? en : bn;
}
