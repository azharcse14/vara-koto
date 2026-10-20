import 'bus_route.dart';

class FareSegment {
  const FareSegment({required this.from, required this.to, required this.fare});

  final RouteStop from;
  final RouteStop to;
  final int fare;
}

/// The fare between two stops on one route.
class FareResult {
  const FareResult({
    required this.route,
    required this.fromIndex,
    required this.toIndex,
    required this.fare,
    required this.path,
    required this.segments,
  });

  factory FareResult.build(BusRoute route, int fromIndex, int toIndex) {
    final step = fromIndex < toIndex ? 1 : -1;
    final path = <RouteStop>[
      for (var i = fromIndex; i != toIndex + step; i += step) route.stops[i],
    ];
    final segments = <FareSegment>[
      for (var k = 0; k < path.length - 1; k++)
        FareSegment(
          from: path[k],
          to: path[k + 1],
          fare: route.fareBetween(path[k].index, path[k + 1].index),
        ),
    ];
    return FareResult(
      route: route,
      fromIndex: fromIndex,
      toIndex: toIndex,
      fare: route.fareBetween(fromIndex, toIndex),
      path: path,
      segments: segments,
    );
  }

  final BusRoute route;
  final int fromIndex;
  final int toIndex;
  final int fare;

  /// Stops in the direction of travel, boarding stop first.
  final List<RouteStop> path;
  final List<FareSegment> segments;

  RouteStop get from => path.first;
  RouteStop get to => path.last;

  /// Fare from the boarding stop to [stop], i.e. what you pay to get off there.
  int fareTo(RouteStop stop) => route.fareBetween(fromIndex, stop.index);
}
