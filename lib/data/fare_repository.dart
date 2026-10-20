import 'dart:async';

import 'package:flutter/foundation.dart';

import '../domain/fare_finder.dart' as finder;
import '../domain/stop_index.dart';
import '../domain/stop_search.dart' as search;
import 'models/bus_route.dart';
import 'models/fare_result.dart';
import 'models/stop_entry.dart';
import 'sources/route_data_source.dart';

/// Holds the fare data in memory. All lookups run on the phone, in both local
/// and server mode, so results are instant and work without internet.
class FareRepository extends ChangeNotifier {
  FareRepository(this._source);

  final RouteDataSource _source;

  RouteDataset? _dataset;
  List<StopEntry> _stops = const [];
  Set<String> _busStops = const {};
  int _routeCount = 0;
  int _minFare = 0;
  Object? _loadError;
  bool _loading = false;

  bool get isReady => _dataset != null;
  Object? get loadError => _loadError;
  List<StopEntry> get stops => _stops;
  String get dataVersion => _dataset?.version ?? '';

  /// Distinct route numbers (some routes have two variants with one number).
  int get routeCount => _routeCount;
  int get minFare => _minFare;

  Future<void> init() async {
    if (_loading || isReady) return;
    _loading = true;
    _loadError = null;
    notifyListeners();
    try {
      _apply(await _source.load());
    } catch (e, st) {
      debugPrint('Failed to load fare data: $e\n$st');
      _loadError = e;
      notifyListeners();
    } finally {
      _loading = false;
    }
    if (isReady) unawaited(refresh());
  }

  /// Pulls newer data in server mode. Returns true when data changed.
  Future<bool> refresh() async {
    final current = _dataset;
    if (current == null) return false;
    final fresh = await _source.refresh(current.version);
    if (fresh == null) return false;
    _apply(fresh);
    return true;
  }

  List<StopEntry> searchStops(String query) =>
      search.searchStops(_stops, query);

  List<FareResult> findFares(StopEntry from, StopEntry to) =>
      finder.findFares(_dataset?.routes ?? const [], from.nameEn, to.nameEn);

  /// Names of buses that run along [result]'s road, in the data's order.
  ///
  /// A bus must stop at both ends and at three quarters of the stops in
  /// between that the bus list knows (it leaves some out). One that skips
  /// more takes another road, e.g. Safety Druti goes from Mirpur-12 to New
  /// Market via Kazipara, not via Mirpur-1 like route A356, so this fare
  /// wouldn't be its fare.
  List<String> busesFor(FareResult result) {
    final known = [
      for (final stop in result.path)
        if (_busStops.contains(stop.nameEn)) stop.nameEn,
    ];
    return {
      for (final bus in _dataset?.buses ?? const <Bus>[])
        if (bus.serves(result.from.nameEn, result.to.nameEn) &&
            known.where((s) => !bus.stops.contains(s)).length * 4 <=
                known.length)
          bus.name,
    }.toList(growable: false);
  }

  void _apply(RouteDataset data) {
    _dataset = data;
    _stops = buildStopIndex(data.routes);
    _busStops = {for (final bus in data.buses) ...bus.stops};
    _routeCount = data.routes.map((r) => r.id).toSet().length;

    var min = 0;
    for (final route in data.routes) {
      for (final row in route.fareMatrix) {
        for (final fare in row) {
          if (fare > 0 && (min == 0 || fare < min)) min = fare;
        }
      }
    }
    _minFare = min;
    notifyListeners();
  }
}
