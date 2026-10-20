import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/bus_route.dart';

/// Where route and fare data comes from. The rest of the app only sees this
/// interface, so moving from bundled data to a server is a one-line change in
/// app_services.dart.
abstract class RouteDataSource {
  /// Returns usable data right away (bundled or cached). Must not need network.
  Future<RouteDataset> load();

  /// Checks for newer data. Returns null when nothing changed or offline.
  Future<RouteDataset?> refresh(String currentVersion);
}

/// Reads assets/data/routes.json, which ships inside the app.
class AssetRouteDataSource implements RouteDataSource {
  const AssetRouteDataSource({this.assetPath = 'assets/data/routes.json'});

  final String assetPath;

  @override
  Future<RouteDataset> load() async {
    final text = await rootBundle.loadString(assetPath);
    return compute(parseRouteDataset, text);
  }

  @override
  Future<RouteDataset?> refresh(String currentVersion) async => null;
}
