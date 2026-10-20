import 'dart:convert';

import '../../core/bangla_text.dart';

class RouteStop {
  const RouteStop({
    required this.index,
    required this.nameEn,
    required this.nameBn,
    this.aliases = const [],
  });

  /// Position of the stop on its route; also its row/column in the fare matrix.
  final int index;
  final String nameEn;
  final String nameBn;
  final List<String> aliases;

  factory RouteStop.fromJson(Map<String, dynamic> json) => RouteStop(
        index: (json['id'] as num).toInt(),
        nameEn: json['nameEn'] as String,
        nameBn: json['nameBn'] as String,
        aliases: List<String>.from(json['aliases'] as List? ?? const []),
      );
}

class BusRoute {
  BusRoute({
    required this.id,
    required this.routeNo,
    required this.nameBn,
    required this.nameEn,
    required this.totalKm,
    required this.stops,
    required this.fareMatrix,
  })  : _indexByName = {
          for (var i = 0; i < stops.length; i++) stops[i].nameEn: i,
        },
        _indexByAlias = _buildAliasIndex(stops),
        searchKeys = {normalizeRouteKey(routeNo), normalizeRouteKey(id)}
            .toList(growable: false);

  static Map<String, int> _buildAliasIndex(List<RouteStop> stops) {
    final map = <String, int>{};
    for (var i = 0; i < stops.length; i++) {
      for (final alias in stops[i].aliases) {
        map.putIfAbsent(alias.toLowerCase(), () => i); // first stop wins
      }
    }
    return map;
  }

  final String id;
  final String routeNo;
  final String nameBn;
  final String nameEn;
  final double totalKm;
  final List<RouteStop> stops;

  /// fareMatrix[a][b] is the official fare between stop a and stop b.
  final List<List<int>> fareMatrix;

  /// Normalized route number and id, used when a rider searches "১০১" or "A-101".
  final List<String> searchKeys;

  final Map<String, int> _indexByName;
  final Map<String, int> _indexByAlias;

  /// Exact lookup by English stop name; -1 when the stop is not on this route.
  int indexOfStop(String nameEn) => _indexByName[nameEn] ?? -1;

  /// Finds the stop a rider means on this route: the exact English name,
  /// otherwise a stop that lists that name as an exact alias. The data spells
  /// some places differently per route ("Palton" / "Paltan",
  /// "Asadgate" / "Asad Gate") and links them through aliases.
  /// Never partial-matches, so "Mirpur-1" can't become "Mirpur-12".
  int resolveStop(String nameEn) =>
      _indexByName[nameEn] ?? _indexByAlias[nameEn.toLowerCase()] ?? -1;

  int fareBetween(int a, int b) => fareMatrix[a][b];

  /// Identifies the stop sequence, used to drop duplicate route entries.
  String get pathKey => stops.map((s) => s.nameEn).join('>');

  factory BusRoute.fromJson(Map<String, dynamic> json) => BusRoute(
        id: json['id'] as String,
        routeNo: json['routeNo'] as String,
        nameBn: json['nameBn'] as String,
        nameEn: json['nameEn'] as String,
        totalKm: (json['totalKm'] as num? ?? 0).toDouble(),
        stops: (json['stops'] as List)
            .map((s) => RouteStop.fromJson(s as Map<String, dynamic>))
            .toList(growable: false),
        fareMatrix: (json['fareMatrix'] as List)
            .map((row) => (row as List)
                .map((f) => (f as num?)?.toInt() ?? 0)
                .toList(growable: false))
            .toList(growable: false),
      );
}

/// Everything in assets/data/routes.json (and, later, GET /api/routes).
class RouteDataset {
  const RouteDataset({
    required this.version,
    required this.source,
    required this.routes,
  });

  /// ISO date of the fare chart, e.g. "2026-09-22". Newer data sorts higher.
  final String version;
  final String source;
  final List<BusRoute> routes;

  factory RouteDataset.fromJson(Map<String, dynamic> json) => RouteDataset(
        version: json['version'] as String? ?? '0',
        source: json['source'] as String? ?? '',
        routes: (json['routes'] as List)
            .map((r) => BusRoute.fromJson(r as Map<String, dynamic>))
            .toList(growable: false),
      );
}

/// Top-level so it can run in a background isolate via `compute`.
RouteDataset parseRouteDataset(String text) =>
    RouteDataset.fromJson(jsonDecode(text) as Map<String, dynamic>);
