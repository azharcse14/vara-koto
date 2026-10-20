import '../core/bangla_text.dart';
import '../data/models/stop_entry.dart';

/// Ranks stops for a query typed in Bangla or English.
///
/// Same priorities as the web app: exact name (100) > exact alias (90) >
/// name prefix (50) > alias prefix (40) > name contains (30) >
/// alias contains (20) > route number (5). Also accepts either digit style,
/// so "mirpur ১০" and "মিরপুর-10" both find Mirpur-10.
List<StopEntry> searchStops(List<StopEntry> all, String query) {
  final raw = query.trim();
  if (raw.isEmpty) return all;

  final lower = raw.toLowerCase();
  final queries = <String>{lower, toEnDigits(lower), toBnDigits(lower)};
  final normalized = <String>{
    for (final q in queries) stripSeparators(q),
  }..remove('');
  final routeKey = normalizeRouteKey(raw);

  final hits = <({StopEntry stop, int score, int order})>[];
  for (var i = 0; i < all.length; i++) {
    final score = _score(all[i], queries, normalized, routeKey);
    if (score > 0) hits.add((stop: all[i], score: score, order: i));
  }

  hits.sort((a, b) =>
      a.score != b.score ? b.score.compareTo(a.score) : a.order.compareTo(b.order));
  return [for (final h in hits) h.stop];
}

int _score(
  StopEntry stop,
  Set<String> queries,
  Set<String> normalized,
  String routeKey,
) {
  var best = _match(stop.nameEn, queries, normalized, 100, 50, 30);
  if (best == 100) return best;
  final bnScore = _match(stop.nameBn, queries, normalized, 100, 50, 30);
  if (bnScore > best) best = bnScore;
  if (best == 100) return best;

  // Unlike the web version, aliases are checked even when the name matched
  // loosely, so "mirpur 10" (an exact alias) outranks "Mirpur-10 something".
  for (final alias in stop.aliases) {
    final s = _match(alias, queries, normalized, 90, 40, 20);
    if (s > best) best = s;
    if (best >= 90) break;
  }
  if (best > 0) return best;

  if (routeKey.isNotEmpty &&
      stop.routes.any((r) => r.searchKeys.any((k) => k.contains(routeKey)))) {
    return 5;
  }
  return 0;
}

int _match(
  String text,
  Set<String> queries,
  Set<String> normalized,
  int exact,
  int prefix,
  int contains,
) {
  final t = text.toLowerCase();
  if (queries.contains(t)) return exact;
  if (queries.any(t.startsWith)) return prefix;
  if (queries.any(t.contains)) return contains;
  final tn = stripSeparators(t);
  if (normalized.any(tn.contains)) return contains;
  return 0;
}
