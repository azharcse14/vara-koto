import 'dart:convert';
import 'dart:io' show File;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../models/bus_route.dart';
import 'route_data_source.dart';

/// Server mode. Downloads GET {baseUrl}/routes (same JSON as the bundled
/// asset), caches it on the phone, and never blocks the app on the network:
/// [load] returns the newest of cache and bundled data, and [refresh] runs in
/// the background.
class RemoteRouteDataSource implements RouteDataSource {
  RemoteRouteDataSource({
    required this.baseUrl,
    http.Client? client,
    RouteDataSource? bundled,
  })  : _client = client ?? http.Client(),
        _bundled = bundled ?? const AssetRouteDataSource();

  final String baseUrl;
  final http.Client _client;
  final RouteDataSource _bundled;

  static const _cacheFileName = 'routes_cache.json';

  @override
  Future<RouteDataset> load() async {
    final bundled = await _bundled.load();
    final cached = await _readCache();
    // An app update can ship newer data than an old cache, so compare.
    if (cached != null && cached.version.compareTo(bundled.version) > 0) {
      return cached;
    }
    return bundled;
  }

  @override
  Future<RouteDataset?> refresh(String currentVersion) async {
    try {
      final res = await _client
          .get(Uri.parse('$baseUrl/routes'),
              headers: const {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 15));
      if (res.statusCode != 200) return null;

      // Decode as UTF-8 explicitly so Bangla survives a missing charset header.
      final body = utf8.decode(res.bodyBytes);
      final fresh = await compute(parseRouteDataset, body);
      if (fresh.routes.isEmpty || fresh.version == currentVersion) return null;

      await _writeCache(body);
      return fresh;
    } catch (e) {
      debugPrint('Route refresh skipped: $e');
      return null;
    }
  }

  Future<File?> _cacheFile() async {
    if (kIsWeb) return null; // no file system on web; bundled data is used
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/$_cacheFileName');
  }

  Future<RouteDataset?> _readCache() async {
    try {
      final file = await _cacheFile();
      if (file == null || !await file.exists()) return null;
      return compute(parseRouteDataset, await file.readAsString());
    } catch (e) {
      debugPrint('Ignoring unreadable route cache: $e');
      return null;
    }
  }

  Future<void> _writeCache(String body) async {
    try {
      final file = await _cacheFile();
      await file?.writeAsString(body, flush: true);
    } catch (e) {
      debugPrint('Could not write route cache: $e');
    }
  }
}
