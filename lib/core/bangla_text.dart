const String _bnDigits = '০১২৩৪৫৬৭৮৯';
final RegExp _bnDigit = RegExp('[০-৯]');
final RegExp _enDigit = RegExp('[0-9]');
final RegExp _separators = RegExp(r'[-_ ]');
final RegExp _routeSeparators = RegExp(r'[\s\-_()]');
final RegExp _leadingBnA = RegExp(r'^এ(?=[\s\-_]*[0-9]|$)');

/// "মিরপুর-১০" -> "মিরপুর-10"
String toEnDigits(String s) =>
    s.replaceAllMapped(_bnDigit, (m) => _bnDigits.indexOf(m[0]!).toString());

/// 12 -> "১২"
String toBnDigits(Object value) => value
    .toString()
    .replaceAllMapped(_enDigit, (m) => _bnDigits[int.parse(m[0]!)]);

/// "mirpur-10" -> "mirpur10"
String stripSeparators(String s) => s.replaceAll(_separators, '');

/// Turns every way people write a route number into one key:
/// "এ-১০১", "A-101", "a101", "এ ১০১" -> "a101".
/// Named routes keep their name: "BAIPAIL_KERANIGANJ" -> "baipailkeraniganj".
String normalizeRouteKey(String s) {
  var t = toEnDigits(s.trim().toLowerCase());
  t = t.replaceFirst(_leadingBnA, 'a');
  return t.replaceAll(_routeSeparators, '');
}

/// 28.8 -> "২৮.৮", 15.0 -> "১৫"
String formatKmBn(double km) {
  final text =
      km == km.roundToDouble() ? km.toInt().toString() : km.toString();
  return toBnDigits(text);
}

String taka(int amount) => '৳$amount';
