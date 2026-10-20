import '../data/models/bus_route.dart';
import '../data/models/fare_result.dart';

/// Finds every route that serves both stops and returns the official fare
/// on each, in routes.json order like the web server's /api/fare (the web
/// app shows the first one).
///
/// Stops are matched by exact English name, then exact alias (see
/// [BusRoute.resolveStop]). The web server's findStop() also tried partial
/// matches, which made "Mirpur-1" resolve to "Mirpur-12" (or -11, -14, -10)
/// on routes that don't serve Mirpur-1 and showed a wrong fare.
List<FareResult> findFares(
  List<BusRoute> routes,
  String fromNameEn,
  String toNameEn,
) {
  final found = <FareResult>[];
  final seen = <String>{};

  for (final route in routes) {
    final a = route.resolveStop(fromNameEn);
    final b = route.resolveStop(toNameEn);
    if (a < 0 || b < 0 || a == b) continue;
    // fareData.js lists a few routes twice with identical stops (A260, A265).
    if (!seen.add('${route.id}|${route.pathKey}')) continue;
    found.add(FareResult.build(route, a, b));
  }
  return found;
}
