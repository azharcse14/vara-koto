import '../data/models/bus_route.dart';
import '../data/models/stop_entry.dart';

/// Merges stops from every route into one list (one entry per English name),
/// in the order they first appear. Replaces the web app's hand-built allStops.js,
/// so routes.json is the only file to update when fares change.
List<StopEntry> buildStopIndex(List<BusRoute> routes) {
  final order = <String>[];
  final nameBn = <String, String>{};
  final aliases = <String, Set<String>>{};
  final routesByStop = <String, Map<String, BusRoute>>{};

  for (final route in routes) {
    for (final stop in route.stops) {
      final key = stop.nameEn;
      if (!nameBn.containsKey(key)) {
        order.add(key);
        nameBn[key] = stop.nameBn;
        aliases[key] = <String>{};
        routesByStop[key] = <String, BusRoute>{};
      }
      aliases[key]!.addAll(stop.aliases);
      routesByStop[key]!.putIfAbsent(route.id, () => route);
    }
  }

  return [
    for (final key in order)
      StopEntry(
        nameEn: key,
        nameBn: nameBn[key]!,
        aliases: aliases[key]!.toList(growable: false),
        routes: routesByStop[key]!.values.toList(growable: false),
      ),
  ];
}
