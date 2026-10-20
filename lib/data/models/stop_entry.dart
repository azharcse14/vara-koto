import 'bus_route.dart';

/// One stop in the search list, merged across every route that serves it.
class StopEntry {
  StopEntry({
    required this.nameEn,
    required this.nameBn,
    required this.aliases,
    required this.routes,
  });

  final String nameEn;
  final String nameBn;
  final List<String> aliases;

  /// Routes that stop here, one per route id.
  final List<BusRoute> routes;

  int get routeCount => routes.length;

  @override
  bool operator ==(Object other) =>
      other is StopEntry && other.nameEn == nameEn;

  @override
  int get hashCode => nameEn.hashCode;
}
